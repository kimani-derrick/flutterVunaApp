class SavingsAccountModel {
  final int id;
  final String accountNo;
  final String? externalId;
  final int productId;
  final String productName;
  final String shortProductName;
  final AccountStatus status;
  final Currency? currency;
  final double? accountBalance;
  final AccountType? accountType;
  final Timeline? timeline;
  final SubStatus? subStatus;
  final List<int>? lastActiveTransactionDate;
  final DepositType? depositType;

  SavingsAccountModel({
    required this.id,
    required this.accountNo,
    this.externalId,
    required this.productId,
    required this.productName,
    required this.shortProductName,
    required this.status,
    this.currency,
    this.accountBalance,
    this.accountType,
    this.timeline,
    this.subStatus,
    this.lastActiveTransactionDate,
    this.depositType,
  });

  bool get isActive => status.active ?? false;
  String get currencySymbol => currency?.displaySymbol ?? 'KES';
  double get balance => accountBalance ?? 0.0;

  factory SavingsAccountModel.fromJson(Map<String, dynamic> json) {
    return SavingsAccountModel(
      id: json['id'] as int,
      accountNo: json['accountNo'] as String,
      externalId: json['externalId'] as String?,
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      shortProductName: json['shortProductName'] as String,
      status: AccountStatus.fromJson(json['status'] as Map<String, dynamic>),
      currency: json['currency'] != null 
          ? Currency.fromJson(json['currency'] as Map<String, dynamic>)
          : null,
      accountBalance: json['accountBalance'] != null 
          ? (json['accountBalance'] as num).toDouble()
          : null,
      accountType: json['accountType'] != null
          ? AccountType.fromJson(json['accountType'] as Map<String, dynamic>)
          : null,
      timeline: json['timeline'] != null
          ? Timeline.fromJson(json['timeline'] as Map<String, dynamic>)
          : null,
      subStatus: json['subStatus'] != null
          ? SubStatus.fromJson(json['subStatus'] as Map<String, dynamic>)
          : null,
      lastActiveTransactionDate: json['lastActiveTransactionDate'] != null
          ? List<int>.from(json['lastActiveTransactionDate'] as List)
          : null,
      depositType: json['depositType'] != null
          ? DepositType.fromJson(json['depositType'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AccountStatus {
  final int id;
  final String code;
  final String value;
  final bool? submittedAndPendingApproval;
  final bool? approved;
  final bool? rejected;
  final bool? withdrawnByApplicant;
  final bool? active;
  final bool? closed;
  final bool? prematureClosed;
  final bool? transferInProgress;
  final bool? transferOnHold;
  final bool? matured;

  AccountStatus({
    required this.id,
    required this.code,
    required this.value,
    this.submittedAndPendingApproval,
    this.approved,
    this.rejected,
    this.withdrawnByApplicant,
    this.active,
    this.closed,
    this.prematureClosed,
    this.transferInProgress,
    this.transferOnHold,
    this.matured,
  });

  factory AccountStatus.fromJson(Map<String, dynamic> json) {
    return AccountStatus(
      id: json['id'] as int,
      code: json['code'] as String,
      value: json['value'] as String,
      submittedAndPendingApproval: json['submittedAndPendingApproval'] as bool?,
      approved: json['approved'] as bool?,
      rejected: json['rejected'] as bool?,
      withdrawnByApplicant: json['withdrawnByApplicant'] as bool?,
      active: json['active'] as bool?,
      closed: json['closed'] as bool?,
      prematureClosed: json['prematureClosed'] as bool?,
      transferInProgress: json['transferInProgress'] as bool?,
      transferOnHold: json['transferOnHold'] as bool?,
      matured: json['matured'] as bool?,
    );
  }
}

class Currency {
  final String code;
  final String name;
  final int? decimalPlaces;
  final int? inMultiplesOf;
  final String displaySymbol;
  final String nameCode;
  final String displayLabel;

  Currency({
    required this.code,
    required this.name,
    this.decimalPlaces,
    this.inMultiplesOf,
    required this.displaySymbol,
    required this.nameCode,
    required this.displayLabel,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String,
      name: json['name'] as String,
      decimalPlaces: json['decimalPlaces'] as int?,
      inMultiplesOf: json['inMultiplesOf'] as int?,
      displaySymbol: json['displaySymbol'] as String,
      nameCode: json['nameCode'] as String,
      displayLabel: json['displayLabel'] as String,
    );
  }
}

class Timeline {
  final List<int>? submittedOnDate;
  final String? submittedByUsername;
  final String? submittedByFirstname;
  final String? submittedByLastname;
  final List<int>? approvedOnDate;
  final String? approvedByUsername;
  final String? approvedByFirstname;
  final String? approvedByLastname;
  final List<int>? activatedOnDate;

  Timeline({
    this.submittedOnDate,
    this.submittedByUsername,
    this.submittedByFirstname,
    this.submittedByLastname,
    this.approvedOnDate,
    this.approvedByUsername,
    this.approvedByFirstname,
    this.approvedByLastname,
    this.activatedOnDate,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      submittedOnDate: json['submittedOnDate'] != null
          ? List<int>.from(json['submittedOnDate'] as List)
          : null,
      submittedByUsername: json['submittedByUsername'] as String?,
      submittedByFirstname: json['submittedByFirstname'] as String?,
      submittedByLastname: json['submittedByLastname'] as String?,
      approvedOnDate: json['approvedOnDate'] != null
          ? List<int>.from(json['approvedOnDate'] as List)
          : null,
      approvedByUsername: json['approvedByUsername'] as String?,
      approvedByFirstname: json['approvedByFirstname'] as String?,
      approvedByLastname: json['approvedByLastname'] as String?,
      activatedOnDate: json['activatedOnDate'] != null
          ? List<int>.from(json['activatedOnDate'] as List)
          : null,
    );
  }
}

class SubStatus {
  final int id;
  final String code;
  final String value;
  final bool? none;
  final bool? inactive;
  final bool? dormant;
  final bool? escheat;
  final bool? block;
  final bool? blockCredit;
  final bool? blockDebit;

  SubStatus({
    required this.id,
    required this.code,
    required this.value,
    this.none,
    this.inactive,
    this.dormant,
    this.escheat,
    this.block,
    this.blockCredit,
    this.blockDebit,
  });

  factory SubStatus.fromJson(Map<String, dynamic> json) {
    return SubStatus(
      id: json['id'] as int,
      code: json['code'] as String,
      value: json['value'] as String,
      none: json['none'] as bool?,
      inactive: json['inactive'] as bool?,
      dormant: json['dormant'] as bool?,
      escheat: json['escheat'] as bool?,
      block: json['block'] as bool?,
      blockCredit: json['blockCredit'] as bool?,
      blockDebit: json['blockDebit'] as bool?,
    );
  }
}

class DepositType {
  final int id;
  final String code;
  final String value;

  DepositType({
    required this.id,
    required this.code,
    required this.value,
  });

  factory DepositType.fromJson(Map<String, dynamic> json) {
    return DepositType(
      id: json['id'] as int,
      code: json['code'] as String,
      value: json['value'] as String,
    );
  }
}

class AccountType {
  final int id;
  final String code;
  final String value;

  AccountType({
    required this.id,
    required this.code,
    required this.value,
  });

  factory AccountType.fromJson(Map<String, dynamic> json) {
    return AccountType(
      id: json['id'] as int,
      code: json['code'] as String,
      value: json['value'] as String,
    );
  }
}
