import 'package:flutter/widgets.dart';

import '../models/apartment.dart';
import '../models/search_session.dart';

class OfferEvent {
  OfferEvent({required this.priceRub, required this.zhkNames});
  final int priceRub;
  final List<String> zhkNames;
}

class AppState extends ChangeNotifier {
  AppState() {
    sessions = [
      SearchSession(id: 'a', title: 'Поиск A'),
      SearchSession(id: 'b', title: 'Поиск B'),
    ];
    _recomputeTqs();
  }

  late final List<SearchSession> sessions;
  int activeIndex = 0;

  // TQS components (demo)
  double pcqs = 68;
  double bpsQuality = 96;
  double osas = 28;
  double lqs = 35;
  double tqs = 55;

  final List<String> favoriteIds = [];
  final List<OfferEvent> offers = [];

  SearchSession get active => sessions[activeIndex];

  void selectSearch(int index) {
    activeIndex = index.clamp(0, sessions.length - 1);
    notifyListeners();
  }

  void setGoal(String goal) {
    final s = active;
    s.goal = goal;
    s.addTimeline(
      'Вы',
      goal == 'living' ? 'Цель: жить' : 'Цель: инвестировать',
      icon: 'flag',
    );
    s.addTimeline(
      'Агент',
      goal == 'living'
          ? 'Ок. Спрошу про семью, маршрут и школы — настройте фильтры ниже.'
          : 'Ок. Спрошу про горизонт и доходность — настройте фильтры ниже.',
      icon: 'agent',
    );
    osas = (osas + 5).clamp(0, 60);
    pcqs = (pcqs + 4).clamp(0, 100);
    _recomputeTqs();
    notifyListeners();
  }

  void updateBudget(double start, double end, {bool commit = true}) {
    active.filters.budget = RangeBounds(start, end);
    if (commit) {
      active.addTimeline('Фильтр', 'Бюджет: ${start.round()}–${end.round()} млн ₽', icon: 'filter');
      osas = (osas + 2).clamp(0, 60);
      _recomputeTqs();
    }
    notifyListeners();
  }

  void updateArea(double start, double end, {bool commit = true}) {
    active.filters.area = RangeBounds(start, end);
    if (commit) {
      active.addTimeline('Фильтр', 'Площадь: ${start.round()}–${end.round()} м²', icon: 'filter');
      osas = (osas + 2).clamp(0, 60);
      _recomputeTqs();
    }
    notifyListeners();
  }

  void updateRooms(Set<int> rooms) {
    active.filters.rooms = {...rooms};
    active.addTimeline('Фильтр', 'Комнаты: ${rooms.isEmpty ? 'любые' : rooms.join(", ")}', icon: 'filter');
    osas = (osas + 3).clamp(0, 60);
    _recomputeTqs();
    notifyListeners();
  }

  void updateMetro(double minutes, {bool commit = true}) {
    active.filters.metroMin = minutes;
    if (commit) {
      active.addTimeline('Фильтр', 'До метро: до ${minutes.round()} мин', icon: 'filter');
      osas = (osas + 1).clamp(0, 60);
      _recomputeTqs();
    }
    notifyListeners();
  }

  void updateDistricts(Set<String> districts) {
    active.filters.districts = {...districts};
    active.addTimeline('Фильтр', 'Округа: ${districts.join(", ")}', icon: 'filter');
    osas = (osas + 2).clamp(0, 60);
    _recomputeTqs();
    notifyListeners();
  }

  void updateFinishing(String finishing) {
    active.filters.finishing = finishing;
    active.addTimeline('Фильтр', 'Отделка: $finishing', icon: 'filter');
    osas = (osas + 1).clamp(0, 60);
    _recomputeTqs();
    notifyListeners();
  }

  void like(ApartmentPreview apt) {
    final s = active;
    if (!s.likedIds.contains(apt.id)) s.likedIds.add(apt.id);
    if (!favoriteIds.contains(apt.id)) favoriteIds.add(apt.id);
    s.addTimeline('Вы', 'Сохранено: ${apt.zhkName}', icon: 'like');
    osas = (osas + 12).clamp(0, 60); // favorite-like bump
    _recomputeTqs();
    notifyListeners();
  }

  void dislike(ApartmentPreview apt, {String? reason}) {
    final s = active;
    if (!s.dislikedIds.contains(apt.id)) s.dislikedIds.add(apt.id);
    if (reason != null) s.dislikeReasons[apt.id] = reason;
    s.addTimeline(
      'Вы',
      'Отклонено: ${apt.zhkName}${reason != null ? " ($reason)" : ""}',
      icon: 'dislike',
    );
    // honest reason slight bump; chaotic dislike without plan depth is neutral
    if (reason != null) osas = (osas + 2).clamp(0, 60);
    _recomputeTqs();
    notifyListeners();
  }

  void viewDetail(ApartmentPreview apt) {
    active.addTimeline('Вы', 'Открыта карточка: ${apt.zhkName}', icon: 'plan');
    osas = (osas + 8).clamp(0, 60); // layout card
    _recomputeTqs();
    notifyListeners();
  }

  void clearHistory() {
    final s = active;
    s.timeline.clear();
    s.likedIds.clear();
    s.dislikedIds.clear();
    s.dislikeReasons.clear();
    s.goal = null;
    s.deckIndex = 0;
    s.addTimeline('Система', 'История «${s.title}» очищена', icon: 'clear');
    osas = 20;
    lqs = 30;
    _recomputeTqs();
    notifyListeners();
  }

  void newSearch() {
    final s = active;
    s.filters = SearchFilters();
    s.likedIds.clear();
    s.dislikedIds.clear();
    s.dislikeReasons.clear();
    s.goal = null;
    s.deckIndex = 0;
    s.timeline.clear();
    s.addTimeline('Система', 'Новый поиск в «${s.title}»', icon: 'play');
    osas = 22;
    _recomputeTqs();
    notifyListeners();
  }

  void submitPriceOffer({
    required int priceRub,
    required List<String> zhkNames,
  }) {
    offers.add(OfferEvent(priceRub: priceRub, zhkNames: zhkNames));
    active.addTimeline(
      'Вы',
      'Ценовое предложение: ${(priceRub / 1e6).toStringAsFixed(1)} млн ₽ → ${zhkNames.join(", ")}',
      icon: 'offer',
    );
    lqs = (lqs + 18).clamp(0, 100);
    osas = (osas + 5).clamp(0, 60);
    _recomputeTqs();
    notifyListeners();
  }

  void submitMassOutreach({required List<String> zhkNames, required int priceRub}) {
    active.addTimeline(
      'Система',
      'Рассылка в очереди: ${zhkNames.length} ЖК по ${(priceRub / 1e6).toStringAsFixed(1)} млн ₽',
      icon: 'outreach',
    );
    lqs = (lqs + 12).clamp(0, 100);
    _recomputeTqs();
    notifyListeners();
  }

  void leaveLead(ApartmentPreview? apt) {
    active.addTimeline(
      'Вы',
      apt == null ? 'Заявка отправлена' : 'Заявка: ${apt.zhkName}',
      icon: 'lead',
    );
    lqs = (lqs + 20).clamp(0, 100);
    _recomputeTqs();
    notifyListeners();
  }

  List<ApartmentPreview> get favorites =>
      favoriteIds.map(ApartmentPreview.byId).toList();

  String get tqsBand {
    if (tqs >= 80) return 'горячий';
    if (tqs >= 50) return 'тёплый';
    if (tqs >= 25) return 'карантин';
    return 'слабый';
  }

  List<String> get raiseActions {
    final actions = <String>[];
    if (osas < 45) {
      actions.add('Откройте планировки и добавьте в избранное (+OSAS)');
    }
    if (active.goal == null) {
      actions.add('Выберите цель: жить или инвестировать');
    }
    if (lqs < 50) {
      actions.add('Укажите конкретный ЖК и оставьте заявку (+LQS)');
    }
    if (actions.isEmpty) {
      actions.add('Поддерживайте глубину просмотра — вы в хорошей зоне TQS');
    }
    return actions;
  }

  void _recomputeTqs() {
    // OSAS display is behavior part capped conceptually; demo uses osas as 0–60 mapped into 0–100 with audience stub
    final osasFull = (osas.clamp(0, 60) + 18).clamp(0, 100); // +18 audience stub
    tqs = 0.25 * pcqs + 0.20 * bpsQuality + 0.35 * osasFull + 0.20 * lqs;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.notifier!;
  }
}
