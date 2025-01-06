class UserModel {
  final int id;
  final String accountNo;
  final String displayName;
  final String? emailAddress;
  final String? mobileNo;
  final int officeId;

  UserModel({
    required this.id,
    required this.accountNo,
    required this.displayName,
    this.emailAddress,
    this.mobileNo,
    required this.officeId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      accountNo: json['accountNo'] as String,
      displayName: json['displayName'] as String,
      emailAddress: json['emailAddress'] as String?,
      mobileNo: json['mobileNo'] as String?,
      officeId: json['officeId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNo': accountNo,
      'displayName': displayName,
      'emailAddress': emailAddress,
      'mobileNo': mobileNo,
      'officeId': officeId,
    };
  }
}
