//Localization and Internationalization
import 'package:bytebank/components/error.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/services/webclient/i18n_webclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'container.dart';

@immutable
abstract class I18NMessagesState {
  const I18NMessagesState();
}

@immutable
class LoadingI18NMessagesState extends I18NMessagesState {
  const LoadingI18NMessagesState();
}

@immutable
class InitI18NMessagesState extends I18NMessagesState {
  const InitI18NMessagesState();
}

@immutable
class LoadedI18NMessagesState extends I18NMessagesState {
  final I18NMessages _messages;

  const LoadedI18NMessagesState(this._messages);
}

@immutable
class FatalErrorI18NMessagesState extends I18NMessagesState {
  final String _message;

  const FatalErrorI18NMessagesState(this._message);
}

class I18NMessages {
  final Map<String, dynamic> _messages;

  I18NMessages(this._messages);

  String get(String key) {
    assert(key != null);
    assert(_messages.containsKey(key));
    return _messages[key];
  }
}

typedef Widget I18NWidgetCreator(I18NMessages messages);

class LocalizationContainer extends BlocContainer {
  final Widget child;

  LocalizationContainer({@required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentLocaleCubit>(
      create: (context) => CurrentLocaleCubit(),
      child: this.child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super("pt-br");
}

class ViewI18N {
  String _language;

  ViewI18N(BuildContext context) {
    this._language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String localize(Map<String, String> values) {
    assert(values != null);
    assert(values.containsKey(_language));

    return values[_language];
  }
}

class I18NLoadingContainer extends BlocContainer {
  final I18NWidgetCreator _creator;

  I18NLoadingContainer(this._creator);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessagesCubit();
        cubit.reload(I18NWebClient());
        return cubit;
      },
      child: I18NLoadingView(this._creator),
    );
  }
}

class I18NLoadingView extends StatelessWidget {
  final I18NWidgetCreator _creator;

  I18NLoadingView(this._creator);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I18NMessagesCubit, I18NMessagesState>(
        builder: (context, state) {
      if (state is InitI18NMessagesState || state is LoadingI18NMessagesState) {
        return ProgressView(message: "Loading...");
      }
      if (state is LoadedI18NMessagesState) {
        final messages = state._messages;
        return _creator.call(messages);
      }
      return ErrorView('Unknown Error');
    });
  }
}

class I18NMessagesCubit extends Cubit<I18NMessagesState> {
  I18NMessagesCubit() : super(InitI18NMessagesState());

  void reload(I18NWebClient client) {
    emit(LoadingI18NMessagesState());
    client.findAll().then((messages) => emit(
          LoadedI18NMessagesState(I18NMessages(messages)),
        ));
  }
}
