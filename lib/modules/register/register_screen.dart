import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/modules/login_screen/login_cubit/login_cubit.dart';
import 'package:flutter_social/modules/login_screen/login_screen.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit_states.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:flutter_social/shared/cubit/app_cubit.dart';
import 'package:flutter_social/shared/styles/colors.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = "RegisterScreen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterScreen({Key? key}) : super(key: key);
  BuildContext? buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextHeading(context),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "register now to communicate with others",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey),
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
                                hintStyle: const TextStyle(color: Colors.grey),
                                labelText: "User Name",
                                hintText: "Type Your Name",
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
                                textInputType: TextInputType.emailAddress,
                                context: context,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                hintStyle: const TextStyle(color: Colors.grey),
                                hintText: "Type Email Address",
                                labelText: "Email",
                                textInputAction: TextInputAction.next,
                                prefix: const Icon(Icons.lock_outlined),
                                controller: emailController,
                                validatorFunction: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Email Address must not be empty";
                                  } else if (!value.contains("@")) {
                                    return "Email must be Contains @";
                                  } else if (!((value.contains("gmail.com")) ||
                                      (value.contains("yahoo.com")))) {
                                    return "Email typed in a wrong format";
                                  } else {
                                    return null;
                                  }
                                },
                                borderRadius: 10,
                                textInputType: TextInputType.emailAddress,
                                context: context,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                hintStyle: const TextStyle(color: Colors.grey),
                                hintText: "Type Your Password",
                                labelText: "Password",
                                textInputAction: TextInputAction.next,
                                prefix: const Icon(
                                  Icons.lock_outlined,
                                ),
                                hidden: RegisterCubit.get(context).isHidden,
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
                                textInputType: TextInputType.visiblePassword,
                                context: context,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: defaultTextFormField(
                                height: 70,
                                hintStyle: const TextStyle(color: Colors.grey),
                                hintText: "Type Your Phone Number",
                                labelText: "Phone",
                                maxLength: RegisterCubit.get(context).maxLength,
                                textInputAction: TextInputAction.done,
                                prefix:Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                  child: buildCountryKeys(),
                                ),
                                controller: phoneController,
                                validatorFunction: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Phone Number must not be empty";
                                  } else if (value.length <
                                      RegisterCubit.get(context).maxLength) {
                                    return "wrong number must be at least ${RegisterCubit.get(context).maxLength} digits";
                                  } else {
                                    return null;
                                  }
                                },
                                borderRadius: 10,
                                textInputType: TextInputType.phone,
                                context: context,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingStates,
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        builder: (context) => defaultButton(
                          text: "REGISTER",
                          function: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              RegisterCubit.get(context).register(
                                  context: context,
                                  name: userNameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  password: passwordController.text);
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
                            "Already have an account",
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
                              "LOGIN",
                              style: TextStyle(color: defaultAppColor),
                            ),
                            onPressed: () {
                              doNamedNavigation(context, LoginScreen.id);
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
      "REGISTER",
      style: Theme.of(context).textTheme.headline3,
    );
  }

  buildCountryKeys() {
    return Center(
      child: CountryCodePicker(
        padding: EdgeInsets.zero,
        onChanged: _onCountryChange,

        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: 'EG',
        favorite: const ['+20', 'EG'],
        // optional. Shows only country name and flag
        showCountryOnly: false,
        flagWidth: 25,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    RegisterCubit.get(buildContext!)
        .maxLinesDetected(countryCode: countryCode.toString());
    printMSG("New Country selected: ${countryCode.code}");
  }
}
