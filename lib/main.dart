import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:lynx/data/models/budget.dart';
import 'package:lynx/data/models/credit_card.dart';
import 'package:lynx/data/models/debt_obligation.dart';
import 'package:lynx/data/models/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_it/get_it.dart';
import 'core/theme.dart';
import 'data/models/wallet.dart';
import 'screens/analytics_tab.dart';
import 'screens/home_tab.dart';
import 'screens/settings_tab.dart';
import 'screens/transaction_form.dart';
import 'screens/vault_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([
    WalletSchema,
    CreditCardSchema,
    DebtObligationSchema,
    BudgetSchema,
    TransactionSchema,
  ], directory: dir.path);

  GetIt.instance.registerSingleton<Isar>(isar);
  runApp(const LynxApp());
}

class LynxApp extends StatelessWidget {
  const LynxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LynxTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentTabIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    const AnalyticsTab(),
    const VaultTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentTabIndex, children: _pages),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: LynxTheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionForm()),
            );
          },
          backgroundColor: LynxTheme.primary,
          elevation: 0,
          shape: const CircleBorder(),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd02,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 70,
        color: LynxTheme.card,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              index: 0,
              icon: HugeIcons.strokeRoundedHome07,
              label: "Home",
            ),
            _buildTabItem(
              index: 1,
              icon: HugeIcons.strokeRoundedChartAnalysis,
              label: "Analytics",
            ),
            const SizedBox(width: 48),
            _buildTabItem(
              index: 2,
              icon: HugeIcons.strokeRoundedPiggyBank,
              label: "Vault",
            ),
            _buildTabItem(
              index: 3,
              icon: HugeIcons.strokeRoundedSettings01,
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required List<List<dynamic>> icon,
    required String label,
  }) {
    bool isSelected = _currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentTabIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: icon,
            color: isSelected ? LynxTheme.primary : LynxTheme.mutedForeground,
            size: 28,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: LynxTheme.fontFamily,
              fontSize: 10,
              color: isSelected ? LynxTheme.primary : LynxTheme.mutedForeground,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
