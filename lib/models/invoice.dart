class Invoice {
  final String invoiceNumber;
  final String studentName;
  final String grade;
  final String term;
  final double amount;
  final String dueDate;
  final String? datePaid;
  final bool? isPaid;

  Invoice({
    required this.invoiceNumber,
    required this.studentName,
    required this.grade,
    required this.term,
    required this.amount,
    required this.dueDate,
    required this.datePaid,
    required this.isPaid,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceNumber: json['invoice_number'],
      studentName: json['student_name'],
      grade: json['grade'],
      term: json['term'],
      amount: json['amount'].toDouble(),
      dueDate: json['due_date'],
      datePaid: json['date_paid'],
      isPaid: json['isPaid'],
    );
  }

}
