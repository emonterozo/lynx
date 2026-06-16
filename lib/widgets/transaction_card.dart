import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../core/enums/app_enums.dart';
import '../core/theme.dart';
import '../core/utils/number_utils.dart';
import '../screens/transaction_form.dart';

final DateFormat dateFormat = DateFormat('EEE, MMM dd');

class TransactionCard extends StatefulWidget {
  const TransactionCard({
    super.key,
    required this.transactionFlowType,
    required this.transactionId,
    required this.transactionType,
    required this.transactionNote,
    required this.transactionSource,
    required this.amount,
    required this.date,
    this.onTap,
  });

  final FlowType transactionFlowType;
  final Id transactionId;
  final TransactionType transactionType;
  final String transactionNote;
  final String transactionSource;
  final double amount;
  final DateTime date;
  final VoidCallback? onTap;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    final isExpense = widget.transactionFlowType == FlowType.expense;
    final sign = isExpense ? "-" : "+";
    final color = isExpense ? LynxTheme.error : LynxTheme.success;

    final formattedDate = dateFormat.format(widget.date);

    final formattedAmount =
        "$sign₱${NumberUtils.currencyFormatter(widget.amount)}";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TransactionForm(transactionId: widget.transactionId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LynxTheme.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: widget.transactionType.icon,
              color: LynxTheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transactionNote,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.transactionSource,
                    style: const TextStyle(
                      fontSize: 12,
                      color: LynxTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                Text(
                  formattedAmount,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: LynxTheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
