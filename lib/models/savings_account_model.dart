class SavingsAccountModel {
  final int? id;
  final String accountNo;
  final String? externalId;
  final int? productId;
  final String productName;
  final String shortProductName;
  final Status status;
  final Currency currency;
  final double? accountBalance;
  final AccountType accountType;
  final Timeline timeline;
  final SubStatus subStatus;
  final List<int>? lastActiveTransactionDate;
  final DepositType depositType;

  SavingsAccountModel({
    this.id,
    required this.accountNo,
    this.externalId,
    this.productId,
    required this.productName,
    required this.shortProductName,
    required this.status,
    required this.currency,
    this.accountBalance,
    required this.accountType,
    required this.timeline,
    required this.subStatus,
    this.lastActiveTransactionDate,
    required this.depositType,
  });

  factory SavingsAccountModel.fromJson(Map<String, dynamic> json) {
    return SavingsAccountModel(
      id: json['id'] as int?,
      accountNo: json['accountNo'] as String,
      externalId: json['externalId'] as String?,
      productId: json['productId'] as int?,
      productName: json['productName'] as String,
      shortProductName: json['shortProductName'] as String,
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
      currency: Currency.fromJson(json['currency'] as Map<String, dynamic>),
      accountBalance: (json['accountBalance'] as num?)?.toDouble() ?? 0.0,
      accountType:
          AccountType.fromJson(json['accountType'] as Map<String, dynamic>),
      timeline: Timeline.fromJson(json['timeline'] as Map<String, dynamic>),
      subStatus: SubStatus.fromJson(json['subStatus'] as Map<String, dynamic>),
      lastActiveTransactionDate: json['lastActiveTransactionDate'] != null
          ? List<int>.from(json['lastActiveTransactionDate'] as List)
          : null,
      depositType:
          DepositType.fromJson(json['depositType'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNo': accountNo,
      'externalId': externalId,
      'productId': productId,
      'productName': productName,
      'shortProductName': shortProductName,
      'status': status.toJson(),
      'currency': currency.toJson(),
      'accountBalance': accountBalance,
      'accountType': accountType.toJson(),
      'timeline': timeline.toJson(),
      'subStatus': subStatus.toJson(),
      'lastActiveTransactionDate': lastActiveTransactionDate,
      'depositType': depositType.toJson(),
    };
  }
}

class Status {
  final int? id;
  final String code;
  final String value;
  final bool submittedAndPendingApproval;
  final bool approved;
  final bool rejected;
  final bool withdrawnByApplicant;
  final bool active;
  final bool closed;
  final bool prematureClosed;
  final bool transferInProgress;
  final bool transferOnHold;
  final bool matured;

  Status({
    this.id,
    required this.code,
    required this.value,
    required this.submittedAndPendingApproval,
    required this.approved,
    required this.rejected,
    required this.withdrawnByApplicant,
    required this.active,
    required this.closed,
    required this.prematureClosed,
    required this.transferInProgress,
    required this.transferOnHold,
    required this.matured,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] as int?,
      code: json['code'] as String,
      value: json['value'] as String,
      submittedAndPendingApproval:
          json['submittedAndPendingApproval'] as bool? ?? false,
      approved: json['approved'] as bool? ?? false,
      rejected: json['rejected'] as bool? ?? false,
      withdrawnByApplicant: json['withdrawnByApplicant'] as bool? ?? false,
      active: json['active'] as bool? ?? false,
      closed: json['closed'] as bool? ?? false,
      prematureClosed: json['prematureClosed'] as bool? ?? false,
      transferInProgress: json['transferInProgress'] as bool? ?? false,
      transferOnHold: json['transferOnHold'] as bool? ?? false,
      matured: json['matured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
      'submittedAndPendingApproval': submittedAndPendingApproval,
      'approved': approved,
      'rejected': rejected,
      'withdrawnByApplicant': withdrawnByApplicant,
      'active': active,
      'closed': closed,
      'prematureClosed': prematureClosed,
      'transferInProgress': transferInProgress,
      'transferOnHold': transferOnHold,
      'matured': matured,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'decimalPlaces': decimalPlaces,
      'inMultiplesOf': inMultiplesOf,
      'displaySymbol': displaySymbol,
      'nameCode': nameCode,
      'displayLabel': displayLabel,
    };
  }
}

class AccountType {
  final int? id;
  final String code;
  final String value;

  AccountType({
    this.id,
    required this.code,
    required this.value,
  });

  factory AccountType.fromJson(Map<String, dynamic> json) {
    return AccountType(
      id: json['id'] as int?,
      code: json['code'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
    };
  }
}

class Timeline {
  final List<int>? submittedOnDate;
  final String submittedByUsername;
  final String submittedByFirstname;
  final String submittedByLastname;
  final List<int>? approvedOnDate;
  final String? approvedByUsername;
  final String? approvedByFirstname;
  final String? approvedByLastname;
  final List<int>? activatedOnDate;

  Timeline({
    this.submittedOnDate,
    required this.submittedByUsername,
    required this.submittedByFirstname,
    required this.submittedByLastname,
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
      submittedByUsername: json['submittedByUsername'] as String,
      submittedByFirstname: json['submittedByFirstname'] as String,
      submittedByLastname: json['submittedByLastname'] as String,
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

  Map<String, dynamic> toJson() {
    return {
      'submittedOnDate': submittedOnDate,
      'submittedByUsername': submittedByUsername,
      'submittedByFirstname': submittedByFirstname,
      'submittedByLastname': submittedByLastname,
      'approvedOnDate': approvedOnDate,
      'approvedByUsername': approvedByUsername,
      'approvedByFirstname': approvedByFirstname,
      'approvedByLastname': approvedByLastname,
      'activatedOnDate': activatedOnDate,
    };
  }
}

class SubStatus {
  final int? id;
  final String code;
  final String value;
  final bool none;
  final bool inactive;
  final bool dormant;
  final bool escheat;
  final bool block;
  final bool blockCredit;
  final bool blockDebit;

  SubStatus({
    this.id,
    required this.code,
    required this.value,
    required this.none,
    required this.inactive,
    required this.dormant,
    required this.escheat,
    required this.block,
    required this.blockCredit,
    required this.blockDebit,
  });

  factory SubStatus.fromJson(Map<String, dynamic> json) {
    return SubStatus(
      id: json['id'] as int?,
      code: json['code'] as String,
      value: json['value'] as String,
      none: json['none'] as bool? ?? false,
      inactive: json['inactive'] as bool? ?? false,
      dormant: json['dormant'] as bool? ?? false,
      escheat: json['escheat'] as bool? ?? false,
      block: json['block'] as bool? ?? false,
      blockCredit: json['blockCredit'] as bool? ?? false,
      blockDebit: json['blockDebit'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
      'none': none,
      'inactive': inactive,
      'dormant': dormant,
      'escheat': escheat,
      'block': block,
      'blockCredit': blockCredit,
      'blockDebit': blockDebit,
    };
  }
}

class DepositType {
  final int? id;
  final String code;
  final String value;

  DepositType({
    this.id,
    required this.code,
    required this.value,
  });

  factory DepositType.fromJson(Map<String, dynamic> json) {
    return DepositType(
      id: json['id'] as int?,
      code: json['code'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
    };
  }
}
