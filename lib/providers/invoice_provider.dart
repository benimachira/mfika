import 'package:flutter/cupertino.dart';

import '../models/invoice.dart';
import '../samples/sample_data.dart';

class InvoiceProvider with ChangeNotifier {
  List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  void fetchInvoices() {
    _invoices.clear();

    for (var invoiceData in sampleData['invoices']) {
      _invoices.add(Invoice.fromJson(invoiceData));
    }

    notifyListeners();
  }
}

