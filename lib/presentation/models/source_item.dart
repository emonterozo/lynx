import '../../core/enums/app_enums.dart';

class SourceItem {
  final int id;
  final String name;
  final SourceType type;
  final List<List<dynamic>> icon;

  const SourceItem({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });
}
