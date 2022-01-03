class ResponseMessage {
  String error = '';
  String token = '';
  bool ok = false;

  ResponseMessage({required this.error, required this.token, required this.ok});

  factory ResponseMessage.fromJson(Map<String, dynamic> json) => ResponseMessage(
      error : json['error'],
      ok : json['ok'],
      token : json['token']
  );
}