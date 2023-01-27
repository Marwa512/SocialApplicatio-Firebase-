class SocialCommentModel {
  String? comment;
  String? commentuser;
  String? commentname;

  String? dateTime;
  String? postID;
  // Constructor
  SocialCommentModel(this.comment, this.commentuser, this.commentname,
      this.dateTime, this.postID);

  SocialCommentModel.fromJson({required Map<String, dynamic> json}) {
    comment = json['comment'];
    commentuser = json['commentuser'];
    commentname = json['commentname'];
    postID = json['postID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'commentuser': commentuser,
      'commentname': commentname,
      'postID': postID,
    };
  }
}
