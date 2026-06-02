import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../core/theme.dart';
import '../data/models/credit_card.dart';
import '../data/models/wallet.dart';

final currencyFormatter = NumberFormat("#,##0.00", "en_PH");

class WalletCard extends StatefulWidget {
  const WalletCard({super.key, required this.account, this.onTap});

  final dynamic account;
  final VoidCallback? onTap;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  Future<void> _handleToggle() async {
    final bool currentStatus = widget.account.showBalance;

    final isar = GetIt.I<Isar>();

    await isar.writeTxn(() async {
      widget.account.showBalance = !currentStatus;
      if (widget.account is Wallet) {
        await isar.wallets.put(widget.account);
      } else if (widget.account is CreditCard) {
        await isar.creditCards.put(widget.account);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final name = account.name;
    final balance = account.balance;
    final typeLabel = account is Wallet
        ? account.type.label
        : "•••• ${account.lastFourDigits}";
    final icon = account is Wallet
        ? account.type.icon
        : HugeIcons.strokeRoundedCreditCard;

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LynxTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: LynxTheme.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Balance",
              style: TextStyle(fontSize: 12, color: LynxTheme.mutedForeground),
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    account.showBalance
                        ? "₱ ${currencyFormatter.format(balance)}"
                        : "••••••••",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _handleToggle,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: HugeIcon(
                      icon: account.showBalance
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOff,
                      size: 15,
                      color: LynxTheme.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        typeLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: LynxTheme.mutedForeground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                HugeIcon(
                  icon: icon,
                  size: 20,
                  color: LynxTheme.primary.withValues(alpha: 0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
