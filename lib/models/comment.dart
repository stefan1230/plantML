class Comment {
  final String commentId;
  final String postId;
  final String userId;
  final String text;
  final List<Comment> replies; // To store replies

  Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.text,
    this.replies = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'text': text,
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      postId: map['postId'],
      userId: map['userId'],
      text: map['text'],
      replies: (map['replies'] as List<dynamic>?)
              ?.map((reply) => Comment.fromMap(reply))
              .toList() ??
          [],
    );
  }
}
