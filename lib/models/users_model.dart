class UsersModel {
  String? name;
  String? email;
  String? phone;
  String? profilePicture;
  String? backgroundPicture;
  String? bio;
  String? uId;
  bool? isEmailVerified;

  UsersModel(
      {this.name, this.email, this.phone, this.uId, this.isEmailVerified,this.bio,this.backgroundPicture,this.profilePicture});

  UsersModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    uId = json["uId"];
    profilePicture = json["profilePicture"];
    backgroundPicture = json["backgroundPicture"];
    bio = json["bio"];
    isEmailVerified = json["isEmailVerified"];
  }

  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uId": uId,
      "profilePicture": profilePicture,
      "backgroundPicture": backgroundPicture,
      "bio": bio,
      "isEmailVerified": isEmailVerified,
    };
  }
}
