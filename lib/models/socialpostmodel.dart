// ignore_for_file: non_constant_identifier_names

class SocialPostModel {
  String? name;

  String? image;
  String? text;
  String? uid;
  String? dateTime;
  String? postImage;
  SocialPostModel({
    this.name,
    this.image,
    this.uid,
    this.dateTime,
    this.text,
    this.postImage,
  });
  SocialPostModel.FromJson(Map<String, dynamic> json) {
    name = json['name'];
    text = json['text'];
    image = json['image'];
    postImage = json['postImage'];
    uid = json['uid'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> ToMap() {
    return {
      'name': name,
      'uid': uid,
      'text': text,
      'postImage': postImage,
      'dateTime': dateTime,
      'image': image,
    };
  }
}
