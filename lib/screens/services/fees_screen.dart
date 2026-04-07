import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart' as pw;
import '../../models/user_model.dart';
import '../services/profile_services.dart';

class FeesScreen extends StatefulWidget {
  final UserModel? user;
  final String term;

  const FeesScreen({
    super.key,
    this.user,
    required this.term,
  });

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  final List<Map<String, dynamic>> transactions = [
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
  void dispose() {
    // Add controllers here later if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileService>(
      builder: (context, profileService, child) {
        final currentUser = widget.user ?? profileService.user;

        if (currentUser == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final totalDebit = transactions.fold<int>(
          0,
          (sum, row) => sum + (row["debit"] as int),
        );

        final totalCredit = transactions.fold<int>(
          0,
          (sum, row) => sum + (row["credit"] as int),
        );

        final remainingBalance = totalDebit - totalCredit;

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
                            Text("STUDENTNAME: ${currentUser.fullName}"),
                            Text("PROGRAMME: ${currentUser.program ?? ''}"),
                            Text("DEPARTMENT: ${currentUser.department ?? ''}"),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("REGNO: ${currentUser.studentId ?? ''}"),
                          Text("ADMISSION YEAR: ${currentUser.year ?? ''}"),
                          Text("YEAR OF STUDY: Year ${currentUser.year ?? ''}"),
                          Text("TERM: ${widget.term}"),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                /// UNIVERSITY NAVBAR
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
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
                          const Icon(
                            Icons.notifications_outlined,
                            size: 28,
                          ),
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
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          const Icon(Icons.person_outline),
                          const SizedBox(width: 6),
                          Text("Hi, ${currentUser.firstName ?? ''}"),
                        ],
                      ),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PaginatedDataTable(
                    columnSpacing: 20,
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

                /// TOTALS
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Debit: KES $totalDebit",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Total Credit: KES $totalCredit",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Remaining Balance: KES $remainingBalance",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: remainingBalance > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final file = await generateFeeStatementPDF(
                          transactions,
                          currentUser,
                          widget.term,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Statement saved to ${file.path}'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: const Text("Download Statement"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final file = await generateFeeStatementPDF(
                          transactions,
                          currentUser,
                          widget.term,
                        );

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
      },
    );
  }

  /// PDF generation with totals
  Future<File> generateFeeStatementPDF(
    List<Map<String, dynamic>> transactions,
    UserModel user,
    String term,
  ) async {
    final pdf = pw.Document();

    final totalDebit = transactions.fold<int>(
      0,
      (sum, row) => sum + (row["debit"] as int),
    );

    final totalCredit = transactions.fold<int>(
      0,
      (sum, row) => sum + (row["credit"] as int),
    );

    final remainingBalance = totalDebit - totalCredit;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Kisii University Fee Statement",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
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
                  "Debit(KES)",
                  "Credit(KES)",
                  "Balance(KES)"
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
              ),
              pw.Divider(),
              pw.SizedBox(height: 12),
              pw.Text(
                "Total Debit: KES $totalDebit",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "Total Credit: KES $totalCredit",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "Remaining Balance: KES $remainingBalance",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: remainingBalance > 0
                      ? pw.PdfColor.fromInt(0xFFFF0000)
                      : pw.PdfColor.fromInt(0xFF008000),
                ),
              ),
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
    if (index >= data.length) {
      return const DataRow(cells: [
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
      ]);
    }

    final row = data[index];

    return DataRow(
      cells: [
        DataCell(Text(row["no"].toString())),
        DataCell(Text(row["date"].toString())),
        DataCell(Text(row["ref"].toString())),
        DataCell(Text(row["description"].toString())),
        DataCell(Text(row["debit"].toString())),
        DataCell(Text(row["credit"].toString())),
        DataCell(Text(row["balance"].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}