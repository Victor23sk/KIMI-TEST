class ApartmentPreview {
  const ApartmentPreview({
    required this.id,
    required this.zhkName,
    required this.priceRub,
    required this.areaM2,
    required this.rooms,
    required this.floor,
    required this.matchPercent,
    this.district = 'Москва',
  });

  final String id;
  final String zhkName;
  final int priceRub;
  final double areaM2;
  final int rooms;
  final int floor;
  final int matchPercent;
  final String district;

  String get priceLabel {
    final m = (priceRub / 1e6);
    return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)} млн ₽';
  }

  static const demos = <ApartmentPreview>[
    ApartmentPreview(
      id: 'apt-1',
      zhkName: 'ЖК «Речной»',
      priceRub: 18500000,
      areaM2: 42.5,
      rooms: 1,
      floor: 12,
      matchPercent: 87,
      district: 'САО',
    ),
    ApartmentPreview(
      id: 'apt-2',
      zhkName: 'ЖК «Северный Порт»',
      priceRub: 24200000,
      areaM2: 58.0,
      rooms: 2,
      floor: 8,
      matchPercent: 74,
      district: 'САО',
    ),
    ApartmentPreview(
      id: 'apt-3',
      zhkName: 'ЖК «Событие»',
      priceRub: 31200000,
      areaM2: 71.2,
      rooms: 2,
      floor: 21,
      matchPercent: 69,
      district: 'ЗАО',
    ),
  ];
}
