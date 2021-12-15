//Localization and Internationalization
import 'dart:async';

import 'package:bytebank/components/error.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/services/webclient/i18n_webclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

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
  CurrentLocaleCubit() : super("en");
}

class ViewI18N {
  String language;

  ViewI18N(BuildContext context) {
    this.language = BlocProvider.of<CurrentLocaleCubit>(context).state;
  }

  String localize(Map<String, String> values) {
    assert(values != null);
    assert(values.containsKey(language));

    return values[language];
  }
}

class I18NLoadingContainer extends BlocContainer {
  I18NWidgetCreator creator;
  String translateScreen;
  String translateLocale;

  I18NLoadingContainer(
      {@required String translateScreen,
      @required String translateLocale,
      @required I18NWidgetCreator creator}) {
    this.creator = creator;
    this.translateScreen = translateScreen;
    this.translateLocale = translateLocale;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit =
            I18NMessagesCubit(this.translateScreen, this.translateLocale);
        cubit.reload(I18NWebClient(this.translateScreen, this.translateLocale));
        return cubit;
      },
      child: I18NLoadingView(this.creator),
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
  final String _translateScreen;
  final String _translateLocale;
  LocalStorage _storage;
  String _translateFile;

  I18NMessagesCubit(this._translateScreen, this._translateLocale)
      : super(InitI18NMessagesState()) {
    this._storage = new LocalStorage(
        'local_translates_$_translateLocale-$_translateScreen.json');
    this._translateFile = "translate_$_translateLocale-$_translateScreen";
  }

  reload(I18NWebClient client) async {
    emit(LoadingI18NMessagesState());

    await _storage.ready;
    final items = _storage.getItem(_translateFile);
    if (items != null) {
      print('Load LocalStorage: ' + _translateFile);
      emit(LoadedI18NMessagesState(I18NMessages(items)));
      return;
    }
    client.findAll().then(saveAndRefresh);
  }

  FutureOr saveAndRefresh(Map<String, dynamic> messages) {
    _storage.setItem(_translateFile, messages);
    print('Save LocalStorage key: ' + _translateFile);
    emit(LoadedI18NMessagesState(I18NMessages(messages)));
  }
}
