import 'apartment.dart';

class SearchFilters {
  SearchFilters({
    this.budget = const RangeBounds(12, 35),
    this.area = const RangeBounds(30, 80),
    Set<int>? rooms,
    this.metroMin = 15,
    Set<String>? districts,
    this.finishing = 'whitebox',
  })  : rooms = rooms ?? {1, 2},
        districts = districts ?? {'САО', 'ЗАО'};

  RangeBounds budget; // млн ₽
  RangeBounds area; // м²
  Set<int> rooms;
  double metroMin;
  Set<String> districts;
  String finishing;

  SearchFilters copy() => SearchFilters(
        budget: budget,
        area: area,
        rooms: {...rooms},
        metroMin: metroMin,
        districts: {...districts},
        finishing: finishing,
      );
}

class RangeBounds {
  const RangeBounds(this.start, this.end);
  final double start;
  final double end;
}

class TimelineEntry {
  TimelineEntry({
    required this.actor,
    required this.text,
    required this.iconName,
    DateTime? at,
  }) : at = at ?? DateTime.now();

  final String actor;
  final String text;
  final String iconName;
  final DateTime at;
}

class SearchSession {
  SearchSession({
    required this.id,
    required this.title,
    SearchFilters? filters,
    List<TimelineEntry>? timeline,
  })  : filters = filters ?? SearchFilters(),
        timeline = timeline ??
            [
              TimelineEntry(
                actor: 'Система',
                text: 'Сессия «$title» создана',
                iconName: 'play',
              ),
            ];

  final String id;
  String title;
  SearchFilters filters;
  final List<TimelineEntry> timeline;
  String? goal; // living | investor
  final List<String> likedIds = [];
  final List<String> dislikedIds = [];
  final Map<String, String> dislikeReasons = {};
  int deckIndex = 0;

  void addTimeline(String actor, String text, {String icon = 'info'}) {
    timeline.add(TimelineEntry(actor: actor, text: text, iconName: icon));
  }

  List<ApartmentPreview> filteredCatalog() {
    return ApartmentPreview.catalog.where((a) {
      final priceM = a.priceRub / 1e6;
      if (priceM < filters.budget.start || priceM > filters.budget.end) return false;
      if (a.areaM2 < filters.area.start || a.areaM2 > filters.area.end) return false;
      if (filters.rooms.isNotEmpty && !filters.rooms.contains(a.rooms)) return false;
      if (filters.districts.isNotEmpty && !filters.districts.contains(a.district)) {
        return false;
      }
      if (a.metroMin > filters.metroMin.round()) return false;
      if (filters.finishing != 'any' && a.finishing != filters.finishing) {
        // soft: still allow if finishing is none when filter whitebox? keep strict for prototype
        return a.finishing == filters.finishing;
      }
      if (likedIds.contains(a.id) || dislikedIds.contains(a.id)) return false;
      return true;
    }).toList();
  }

  /// Match % 0–100 vs current filters.
  int matchPercent(ApartmentPreview a) {
    var score = 40.0;
    final priceM = a.priceRub / 1e6;
    final mid = (filters.budget.start + filters.budget.end) / 2;
    final priceDist = (priceM - mid).abs() / (filters.budget.end - filters.budget.start + 0.1);
    score += (1 - priceDist.clamp(0, 1)) * 25;
    if (filters.rooms.contains(a.rooms)) score += 15;
    if (filters.districts.contains(a.district)) score += 12;
    if (a.metroMin <= filters.metroMin) score += 8;
    if (a.finishing == filters.finishing) score += 5;
    return score.clamp(35, 98).round();
  }

  Map<String, double> probability() {
    final all = ApartmentPreview.catalog.length;
    final fit = filteredCatalog().length + likedIds.length;
    final inventoryFit = (fit / all).clamp(0.05, 0.95);
    final span = filters.budget.end - filters.budget.start;
    final competition = (1 - (span / 80)).clamp(0.15, 0.9);
    final budgetRealism = (filters.budget.end >= 18 ? 0.85 : 0.55).toDouble();
    return {
      'inventoryFit': inventoryFit,
      'competition': competition,
      'budgetRealism': budgetRealism,
    };
  }
}
