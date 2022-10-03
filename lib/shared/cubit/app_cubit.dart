import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/shared/cubit/app_states.dart';

import '../network/local/darkness_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  bool isDark = true;

  Color ?appPrimaryColor = Colors.white;
  changeThemeMode({bool? isDarkFromShared}) {
    if (isDarkFromShared != null) {
      isDark = isDarkFromShared;
      appPrimaryColor = isDark?Colors.black26:Colors.white;
      emit(AppChangeModeStates());
    } else {
      isDark = !isDark;
      appPrimaryColor = isDark?Colors.black26:Colors.white;
      CashHelper.putBoolean(key: 'isDark', value: isDark).then(
        (value) {
          emit(AppChangeModeStates());
        },
      );
    }
  }

}
