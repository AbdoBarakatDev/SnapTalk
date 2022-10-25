import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/modules/home_layout/home_layout.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit_states.dart';
import 'package:flutter_social/modules/register/register_screen.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';
import 'package:flutter_social/shared/network/local/darkness_helper.dart';
import 'package:flutter_social/shared/styles/colors.dart';

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
              message: "Successfully Login",
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextHeading(context),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "login now to communicate with others",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 160,
                        child: Column(
                          children: [
                            Expanded(
                              child: defaultTextFormField(
                                hintStyle: const TextStyle(color: Colors.grey),
                                labelText: "Email",
                                hintText: "Email Address",
                                textInputAction: TextInputAction.next,
                                prefix: const Icon(Icons.email_outlined),
                                controller: emailController,
                                validatorFunction: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Email Address must not be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                borderRadius: 10,
                                textInputType: TextInputType.emailAddress,
                                context: context,
                              ),
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                hintStyle: const TextStyle(color: Colors.grey),
                                labelText: "Password",
                                hintText: "Password",
                                textInputAction: TextInputAction.done,
                                prefix: const Icon(Icons.lock_outlined),
                                contentPadding: EdgeInsets.zero,
                                hidden: LoginCubit.get(context).isHidden,
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
                                  if (value!.isEmpty) {
                                    return "Password must not be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                onSubmited: (value) {
                                  if (formKey.currentState!.validate()) {
                                    printMSG("Validated");
                                    formKey.currentState?.save();
                                    LoginCubit.get(context).login(
                                        context: context,
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim());
                                  }
                                },
                                borderRadius: 10,
                                textInputType: TextInputType.visiblePassword,
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingStates,
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        builder: (context) => defaultButton(
                          text: "LOGIN",
                          function: () {
                            if (formKey.currentState!.validate()) {
                              printMSG("Validated");
                              formKey.currentState?.save();
                              LoginCubit.get(context).login(
                                  context: context,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim());
                            }
                          },
                          height: 50,
                          buttonColor: defaultAppColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Do not have an account",
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                ?.copyWith(color: Colors.grey),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: Text(
                              "REGISTER",
                              style: TextStyle(color: defaultAppColor),
                            ),
                            onPressed: () {
                              doNamedNavigation(context, RegisterScreen.id);
                              doWidgetNavigation(context, RegisterScreen());
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  buildTextHeading(BuildContext context) {
    return Text(
      "LOGIN",
      style: Theme.of(context).textTheme.headline2,
    );
  }
}
