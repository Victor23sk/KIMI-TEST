class ApartmentPreview {
  const ApartmentPreview({
    required this.id,
    required this.zhkName,
    required this.priceRub,
    required this.areaM2,
    required this.rooms,
    required this.floor,
    required this.district,
    required this.planAsset,
    required this.zhkAsset,
    required this.finishing,
    this.delivery = '2026',
    this.metroMin = 12,
  });

  final String id;
  final String zhkName;
  final int priceRub;
  final double areaM2;
  final int rooms; // 0 = studio
  final int floor;
  final String district;
  final String planAsset;
  final String zhkAsset;
  final String finishing; // none | whitebox | turnkey
  final String delivery;
  final int metroMin;

  String get priceLabel {
    final m = priceRub / 1e6;
    return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)} млн ₽';
  }

  static const catalog = <ApartmentPreview>[
    ApartmentPreview(
      id: 'apt-1',
      zhkName: 'ЖК «Речной»',
      priceRub: 18500000,
      areaM2: 42.5,
      rooms: 1,
      floor: 12,
      district: 'САО',
      planAsset: 'assets/images/plans/gen_plan_1.png',
      zhkAsset: 'assets/images/zhk/zhk_1.jpg',
      finishing: 'whitebox',
      metroMin: 8,
    ),
    ApartmentPreview(
      id: 'apt-2',
      zhkName: 'ЖК «Северный Порт»',
      priceRub: 24200000,
      areaM2: 58.0,
      rooms: 2,
      floor: 8,
      district: 'САО',
      planAsset: 'assets/images/plans/gen_plan_2.png',
      zhkAsset: 'assets/images/zhk/zhk_2.jpg',
      finishing: 'turnkey',
      metroMin: 12,
    ),
    ApartmentPreview(
      id: 'apt-3',
      zhkName: 'ЖК «Событие»',
      priceRub: 31200000,
      areaM2: 71.2,
      rooms: 2,
      floor: 21,
      district: 'ЗАО',
      planAsset: 'assets/images/plans/gen_plan_3.png',
      zhkAsset: 'assets/images/zhk/zhk_3.jpg',
      finishing: 'whitebox',
      metroMin: 10,
    ),
    ApartmentPreview(
      id: 'apt-4',
      zhkName: 'ЖК «Символ»',
      priceRub: 15800000,
      areaM2: 36.0,
      rooms: 0,
      floor: 5,
      district: 'ЮВАО',
      planAsset: 'assets/images/plans/plan_wiki1.png',
      zhkAsset: 'assets/images/zhk/zhk_4.jpg',
      finishing: 'none',
      metroMin: 15,
    ),
    ApartmentPreview(
      id: 'apt-5',
      zhkName: 'ЖК «Headliner»',
      priceRub: 42800000,
      areaM2: 84.0,
      rooms: 3,
      floor: 28,
      district: 'ЦАО',
      planAsset: 'assets/images/plans/blueprint_a.jpg',
      zhkAsset: 'assets/images/zhk/zhk_5.jpg',
      finishing: 'turnkey',
      metroMin: 6,
    ),
    ApartmentPreview(
      id: 'apt-6',
      zhkName: 'ЖК «Level»',
      priceRub: 27600000,
      areaM2: 62.5,
      rooms: 2,
      floor: 14,
      district: 'ЮАО',
      planAsset: 'assets/images/plans/gen_plan_2.png',
      zhkAsset: 'assets/images/zhk/zhk_6.jpg',
      finishing: 'whitebox',
      metroMin: 11,
    ),
    ApartmentPreview(
      id: 'apt-7',
      zhkName: 'ЖК «СберСити»',
      priceRub: 21900000,
      areaM2: 49.0,
      rooms: 1,
      floor: 9,
      district: 'ЗАО',
      planAsset: 'assets/images/plans/gen_plan_1.png',
      zhkAsset: 'assets/images/zhk/zhk_1.jpg',
      finishing: 'whitebox',
      metroMin: 14,
    ),
    ApartmentPreview(
      id: 'apt-8',
      zhkName: 'ЖК «Небо»',
      priceRub: 35500000,
      areaM2: 78.0,
      rooms: 3,
      floor: 33,
      district: 'ЗАО',
      planAsset: 'assets/images/plans/gen_plan_3.png',
      zhkAsset: 'assets/images/zhk/zhk_3.jpg',
      finishing: 'turnkey',
      metroMin: 9,
    ),
  ];

  static ApartmentPreview byId(String id) =>
      catalog.firstWhere((a) => a.id == id, orElse: () => catalog.first);
}

class FeedItem {
  const FeedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageAsset;
  final String kind;

  static const items = <FeedItem>[
    FeedItem(
      id: 'f1',
      title: 'Лучшие предложения недели',
      subtitle: '8 лотов с match ≥ 75% по вашим фильтрам',
      imageAsset: 'assets/images/feed/feed_1.jpg',
      kind: 'best_offer',
    ),
    FeedItem(
      id: 'f2',
      title: 'Подборка: семейные планировки',
      subtitle: '2–3 комнаты у парков и школ',
      imageAsset: 'assets/images/feed/feed_2.jpg',
      kind: 'collection',
    ),
    FeedItem(
      id: 'f3',
      title: 'Разбор ЖК «Речной»',
      subtitle: 'Корпуса, инфраструктура, динамика цены',
      imageAsset: 'assets/images/zhk/zhk_1.jpg',
      kind: 'zhk_deep_dive',
    ),
    FeedItem(
      id: 'f4',
      title: 'Аналитика САО',
      subtitle: 'Спрос, цена м², транспорт',
      imageAsset: 'assets/images/feed/feed_3.jpg',
      kind: 'district',
    ),
    FeedItem(
      id: 'f5',
      title: 'Тренды архитектуры 2026',
      subtitle: 'Стекло, дворы без машин, white box',
      imageAsset: 'assets/images/feed/feed_4.jpg',
      kind: 'design_trend',
    ),
  ];
}
