

import 'package:hive_flutter/adapters.dart';
part 'model.g.dart';



// Define the Access class
class Access {
  final String global;
  final String plan;

  Access({
    required this.global,
    required this.plan,
  });

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      global: json['global'] ?? '',
      plan: json['plan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'global': global,
      'plan': plan,
    };
  }
}


@HiveType(typeId: 0)
class StockWithAccess {
  @HiveField(0)
  final String symbol;
  @HiveField(2)
  final String name;
    @HiveField(3)
  final String currency;
    @HiveField(4)
  final String exchange;
    @HiveField(5)
  final String micCode;
    @HiveField(6)
  final String country;
    @HiveField(7)
  final String type;
    @HiveField(8)
  final String figiCode;
    @HiveField(9)
  final Access? access;

  StockWithAccess({
    required this.symbol,
    required this.name,
    required this.currency,
    required this.exchange,
    required this.micCode,
    required this.country,
    required this.type,
    required this.figiCode,
    this.access,
  });

  factory StockWithAccess.fromJson(Map<String, dynamic> json) {
    return StockWithAccess(
      symbol: json['symbol'],
      name: json['name'],
      currency: json['currency'],
      exchange: json['exchange'],
      micCode: json['mic_code'],
      country: json['country'],
      type: json['type'],
      figiCode: json['figi_code'],
      access: json['access'] != null ? Access.fromJson(json['access']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'currency': currency,
      'exchange': exchange,
      'mic_code': micCode,
      'country': country,
      'type': type,
      'figi_code': figiCode,
      'access': access?.toJson(),
    };
  }
}

class StockResponse {
  final List<StockWithAccess> data;
  final String status;

  StockResponse({
    required this.data,
    required this.status,
  });

  factory StockResponse.fromJson(Map<String, dynamic> json) {
    return StockResponse(
      data: List<StockWithAccess>.from(
        json['data']?.map((item) => StockWithAccess.fromJson(item)) ?? [],
      ),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'status': status,
    };
  }
}
   