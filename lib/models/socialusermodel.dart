// ignore_for_file: non_constant_identifier_names

class SocialUserModel {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? cover;
  String? uid;
  String? bio;

  SocialUserModel({
    this.name,
    this.email,
    this.phone,
    this.bio,
    this.image,
    this.cover,
    this.uid,
  });
  SocialUserModel.FromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    bio = json['bio'];
    image = json['image'];
    cover = json['cover'];
    uid = json['uid'];
  }

  Map<String, dynamic> ToMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'bio': bio,
      'image': image,
      'cover': cover,
      'uid': uid,
    };
  }
}
