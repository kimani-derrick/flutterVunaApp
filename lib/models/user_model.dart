class UserModel {
  final int id;
  final String accountNo;
  final String displayName;
  final String? emailAddress;
  final String? mobileNo;

  UserModel({
    required this.id,
    required this.accountNo,
    required this.displayName,
    this.emailAddress,
    this.mobileNo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      accountNo: json['accountNo'] as String,
      displayName: json['displayName'] as String,
      emailAddress: json['emailAddress'] as String?,
      mobileNo: json['mobileNo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNo': accountNo,
      'displayName': displayName,
      'emailAddress': emailAddress,
      'mobileNo': mobileNo,
    };
  }
}
