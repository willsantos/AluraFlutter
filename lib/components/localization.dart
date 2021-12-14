//Localization and Internationalization
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'container.dart';

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
}
