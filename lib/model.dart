import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class Stock extends HiveObject {
  @HiveField(0)
  final String symbol;

  @HiveField(1)
  final String name;

  @HiveField(2)
  String price;

  Stock({required this.symbol, required this.name, required this.price});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['1. symbol'] ?? '',
      name: json['2. name'] ?? '',
      price: json['5. price'] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '1. symbol': symbol,
      '2. name': name,
      '5. price': price,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stock &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol;

  @override
  int get hashCode => symbol.hashCode;
}  