import 'dart:async';


import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/error.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SendingFormState extends TransactionFormState {
  const SendingFormState();
}

@immutable
class SentFormState extends TransactionFormState {
  const SentFormState();
}

@immutable
class FatalErrorFormState extends TransactionFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());

  //final TransactionRoutes _transactionRoute = TransactionRoutes();

  void save(Transaction transactionCreated, String password,
      BuildContext context) async {
    emit(SendingFormState());
    await _send(
      transactionCreated,
      password,
      context,
    );
  }


  _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    await TransactionRoutes()
        .save(transactionCreated, password)
        .then((transaction) => emit(SentFormState()))
        .catchError((error) {
      emit(FatalErrorFormState(error.message));
    }, test: (error) => error is HttpException).catchError((error) {
      emit(FatalErrorFormState('Timeout submitting the transaction'));
    }, test: (error) => error is TimeoutException).catchError((error) {
      emit(FatalErrorFormState(error.message));
    });
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;
  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
        create: (BuildContext context) {
          return TransactionFormCubit();
        },
        child: BlocListener<TransactionFormCubit, TransactionFormState>(
            listener: (context, state) {
              // if (state is SentFormState) {
              //   Navigator.pop(context);
              // }
            },
            child: TransactionForm(_contact)));
  }
}

class TransactionForm extends StatelessWidget {
  final Contact _contact;
  TransactionForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
        builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm(_contact);
      }
      if (state is SendingFormState) {
        return ProgressView();
      }

      if (state is SentFormState) {
        return SuccessDialog('Successful transaction');
      }

      if (state is FatalErrorFormState) {
        return ErrorView(state._message);
      }
      return ErrorView("Unknown error!");
    });
  }

  void _showSuccessfulMessage(Transaction transaction, BuildContext context) {
    if (transaction != null) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Successful transaction');
          }).then((value) => Navigator.pop(context));
    }
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknown error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}

class _BasicForm extends StatelessWidget {
  final Contact _contact;
  final TextEditingController _valueController = TextEditingController();

  final String transactionId = Uuid().v4();

  _BasicForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, //Idenfifica o Scaffold para ser visivel em toda a app.
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending...',
                  ),
                ),
                visible: _sending,
              ),
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.account.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(
                        transactionId,
                        value,

                        _contact,

                      );
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {

                                BlocProvider.of<TransactionFormCubit>(context)
                                    .save(
                                        transactionCreated, password, context);

                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    setState(() {
      _sending = true;
    });
    Transaction transaction = await _send(
      transactionCreated,
      password,
      context,
    );

    _showSuccessfulMessage(transaction, context);
  }

  void _showSuccessfulMessage(Transaction transaction, BuildContext context) {
    if (transaction != null) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Sucessful transaction');
          }).then((value) => Navigator.pop(context));
    }
  }

  Future<Transaction> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    final Transaction transaction = await _transactionRoute
        .save(transactionCreated, password)
        .catchError((error) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance
            .setCustomKey('exception', error.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', error.message);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance
            .recordError(errorPropertyTextConfiguration, null);
      }

      _showFailureMessage(context, message: error.message);
    }, test: (error) => error is HttpException).catchError((error) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance
            .setCustomKey('exception', error.toString());
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance
            .recordError(errorPropertyTextConfiguration, null);
      }

      _showFailureMessage(context, message: 'Timeout');
    }, test: (error) => error is TimeoutException).catchError((error) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance
            .setCustomKey('exception', error.toString());
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(error, null);
      }

      _showFailureMessage(context);
    }).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
    return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknown error'}) {
    final snackBar = SnackBar(content: Text(message));

    //TODO entender melhor esse deprecated

    //_scaffoldKey.currentState.showSnackBar(snackBar);

    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}
