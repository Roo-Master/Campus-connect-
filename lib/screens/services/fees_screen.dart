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

class _FeesScreenState extends State<FeesScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> transactions = [
    {
      "no": 1,
      "date": "01/09/2024",
      "ref": "INV001",
      "description": "Tuition Fee - Semester 1",
      "debit": 50000,
      "credit": 0,
      "balance": 50000
    },
    {
      "no": 2,
      "date": "10/09/2024",
      "ref": "PAY001",
      "description": "MPESA Payment",
      "debit": 0,
      "credit": 20000,
      "balance": 30000
    },
    {
      "no": 3,
      "date": "01/10/2024",
      "ref": "PAY002",
      "description": "Bank Deposit",
      "debit": 0,
      "credit": 15000,
      "balance": 15000
    },
  ];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isGeneratingPDF = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _generateAndSharePDF() async {
    setState(() => _isGeneratingPDF = true);
    
    try {
      final file = await generateProfessionalFeeStatementPDF(
        transactions,
        widget.user ?? UserModel(),
        widget.term,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Fee Statement saved to ${file.path.split('/').last}')),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to generate PDF: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPDF = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileService>(
      builder: (context, profileService, child) {
        final currentUser = widget.user ?? profileService.user;

        if (currentUser == null) {
          return _buildEmptyState();
        }

        final totals = _calculateTotals();
        
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: _buildAppBar(currentUser),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(currentUser)),
                SliverToBoxAdapter(child: const SizedBox(height: 24)),
                _buildTermTitle(),
                SliverToBoxAdapter(child: const SizedBox(height: 20)),
                _buildTransactionsSection(totals),
                SliverToBoxAdapter(child: const SizedBox(height: 24)),
                _buildActionButtons(),
                SliverToBoxAdapter(child: const SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(null),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(Icons.receipt_long, size: 64, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            Text(
              "Loading Fee Statement...",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Fetching your financial records",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(UserModel? user) {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text("Fee Statement", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.pop(context),
        style: IconButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          padding: const EdgeInsets.all(12),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: _isGeneratingPDF ? null : _generateAndSharePDF,
          tooltip: "Export PDF",
        ),
      ],
    );
  }

  Widget _buildHeader(UserModel user) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.indigo.shade500, Colors.blue.shade500]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 20),
              ],
            ),
            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName ?? "Student Name",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoChip(Icons.badge_outlined, "Reg No: ${user.studentId ?? ''}"),
                _buildInfoChip(Icons.school_outlined, "Programme: ${user.program ?? ''}"),
                _buildInfoChip(Icons.business_outlined, "Department: ${user.department ?? ''}"),
                _buildInfoChip(Icons.schedule_outlined, "Term: ${widget.term}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermTitle() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.segment, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 16),
            const Text(
              "Fee Transactions",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(Map<String, dynamic> totals) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Custom Transaction List (better than PaginatedDataTable)
              _buildTransactionHeader(),
              ...transactions.map((transaction) => _buildTransactionRow(transaction)),
              _buildTotalsRow(totals),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text("No", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Date", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Ref", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text("Description", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Debit", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Credit", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text("Balance", style: TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> transaction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTransactionDetails(transaction),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text(transaction["no"].toString())),
                Expanded(flex: 2, child: Text(transaction["date"])),
                Expanded(flex: 2, child: _buildRefChip(transaction["ref"])),
                Expanded(
                  flex: 3,
                  child: Text(
                    transaction["description"],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildAmount(transaction["debit"], isDebit: true),
                ),
                Expanded(
                  flex: 2,
                  child: _buildAmount(transaction["credit"], isDebit: false),
                ),
                Expanded(
                  flex: 2,
                  child: _buildBalance(transaction["balance"]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefChip(String ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ref,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAmount(int amount, {required bool isDebit}) {
    if (amount == 0) return const SizedBox();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDebit ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "KES ${amount.toStringAsFixed(0)}",
        style: TextStyle(
          color: isDebit ? Colors.red.shade700 : Colors.green.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildBalance(int balance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: balance > 0 ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: balance > 0 ? Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Text(
        "KES ${balance.toStringAsFixed(0)}",
        style: TextStyle(
          color: balance > 0 ? Colors.red.shade700 : Colors.green.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTotalsRow(Map<String, dynamic> totals) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Debit", style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text(
                  "KES ${totals['totalDebit'].toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Credit", style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text(
                  "KES ${totals['totalCredit'].toStringAsFixed(0)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Remaining Balance",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "KES ${totals['balance'].toStringAsFixed(0)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: totals['balance'] > 0 ? Colors.red.shade700 : Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isGeneratingPDF ? null : _generateAndSharePDF,
                icon: _isGeneratingPDF
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.download),
                label: Text(_isGeneratingPDF ? "Generating..." : "Download PDF"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isGeneratingPDF ? null : () => _showPaymentOptions(),
                icon: const Icon(Icons.payment),
                label: const Text("Make Payment"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: BorderSide(color: Colors.green.shade600, width: 2),
                  foregroundColor: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                transaction["debit"] > 0 ? Icons.trending_up : Icons.trending_down,
                color: Colors.blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction["description"], style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text("Ref: ${transaction["ref"]}", style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Date", transaction["date"]),
            _buildDetailRow("Debit", "KES ${transaction["debit"]}", isDebit: true),
            _buildDetailRow("Credit", "KES ${transaction["credit"]}", isDebit: false),
            _buildDetailRow("Balance", "KES ${transaction["balance"]}", isBalance: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isDebit = false, bool isBalance = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDebit 
                    ? Colors.red.withOpacity(0.05)
                    : isBalance && value.contains('0') 
                        ? Colors.green.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDebit 
                      ? Colors.red.shade700
                      : isBalance && !value.contains('0')
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Make Payment",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose payment method:",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildPaymentMethod(Icons.payment, "MPESA", "Pay via M-PESA"),
            _buildPaymentMethod(Icons.account_balance, "Bank Deposit", "RTGS/Deposit Slip"),
            _buildPaymentMethod(Icons.credit_card, "Card", "Visa/Mastercard"),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected $title payment')),
        );
      },
    );
  }

  Map<String, dynamic> _calculateTotals() {
    final totalDebit = transactions.fold<int>(0, (sum, row) => sum + (row["debit"] as int));
    final totalCredit = transactions.fold<int>(0, (sum, row) => sum + (row["credit"] as int));
    final balance = totalDebit - totalCredit;
    
    return {
      'totalDebit': totalDebit,
      'totalCredit': totalCredit,
      'balance': balance,
    };
  }

  /// Professional PDF Generation
  Future<File> generateProfessionalFeeStatementPDF(
    List<Map<String, dynamic>> transactions,
    UserModel user,
    String term,
  ) async {
    final pdf = pw.Document();
    final totals = _calculateTotals();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: pw.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("KISII UNIVERSITY", 
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text("Fee Statement", 
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Generated: ${DateTime.now().toString().split(' ')[0]}"),
                    pw.Text("Term: $term"),
                  ],
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 20),
          
          // Student Info
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: pw.PdfColor.fromHex("#E3F2FD"),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Student: ${user.fullName ?? ''}"),
                    pw.Text("Programme: ${user.program ?? ''}"),
                    pw.Text("Department: ${user.department ?? ''}"),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Reg No: ${user.studentId ?? ''}"),
                    pw.Text("Term: $term"),
                  ],
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Table
          pw.Table(
            border: pw.TableBorder.all(color: pw.PdfColor.fromHex("#808080")),
            defaultColumnWidth: const pw.FlexColumnWidth(),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: pw.PdfColor.fromHex("#F5F5F5")),
                children: [
                  _pdfTableCell("No", isHeader: true),
                  _pdfTableCell("Date", isHeader: true),
                  _pdfTableCell("Ref", isHeader: true),
                  _pdfTableCell("Description", isHeader: true),
                  _pdfTableCell("Debit (KES)", isHeader: true),
                  _pdfTableCell("Credit (KES)", isHeader: true),
                  _pdfTableCell("Balance (KES)", isHeader: true),
                ],
              ),
              ...transactions.map((row) => pw.TableRow(
                children: [
                  _pdfTableCell(row["no"].toString()),
                  _pdfTableCell(row["date"]),
                  _pdfTableCell(row["ref"]),
                  _pdfTableCell(row["description"]),
                  _pdfTableCell(row["debit"].toString()),
                  _pdfTableCell(row["credit"].toString()),
                  _pdfTableCell(row["balance"].toString()),
                ],
              )),
            ],
          ),
          
          pw.SizedBox(height: 20),
          
          // Totals
          pw.Divider(),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Total Debit:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("KES ${totals['totalDebit']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Total Credit:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("KES ${totals['totalCredit']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: totals['balance'] > 0 
                  ? const pw.PdfColor.fromInt(0xFFFFEBEE)
                  : const pw.PdfColor.fromInt(0xFFE8F5E8),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Remaining Balance:", 
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Text("KES ${totals['balance']}", 
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                    color: totals['balance'] > 0 
                        ? const pw.PdfColor.fromInt(0xFFFF0000)
                        : const pw.PdfColor.fromInt(0xFF008000),
                  )),
              ],
            ),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File("${dir.path}/fee_statement_${user.studentId ?? 'student'}_$timestamp.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _pdfTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}