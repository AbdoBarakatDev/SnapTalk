import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/modules/register/register_cubit/register_cubit.dart';
import 'package:flutter_social/shared/components/components.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ReceivePinCodeScreen extends StatelessWidget {
  static const String id = "ReceivePinCodeScreen";

  ReceivePinCodeScreen({Key? key}) : super(key: key);
  BuildContext? buildContext;
  var formKey = GlobalKey<FormState>();
  TextEditingController pinController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  // StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: const Text(("Enter Pin Code"),),
                ),),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: const TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "012126127112",
                            // "${widget.phoneNumber}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(
                          color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      obscuringWidget: const FlutterLogo(
                        size: 24,
                      ),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        // setState(() {
                        currentText = value;
                        // });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () =>
                        showSnackBar(
                            context: buildContext,
                            message: "OTP resend!!",
                            states: SnackBarStates.SUCCESS),
                    child: const Text(
                      "RESEND",
                      style: TextStyle(
                          color: Color(0xFF91D3B3),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 30),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: const Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: const Offset(-1, 2),
                          blurRadius: 5)
                    ]),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6 ||
                          currentText != "123456") {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        hasError = true;
                      } else {
                        hasError = false;
                        // snackBar("OTP Verified!!");
                      }
                    },
                    child: Center(
                        child: Text(
                          "VERIFY".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                        child: const Text("Clear"),
                        onPressed: () {
                          textEditingController.clear();
                        },
                      )),
                  Flexible(
                      child: TextButton(
                        child: const Text("Set Text"),
                        onPressed: () {
                          // textEditingController.text = "123456";
                        },
                      )),
                ],
              )
            ],
          ),
        ),
      ),
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

  buildForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
        child: PinCodeTextField(
          appContext: buildContext!,
          pastedTextStyle: TextStyle(
            color: Colors.green.shade600,
            fontWeight: FontWeight.bold,
          ),
          length: 6,
          obscureText: true,
          obscuringCharacter: '*',
          obscuringWidget: const FlutterLogo(
            size: 24,
          ),
          blinkWhenObscuring: true,
          animationType: AnimationType.fade,
          validator: (v) {
            if (v!.length < 3) {
              return "I'm from validator";
            } else {
              return null;
            }
          },
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
          ),
          cursorColor: Colors.black,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          errorAnimationController: errorController,
          controller: pinController,
          keyboardType: TextInputType.number,
          boxShadows: const [
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
          onCompleted: (v) {
            debugPrint("Completed");
          },
          // onTap: () {
          //   print("Pressed");
          // },
          onChanged: (value) {
            debugPrint(value);

            // currentText = value;
          },
          beforeTextPaste: (text) {
            debugPrint("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
        ),
      ),
    );
  }
}
