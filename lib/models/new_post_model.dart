class PostModel {
  String? name;
  String? profilePicture;
  String? uId;
  String? dateTime;
  String? postText;
  String? postImage;
  String? postId;

  PostModel(
      {this.name,
      this.dateTime,
      this.postText,
      this.uId,
      this.postImage,
      this.profilePicture,
      this.postId,
      });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    dateTime = json["dateTime"];
    postText = json["postText"];
    uId = json["uId"];
    profilePicture = json["profilePicture"];
    postImage = json["postImage"];
    postId = json["postId"];
  }

  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "dateTime": dateTime,
      "postText": postText,
      "uId": uId,
      "profilePicture": profilePicture,
      "postImage": postImage,
      "postId": postId,
    };
  }
}
