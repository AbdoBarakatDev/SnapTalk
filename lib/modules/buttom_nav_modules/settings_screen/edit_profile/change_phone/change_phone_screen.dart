
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/modules/buttom_nav_modules/settings_screen/edit_profile/change_phone/recieve_pincode_screen.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit.dart';
import 'package:flutter_social/shared/components/components.dart';
import '../../../../../app_cubit/states.dart';

class ChangePhoneScreen extends StatelessWidget {
  static const String id = "ChangePhoneScreen";

  ChangePhoneScreen({Key? key}) : super(key: key);
  BuildContext? buildContext;
  final GlobalKey formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      body: ConditionalBuilder(
          condition: SocialAppCubit.get(context).usersModel != null,
          fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
          builder: (context) {
            return BlocConsumer<SocialAppCubit, SocialAppStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 70),
                        Text(
                          "1/3",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Verify your phone number",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Enter your number so that we know you're you",
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: defaultTextFormField(
                            height: 70,
                            hintStyle: const TextStyle(color: Colors.grey),
                            hintText: "Type Your Phone Number",
                            labelText: "Phone",
                            maxLength: RegisterCubit.get(context).maxLength,
                            textInputAction: TextInputAction.done,
                            prefix: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              child: buildCountryKeys(),
                            ),
                            controller: phoneController,
                            onChange: (value) {
                              if (value?.length ==
                                  RegisterCubit.get(context).maxLength) {
                                SocialAppCubit.get(context)
                                    .changeVerifyPhoneButtonEnabled(true);
                              } else {
                                SocialAppCubit.get(context)
                                    .changeVerifyPhoneButtonEnabled(false);
                              }
                              return ;
                            },
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
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: defaultButton(
                              text: "Continue",
                              width: MediaQuery.of(context).size.width,
                              // radius: 15,
                              function: SocialAppCubit.get(context)
                                      .verifyPhoneButtonIsEnabled
                                  ? () {
                                      printMSG("Clicked");
                                      doWidgetNavigation(context, ReceivePinCodeScreen());
                                    }
                                  : null,
                              height: 50,
                              buttonColor: SocialAppCubit.get(context)
                                      .verifyPhoneButtonIsEnabled
                                  ? Colors.blue
                                  : Colors.grey.withOpacity(0.2)),
                        ),
                      ],
                    ),
                  );
                });
          }),
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
