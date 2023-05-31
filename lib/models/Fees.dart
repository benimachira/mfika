class Fees {
  final FeeStatement? feeStatement;

  Fees({required this.feeStatement});

  factory Fees.fromJson(Map<String, dynamic> json) {
    return Fees(
      feeStatement: json['fee_statement'] != null
          ? FeeStatement.fromJson(json['fee_statement'])
          : null,
    );
  }

}

class FeeStatement {
  final FeeStructure? feeStructure;
  final List<FeePayment>? feePayments;

  FeeStatement({required this.feeStructure, required this.feePayments});

  factory FeeStatement.fromJson(Map<String, dynamic> json) {
    var list = json['fee_payments'] as List?;
    List<FeePayment> feePaymentList = list?.map((i) => FeePayment.fromJson(i)).toList() ?? [];

    return FeeStatement(
      feeStructure: json['fee_structure'] != null
          ? FeeStructure.fromJson(json['fee_structure'])
          : null,
      feePayments: feePaymentList,
    );
  }
}

class FeeStructure {
  final dynamic? id, student, status;
  final dynamic? amount, year, term;
  final DateTime? createdAt, updatedAt;

  FeeStructure({this.id, this.student, this.amount, this.year, this.term, this.status, this.createdAt, this.updatedAt});

  factory FeeStructure.fromJson(Map<String, dynamic> json) {
    return FeeStructure(
      id: json['id'],
      student: json['student'],
      amount: json['amount'],
      year: json['year'],
      term: json['term'],
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}

class FeePayment {
  final dynamic? id, schoolFeesId, student;
  final dynamic? receiptNumber, amountPaid, paymentMethod, balance;
  final dynamic datePaid, createdAt, updatedAt;

  FeePayment({this.id, this.receiptNumber, this.schoolFeesId, this.student, this.amountPaid, this.paymentMethod, this.balance, this.datePaid, this.createdAt, this.updatedAt});

  factory FeePayment.fromJson(Map<String, dynamic> json) {
    return FeePayment(
      id: json['id'],
      receiptNumber: json['receipt_number'],
      schoolFeesId: json['school_fees_id'],
      student: json['student'],
      amountPaid: json['amount_paid'],
      paymentMethod: json['payment_method'],
      balance: json['balance'],
      datePaid: json['date_paid'] != null ? DateTime.parse(json['date_paid']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
