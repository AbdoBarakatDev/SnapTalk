import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social/shared/components/constants.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';
import 'package:flutter_social/shared/styles/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

Widget defaultButton({
  Color buttonColor = Colors.cyanAccent,
  double height = 30,
  // bool? isEnabled,
  double width = double.infinity,
  required String text,
  required final void Function()? function,
  TextStyle textStyle = const TextStyle(
      color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
  double radius = 0,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: buttonColor,
      ),
      child: MaterialButton(
        // enableFeedback: isEnabled!,
        onPressed: function,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );

Widget defaultTextButton({
  Color buttonColor = Colors.transparent,
  double height = 30,
  // bool? isEnabled,
  double? width,
  bool? enabled = true,
  required String text,
  required final void Function()? function,
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 17),
  double radius = 0,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: buttonColor,
      ),
      child: TextButton(
        // enableFeedback: isEnabled!,
        onPressed: enabled == true ? function : null,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );

customAuthBackground(BuildContext context) {
  return Column(
    children: [
      Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .35,
        child: Container(
          height: MediaQuery.of(context).size.height * .35,
          decoration: BoxDecoration(
              color: loginStyleMainColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(90),
              )),
        ),
      ),
      Container(
        color: loginStyleMainColor,
        height: MediaQuery.of(context).size.height * .65,
        child: Container(
          height: MediaQuery.of(context).size.height * .65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(90),
            ),
          ),
        ),
      ),
    ],
  );
}

PreferredSizeWidget defaultAppBar({
  @required BuildContext? context,
  String? title,
  List<Widget>? actions,
  double? elevation = 0,
  Widget? leading,
}) {
  return AppBar(
    elevation: elevation!,
    actionsIconTheme: Theme.of(context!).iconTheme,
    iconTheme: Theme.of(context).appBarTheme.iconTheme,
    toolbarTextStyle: Theme.of(context).appBarTheme.toolbarTextStyle,
    // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    backgroundColor: AppCubit.get(context).isDark
        ? darkThemeSecondColor
        : lightThemePrimaryColor,
    actions: actions,
    title: Text(
      title!,
      style: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
    ),
    leading: leading != null
        ? GestureDetector(child: leading, onTap: () => Navigator.pop(context))
        : null,
  );
}

Widget defaultTextFormField({
  bool enabled = true,
  String? Function()? onTab,
  required BuildContext context,
  String? Function(String? val)? onChange,
  String? Function(String? val)? onSubmitted,
  @required String? hintText,
  String? labelText,
  IconData? prefixIcon,
  Widget? prefix,
  Widget? suffixIcon,
  Color? textColor,
  Color? hintColor,
  Color prefixIconColor = Colors.grey,
  Color suffixIconColor = Colors.grey,
  TextStyle? hintStyle,
  TextStyle? textStyle,
  TextEditingController? controller,
  String? Function(String? val)? validatorFunction,
  double borderRadius = 0,
  Color borderColor = Colors.grey,
  double borderSize = 1,
  bool hidden = false,
  TextInputAction? textInputAction,
  TextInputType? textInputType,
  bool autoCorrect = false,
  int maxLines = 1,
  TextDirection? textDirection,
  Key? textFieldKey,
  Color? cursorColor,
  int? maxLength,
  double height = 60,
  bool isDense = false,
  contentPadding = const EdgeInsets.only(left: 5, top: 10, bottom: 10),
}) =>
    SizedBox(
      height: height,
      child: TextFormField(
        autocorrect: autoCorrect,
        maxLines: maxLines,
        key: textFieldKey,
        cursorColor: cursorColor,
        maxLength: maxLength,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        enabled: enabled,
        obscureText: hidden,
        style: textStyle,
        controller: controller,
        validator: validatorFunction,
        onTap: onTab,
        onChanged: onChange,
        onFieldSubmitted: onSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced),
        ],
        decoration: InputDecoration(
          contentPadding: (prefix != null && prefix is Widget)
              ? const EdgeInsets.symmetric(vertical: 2)
              : contentPadding,
          labelText: labelText,
          // ignore: unnecessary_null_comparison
          labelStyle: (context != null)
              ? Theme.of(context).textTheme.bodyText2
              : const TextStyle(color: Colors.grey),
          isDense: isDense,
          hintText: hintText,
          hintStyle: hintStyle,
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5), child: prefix),
          prefixIconConstraints: prefix is Widget
              ? const BoxConstraints(maxWidth: 100, maxHeight: 50)
              : const BoxConstraints(minWidth: 90),
          // prefixIcon: prefix is Icon ?prefix:Container(),
          // prefix: prefix is Widget?prefix:Container(),
          suffix: Padding(
              padding: const EdgeInsets.only(right: 10), child: suffixIcon),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: borderSize, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );

doNamedNavigation(BuildContext context, String routeName) =>
    Navigator.pushNamed(context, routeName);

doWidgetNavigation(BuildContext context, Widget screen) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

doReplacementWidgetNavigation(BuildContext context, Widget screen) =>
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));

enum SnackBarStates { SUCCESS, ERROR, WARNING }

Color chooseSnackBarColor(SnackBarStates states) {
  Color color;
  switch (states) {
    case SnackBarStates.ERROR:
      color = Colors.red;
      break;
    case SnackBarStates.WARNING:
      color = Colors.amber;
      break;
    case SnackBarStates.SUCCESS:
      color = Colors.green;
      break;
  }
  return color;
}

showSnackBar({
  required BuildContext? context,
  required String? message,
  required SnackBarStates? states,
  int seconds = 2,
}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(message.toString()),
    duration: Duration(seconds: seconds),
    backgroundColor: chooseSnackBarColor(states!),
  ));
}

showToast({
  BuildContext? context,
  required String? message,
  Toast time = Toast.LENGTH_SHORT,
  MaterialColor color = Colors.green,
  Color textColor = Colors.white,
  double fontSize = 16.0,
  ToastGravity gravity = ToastGravity.BOTTOM,
}) {
  Fluttertoast.showToast(
      msg: message!,
      toastLength: time,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: textColor,
      fontSize: fontSize);
}

printMSG(String? text) {
  if (kDebugMode) {
    print(text);
  }
}
