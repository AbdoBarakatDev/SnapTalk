import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:flutter_social/modules/login_screen/login_screen.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit_states.dart';
import 'package:flutter_social/shared/components/app_constants.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';
import 'package:flutter_social/shared/styles/colors.dart';
import 'package:flutter_social/utils/app_strings.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = "RegisterScreen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? fullMobileNumberWithCode;
  final formKey = GlobalKey<FormState>();

  RegisterScreen({Key? key}) : super(key: key);
  BuildContext? buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                customAuthBackground(context),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            child: Image.asset(
                              appLogoPath,
                              fit: BoxFit.fill,
                              height: 80,
                              width: 80,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTextHeading(context),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                AppStrings.sinUpSubTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.grey.shade200),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                height: 275,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: defaultTextFormField(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        labelText:
                                            AppStrings.userNameRegisterLabel,
                                        hintText:
                                            AppStrings.userNameRegisterHint,
                                        textInputAction: TextInputAction.next,
                                        prefix: const Icon(Icons.person),
                                        controller: userNameController,
                                        validatorFunction: (String? value) {
                                          if (value!.isEmpty) {
                                            return "Name must not be empty";
                                          } else if (value.length < 3) {
                                            return "Name must not be less than 3 letters";
                                          } else {
                                            return null;
                                          }
                                        },
                                        borderRadius: 10,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        context: context,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: defaultTextFormField(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        hintText: AppStrings.emailHint,
                                        labelText: AppStrings.emailLabel,
                                        textInputAction: TextInputAction.next,
                                        prefix: const Icon(Icons.lock_outlined),
                                        controller: emailController,
                                        validatorFunction: (String? value) {
                                          if (value!.isEmpty) {
                                            return "Email Address must not be empty";
                                          } else if (!isEmail(value)) {
                                            return "Email typed in a wrong format";
                                          } else {
                                            return null;
                                          }
                                        },
                                        borderRadius: 10,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        context: context,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: defaultTextFormField(
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        hintText: AppStrings.passwordHint,
                                        labelText: AppStrings.passwordLabel,
                                        textInputAction: TextInputAction.next,
                                        prefix: const Icon(
                                          Icons.lock_outlined,
                                        ),
                                        hidden:
                                            RegisterCubit.get(context).isHidden,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            LoginCubit.get(context)
                                                .changePasswordVisibility();
                                          },
                                          child: Icon(
                                            LoginCubit.get(context).icon,
                                            color: AppCubit.get(context).isDark
                                                ? Colors.grey.shade400
                                                : Colors.grey,
                                          ),
                                        ),
                                        controller: passwordController,
                                        validatorFunction: (String? value) {
                                          RegExp rex = RegExp(
                                              r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
                                          if (value!.isEmpty) {
                                            return "Password must not be empty";
                                          } else if (value.length < 8 ||
                                              !rex.hasMatch(value)) {
                                            return "Password must not be less than 8 digits, 1 capital letter, 1 small letter";
                                          } else {
                                            return null;
                                          }
                                        },
                                        borderRadius: 10,
                                        textInputType:
                                            TextInputType.visiblePassword,
                                        context: context,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: drawPhoneField(context),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ConditionalBuilder(
                                condition: state is! RegisterLoadingStates,
                                fallback: (context) => const Center(
                                    child: CircularProgressIndicator()),
                                builder: (context) => defaultButton(
                                  text: AppStrings.sinUp,
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      RegisterCubit.get(context).register(
                                          context: context,
                                          name: userNameController.text,
                                          phone: fullMobileNumberWithCode,
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  height: 50,
                                  buttonColor: defaultAppColor,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              drawSignInWithFacebookOrGoogle(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.haveAnAccount,
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.white),
                                    ),
                                    child: Text(
                                      AppStrings.login.toUpperCase(),
                                      style: TextStyle(color: defaultAppColor),
                                    ),
                                    onPressed: () {
                                      doReplacementWidgetNavigation(
                                          context, LoginScreen());
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildTextHeading(BuildContext context) {
    return Text(
      AppStrings.register.toUpperCase(),
      style: Theme.of(context).textTheme.headline3,
    );
  }

  drawPhoneField(BuildContext context) {
    return IntlPhoneField(
      initialCountryCode: "EG",
      controller: phoneController,
      decoration: const InputDecoration(
        isDense: true,
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (phoneNumber) {
        log("=====>$phoneNumber");
        log("=====>${phoneNumber!.completeNumber}");
        log("=====>${phoneNumber.countryCode}");
        log("=====>${phoneNumber.countryISOCode}");
        log("=====>${phoneNumber.number}");
        // String pattern = r'/^([+]\d{2})?\d{10}$/';
        // RegExp regex = RegExp(pattern);
        // if (phoneNumber.number.isEmpty) {
        //   return 'Please enter mobile number';
        // } else if (!regex.hasMatch(phoneNumber.number.trim().toString())) {
        //   log("===================>>>>Not Valid Number");
        //   return 'Please enter valid mobile number';
        // } else {
        //   return null;
        // }
      },
      onChanged: (phone) {},
      onSaved: (newValue) {
        fullMobileNumberWithCode = newValue!.completeNumber.toString();
        log('phoneController on: ${phoneController.text}');
      },
      onCountryChanged: (country) {
        log('Country changed to: ${country.name}');
      },
    );
  }

  drawSignInWithFacebookOrGoogle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.or,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(AppStrings.signUpWith,
            style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(
          height: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                //todo: Sign up with Facebook
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage(facebookLogoPath),
                backgroundColor: Colors.transparent,
                radius: 25,
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            GestureDetector(
              onTap: () {
                //todo: Sign up with Google
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage(googleLogoPath),
                backgroundColor: Colors.transparent,
                radius: 25,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  return regExp.hasMatch(em);
}
