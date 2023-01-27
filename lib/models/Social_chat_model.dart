// ignore_for_file: non_constant_identifier_names

class SocialChatModel {
  String? receiverId;
  String? senderId;
  String? dateTime;
  String? text;
  String? img;

  SocialChatModel(
      {this.receiverId, this.senderId, this.dateTime, this.text, this.img});
  SocialChatModel.FromJson(Map<String, dynamic> json) {
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    dateTime = json['dateTime'];
    text = json['text'];
    img = json['img'];
  }

  Map<String, dynamic> ToMap() {
    return {
      'receiverId': receiverId,
      'dateTime': dateTime,
      'senderId': senderId,
      'text': text,
      'img': img,
    };
  }
}
