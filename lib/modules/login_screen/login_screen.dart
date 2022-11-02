import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/modules/home_layout/home_layout.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit_states.dart';
import 'package:flutter_social/modules/register/register_screen.dart';
import 'package:flutter_social/shared/components/app_constants.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';
import 'package:flutter_social/shared/network/local/darkness_helper.dart';
import 'package:flutter_social/shared/styles/colors.dart';
import 'package:flutter_social/utils/app_strings.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'Login Screen';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  LoginScreen({Key? key, this.email, this.password}) : super(key: key);

  @override
  build(BuildContext context) {
    if (email != null && password != null) {
      emailController.text = email!;
      passwordController.text = password!;
    }
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        printMSG("Login Screen Email is ${emailController.text}");
        printMSG("Login Screen Password is ${passwordController.text}");
        printMSG(
            "Login Screen Password Length is ${passwordController.text.length}");

        if (state is LoginSuccessStates) {
          showSnackBar(
              context: context,
              message: AppStrings.successfullyLoginMessage,
              states: SnackBarStates.SUCCESS);
          CashHelper.putData(key: "uId", value: state.id!).then((value) {
            doReplacementWidgetNavigation(context, const HomeLayout());
            printMSG("Login Screen uId is : ${value.toString()}");
          }).catchError((error) {
            printMSG(error.toString());
          });
        }
        if (state is LoginErrorStates) {
          showSnackBar(
              context: context,
              message: state.error.toString(),
              states: SnackBarStates.ERROR);
        }
        if (state is SocialAppSignOutLoadingState) {
          const Center(child: CircularProgressIndicator());
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTextHeading(context),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppStrings.sinInSubTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.grey.shade200,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SizedBox(
                                    height: 160,
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        TextButton(
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                alignment:
                                                    Alignment.bottomRight),
                                            onPressed: () {},
                                            child: const Text(
                                                AppStrings.forgotPassword)),
                                        Column(
                                          children: [
                                            Expanded(
                                              child: defaultTextFormField(
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey),
                                                labelText:
                                                    AppStrings.emailLabel,
                                                hintText: AppStrings.emailHint,
                                                textInputAction:
                                                    TextInputAction.next,
                                                prefix: const Icon(
                                                    Icons.email_outlined),
                                                controller: emailController,
                                                validatorFunction:
                                                    (String? value) {
                                                  if (value!.isEmpty) {
                                                    return "Email Address must not be empty";
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
                                            const SizedBox(height: 10),
                                            Expanded(
                                              child: defaultTextFormField(
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey),
                                                labelText:
                                                    AppStrings.passwordLabel,
                                                hintText:
                                                    AppStrings.passwordHint,
                                                textInputAction:
                                                    TextInputAction.done,
                                                prefix: const Icon(
                                                    Icons.lock_outlined),
                                                contentPadding: EdgeInsets.zero,
                                                hidden: LoginCubit.get(context)
                                                    .isHidden,
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    LoginCubit.get(context)
                                                        .changePasswordVisibility();
                                                  },
                                                  child: Icon(
                                                    LoginCubit.get(context)
                                                        .icon,
                                                    color: AppCubit.get(context)
                                                            .isDark
                                                        ? Colors.grey.shade400
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                controller: passwordController,
                                                validatorFunction:
                                                    (String? value) {
                                                  if (value!.isEmpty) {
                                                    return "Password must not be empty";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onSubmitted: (value) {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    printMSG("Validated");
                                                    formKey.currentState
                                                        ?.save();
                                                    LoginCubit.get(context).login(
                                                        context: context,
                                                        email: emailController
                                                            .text
                                                            .trim(),
                                                        password:
                                                            passwordController
                                                                .text
                                                                .trim());
                                                  }
                                                },
                                                borderRadius: 10,
                                                textInputType: TextInputType
                                                    .visiblePassword,
                                                context: context,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  drawLoginRemember(context),
                                  // const SizedBox(
                                  //   height: 40,
                                  // ),
                                  ConditionalBuilder(
                                    condition: state is! LoginLoadingStates,
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                    builder: (context) => defaultButton(
                                      text: AppStrings.sinIn,
                                      function: () {
                                        if (formKey.currentState!.validate()) {
                                          printMSG("Validated");
                                          formKey.currentState?.save();
                                          LoginCubit.get(context).login(
                                              context: context,
                                              email:
                                                  emailController.text.trim(),
                                              password: passwordController.text
                                                  .trim());
                                        }
                                      },
                                      height: 50,
                                      buttonColor: defaultAppColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  drawSignInWithFacebookOrGoogle(context),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppStrings.doNotHaveAnAccount,
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                        child: Text(
                                          AppStrings.sinUp,
                                          style:
                                              TextStyle(color: defaultAppColor),
                                        ),
                                        onPressed: () {
                                          doReplacementWidgetNavigation(
                                              context, RegisterScreen());
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
                )));
      },
    );
  }

  buildTextHeading(BuildContext context) {
    return Text(
      AppStrings.login.toUpperCase(),
      style: Theme.of(context).textTheme.headline2,
    );
  }

  drawLoginRemember(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          splashRadius: 10,
          value: false,
          onChanged: (value) {},
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          AppStrings.rememberMe,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  drawSignInWithFacebookOrGoogle(BuildContext context) {
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
        Text(AppStrings.signInWith,
            style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(
          height: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                //todo: Sign in with Facebook
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
              onTap: () async {
                //todo: Sign in with Google
                await LoginCubit.get(context).signInWithGoogle(context);
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
