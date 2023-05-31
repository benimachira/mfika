import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../providers/invoice_provider.dart';

List<Invoice> invoices = [
  Invoice(
    invoiceNumber: 'INV-001',
    studentName: 'John Doe',
    grade: '10',
    term: '2',
    amount: 500.0,
    dueDate: '2023-05-01',
    datePaid: '',
    isPaid: false,
  ),
  Invoice(
    invoiceNumber: 'INV-002',
    studentName: 'Jane Smith',
    grade: '11',
    term: '2',
    amount: 600.0,
    dueDate: '2023-05-01',
    datePaid: '',
    isPaid: false,
  ),
  Invoice(
    invoiceNumber: 'INV-003',
    studentName: 'Bob Johnson',
    grade: '9',
    term: '2',
    amount: 400.0,
    dueDate: '2023-05-01',
    datePaid: '',
    isPaid: true,
  ),
  Invoice(
    invoiceNumber: 'INV-004',
    studentName: 'Alice Lee',
    grade: '12',
    term: '2',
    amount: 700.0,
    dueDate: '2023-05-01',
    datePaid: '2023-04-20',
    isPaid: true,
  ),
];

class InvoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending Invoice'),
              Tab(text: 'Paid Invoice'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingInvoiceTab(),
            PaidInvoiceTab(),
          ],
        ),
      ),
    );
  }
}

class PendingInvoiceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, invoiceProvider, child) {

        return ListView.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final invoice = invoices[index];
            return Card(
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  title: Row(
                    children: [

                      Expanded(
                          child: Text("${index+1}. ${invoice.invoiceNumber}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),)),
                      Icon(Icons.hourglass_top,size: 18,),

                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2,),
                      Text('${invoice.studentName}',style: TextStyle(fontSize: 13)),
                      Text('Grade ${invoice.grade}',style: TextStyle(fontSize: 13,)),
                      Text('Term ${invoice.term}',style: TextStyle(fontSize: 13)),
                      Text('Due on ${invoice.dueDate}',style: TextStyle(fontSize: 13)),
                      SizedBox(height: 4,),
                      Text('Total \$${invoice.amount}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black),),

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PaidInvoiceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, invoiceProvider, child) {

        return ListView.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final invoice = invoices[index];
            return Card(
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  title: Row(
                    children: [

                      Expanded(
                          child: Text("${index+1}. ${invoice.invoiceNumber}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),)),
                      Icon(Icons.check,size: 18,color: Colors.green,),

                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2,),
                      Text('${invoice.studentName}',style: TextStyle(fontSize: 13)),
                      Text('Grade ${invoice.grade}',style: TextStyle(fontSize: 13,)),
                      Text('Term ${invoice.term}',style: TextStyle(fontSize: 13)),
                      Text('Due on ${invoice.dueDate}',style: TextStyle(fontSize: 13)),
                      SizedBox(height: 4,),
                      Text('Total \$${invoice.amount}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black),),

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
