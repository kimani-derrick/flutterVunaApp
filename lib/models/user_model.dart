class UserModel {
  final int id;
  final String accountNo;
  final String firstname;
  final String lastname;
  final String displayName;
  final String mobileNo;
  final String emailAddress;
  final String officeName;
  final bool isActive;

  UserModel({
    required this.id,
    required this.accountNo,
    required this.firstname,
    required this.lastname,
    required this.displayName,
    required this.mobileNo,
    required this.emailAddress,
    required this.officeName,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      accountNo: json['accountNo'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      displayName: json['displayName'] as String,
      mobileNo: json['mobileNo'] as String,
      emailAddress: json['emailAddress'] as String,
      officeName: json['officeName'] as String,
      isActive: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNo': accountNo,
      'firstname': firstname,
      'lastname': lastname,
      'displayName': displayName,
      'mobileNo': mobileNo,
      'emailAddress': emailAddress,
      'officeName': officeName,
      'active': isActive,
    };
  }
}
