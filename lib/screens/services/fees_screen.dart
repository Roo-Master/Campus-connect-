import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../models/user_model.dart';

class FeesScreen extends StatefulWidget {
  final UserModel user;
  final String term; // Pass semester/term info if needed

  const FeesScreen({super.key, required this.user, required this.term, required userModel});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  List<Map<String, dynamic>> transactions = [
    {
      "no": 1,
      "date": "01/09/2024",
      "ref": "INV001",
      "description": "Tuition Fee",
      "debit": 50000,
      "credit": 0,
      "balance": 50000
    },
    {
      "no": 2,
      "date": "10/09/2024",
      "ref": "PAY001",
      "description": "Fee Payment",
      "debit": 0,
      "credit": 20000,
      "balance": 30000
    },
    {
      "no": 3,
      "date": "01/10/2024",
      "ref": "PAY002",
      "description": "Fee Payment",
      "debit": 0,
      "credit": 15000,
      "balance": 15000
    },
  ];

  int rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Fee Statement"),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// STUDENT DETAILS HEADER
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("STUDENTNAME: ${user.fullName}"),
                        Text("PROGRAMME: ${user.program ?? ''}"),
                        Text("DEPARTMENT: ${user.department ?? ''}"),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("REGNO: ${user.studentId ?? ''}"),
                      Text("ADMISSION YEAR: ${user.year ?? ''}"),
                      Text("YEAR OF STUDY: Year ${user.year ?? ''}"),
                      Text("TERM: ${widget.term}"),
                    ],
                  )
                ],
              ),
            ),

            const Divider(height: 1),

            /// UNIVERSITY NAVBAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.white,
              child: Row(
                children: [
                  const Text(
                    "Kisii University",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_outlined, size: 28),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "0",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(width: 6),
                      Text("Hi, ${user.firstName ?? ''}"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// SEMESTER TITLE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.term,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// TABLE CONTAINER
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: PaginatedDataTable(
                columnSpacing: 30,
                header: const Text(
                  "Fee Statement",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                rowsPerPage: rowsPerPage,
                columns: const [
                  DataColumn(label: Text("No")),
                  DataColumn(label: Text("Date")),
                  DataColumn(label: Text("Ref")),
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Text("Debit(KES)")),
                  DataColumn(label: Text("Credit(KES)")),
                  DataColumn(label: Text("Balance(KES)")),
                ],
                source: FeeTable(transactions),
              ),
            ),

            const SizedBox(height: 10),

            /// ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text("Download Statement"),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final file = await generateFeeStatementPDF(transactions, user, widget.term);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('PDF saved to ${file.path}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Export PDF"),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<File> generateFeeStatementPDF(
      List transactions, UserModel user, String term) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Kisii University Fee Statement",
                style: pw.TextStyle(
                    fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 12),
              pw.Text("Name: ${user.fullName}"),
              pw.Text("Reg No: ${user.studentId ?? ''}"),
              pw.Text("Programme: ${user.program ?? ''}"),
              pw.Text("Department: ${user.department ?? ''}"),
              pw.Text("Term: $term"),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  "No",
                  "Date",
                  "Ref",
                  "Description",
                  "Debit",
                  "Credit",
                  "Balance"
                ],
                data: transactions.map((row) {
                  return [
                    row["no"].toString(),
                    row["date"],
                    row["ref"],
                    row["description"],
                    row["debit"].toString(),
                    row["credit"].toString(),
                    row["balance"].toString(),
                  ];
                }).toList(),
              )
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/fee_statement.pdf");

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}

/// DATA SOURCE FOR TABLE
class FeeTable extends DataTableSource {
  final List<Map<String, dynamic>> data;

  FeeTable(this.data);

  @override
  DataRow getRow(int index) {
    final row = data[index];

    return DataRow(cells: [
      DataCell(Text(row["no"].toString())),
      DataCell(Text(row["date"])),
      DataCell(Text(row["ref"])),
      DataCell(Text(row["description"])),
      DataCell(Text(row["debit"].toString())),
      DataCell(Text(row["credit"].toString())),
      DataCell(Text(row["balance"].toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}