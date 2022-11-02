import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social/app_cubit/cubit.dart';
import 'package:flutter_social/app_cubit/states.dart';
import 'package:flutter_social/models/users_model.dart';
import 'package:flutter_social/modules/buttom_nav_modules/settings_screen/edit_profile/change_phone/change_phone_screen.dart';
import 'package:flutter_social/shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  static const String id = "EditProfile Screen";
  var formKey = GlobalKey<FormState>();
  var profileName = TextEditingController();
  var profileBio = TextEditingController();
  var profilePhone = TextEditingController();
  double? height = 0;
  double? width = 0;
  UsersModel? model;

  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    model = SocialAppCubit.get(context).usersModel;
    loadProfileData();
    return Scaffold(
        appBar: defaultAppBar(
            context: context,
            title: "Edit Profile",
            leading: const Icon(Icons.arrow_back_ios_outlined),
            actions: [
              TextButton(
                onPressed: () {
                  printMSG("Name Controller Is : ${profileName.text}");
                  printMSG("Phone Controller Is : ${profileName.text}");
                  printMSG("Name Controller Is : ${profileName.text}");
                  if (formKey.currentState!.validate()) {
                    printMSG(SocialAppCubit.get(context).usersModel.toString());
                    formKey.currentState?.save();
                    SocialAppCubit.get(context).uploadUserData(
                      context: context,
                      phone: profilePhone.text,
                      name: profileName.text,
                      bio: profileBio.text,
                    );
                  }
                },
                child: const Text(
                  "Update",
                ),
              ),
            ]),
        body: ConditionalBuilder(
          condition: model != null,
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          builder: (context) {
            return BlocConsumer<SocialAppCubit, SocialAppStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  printMSG(model!.name);
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          (state is SocialAppUpdateUserDataLoadingState)
                              ? const LinearProgressIndicator(
                                  backgroundColor: Colors.red,
                                  color: Colors.blue,
                                  minHeight: 5,
                                )
                              : Container(),
                          Column(
                            children: [
                              SizedBox(
                                height: height! * 0.33,
                                child: Align(
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: height! * 0.25,
                                            width: width,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                topLeft: Radius.circular(15),
                                              ),
                                            ),
                                            margin: const EdgeInsets.all(8),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: SocialAppCubit.get(context)
                                                        .backgroundImage ==
                                                    null
                                                ? Image.network(
                                                    model!.backgroundPicture
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                  )
                                                : FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Image.file(
                                                        SocialAppCubit.get(
                                                                context)
                                                            .backgroundImage!)),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              SocialAppCubit.get(context)
                                                  .pickBackgroundImage();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, right: 10),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors
                                                    .grey.shade700
                                                    .withOpacity(0.5),
                                                child: const Icon(
                                                    Icons.camera_alt),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: CircleAvatar(
                                          radius: 62,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // ignore: unnecessary_null_comparison
                                              SocialAppCubit.get(context)
                                                          .profileImage ==
                                                      null
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        model!.profilePicture
                                                            .toString(),
                                                      ),
                                                      radius: 60,
                                                    )
                                                  : CircleAvatar(
                                                      radius: 60,
                                                      backgroundImage:
                                                          FileImage(
                                                        SocialAppCubit.get(
                                                                context)
                                                            .profileImage!,
                                                      ),
                                                    ),
                                              GestureDetector(
                                                  onTap: () {
                                                    SocialAppCubit.get(context)
                                                        .pickProfileImage();
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: Colors
                                                        .grey.shade700
                                                        .withOpacity(0.5),
                                                    child: const Icon(
                                                        Icons.camera_alt),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (SocialAppCubit.get(context).profileImage !=
                                      null ||
                                  SocialAppCubit.get(context).backgroundImage !=
                                      null)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          if (SocialAppCubit.get(context)
                                                  .profileImage !=
                                              null)
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  defaultButton(
                                                    text: "Upload Profile",
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!,
                                                    height: 40,
                                                    radius: 10,
                                                    function: () {
                                                      SocialAppCubit.get(
                                                              context)
                                                          .uploadProfileImage(
                                                        context: context,
                                                        name: profileName.text,
                                                        phone:
                                                            profilePhone.text,
                                                        bio: profileBio.text,
                                                      );
                                                    },
                                                  ),
                                                  if (state
                                                      is SocialAppUpdateUserDataLoadingState)
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  if (state
                                                      is SocialAppUpdateUserDataLoadingState)
                                                    const LinearProgressIndicator(),
                                                ],
                                              ),
                                            ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (SocialAppCubit.get(context)
                                                  .backgroundImage !=
                                              null)
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  defaultButton(
                                                    text: "Upload Cover",
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!,
                                                    height: 40,
                                                    radius: 10,
                                                    function: () {
                                                      SocialAppCubit.get(
                                                              context)
                                                          .uploadBackgroundImage(
                                                        context: context,
                                                        name: profileName.text,
                                                        phone:
                                                            profilePhone.text,
                                                        bio: profileBio.text,
                                                      );
                                                    },
                                                  ),
                                                  if (state
                                                      is SocialAppUpdateUserDataLoadingState)
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  if (state
                                                      is SocialAppUpdateUserDataLoadingState)
                                                    const LinearProgressIndicator(),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: defaultTextFormField(
                                  context: context,
                                  maxLength: 30,
                                  hintText: "Name",
                                  labelText: "Type your name",
                                  controller: profileName,
                                  hintColor: Colors.grey,
                                  borderRadius: 10,
                                  prefix:
                                      const Icon(Icons.person_outline_outlined),
                                  validatorFunction: (value) {
                                    if (value!.isEmpty) {
                                      return "Name must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  // onSubmited: (val) {
                                  //   if (formKey.currentState!.validate()) {
                                  //     printMSG(SocialAppCubit
                                  //         .get(context)
                                  //         .usersModel
                                  //         .toString());
                                  //     formKey.currentState?.save();
                                  //     SocialAppCubit.get(context)
                                  //         .uploadUserData(
                                  //       context: context,
                                  //       phone: profilePhone.text,
                                  //       name: profileName.text,
                                  //       bio: profileBio.text,
                                  //     );
                                  //   }
                                  // },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: defaultTextFormField(
                                  context: context,
                                  maxLength: 99,
                                  controller: profileBio,
                                  hintText: "Bio",
                                  labelText: "Type your bio",
                                  hintColor: Colors.grey,
                                  borderRadius: 10,
                                  prefix: const Icon(Icons.info_outline),
                                  validatorFunction: (value) {
                                    if (value!.isEmpty) {
                                      return "Bio must not be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  // onSubmited: (val) {
                                  //   if (formKey.currentState!.validate()) {
                                  //     printMSG(SocialAppCubit
                                  //         .get(context)
                                  //         .usersModel
                                  //         .toString());
                                  //     formKey.currentState?.save();
                                  //     SocialAppCubit.get(context)
                                  //         .uploadUserData(
                                  //       context: context,
                                  //       phone: profilePhone.text,
                                  //       name: profileName.text,
                                  //       bio: profileBio.text,
                                  //     );
                                  //   }
                                  // },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: defaultTextFormField(
                                            enabled: false,
                                            context: context,
                                            controller: profilePhone,
                                            hintText: "Phone",
                                            labelText: "Type your phone",
                                            hintColor: Colors.grey,
                                            borderRadius: 10,
                                            prefix: const Icon(Icons.phone),
                                            validatorFunction: (value) {
                                              if (value!.isEmpty) {
                                                return "phone must not be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            doWidgetNavigation(
                                                context, ChangePhoneScreen());
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text("change",
                                                style: TextStyle(
                                                    color: Colors.blue)),
                                          )),
                                    ]),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ));
  }

  void loadProfileData() {
    profileName.text = model!.name.toString();
    profileName.selection = TextSelection(
        baseOffset: model!.name.toString().length,
        extentOffset: model!.name.toString().length);
    profileBio.text = model!.bio.toString();
    profileBio.selection = TextSelection(
        baseOffset: model!.bio.toString().length,
        extentOffset: model!.bio.toString().length);
    profilePhone.text = model!.phone.toString();
    profilePhone.selection = TextSelection(
        baseOffset: model!.phone.toString().length,
        extentOffset: model!.phone.toString().length);
  }
}
