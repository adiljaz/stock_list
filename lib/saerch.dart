// model.dart

class StockResponse {
  final List<StockWithAccess> data;
  final String status;

  StockResponse({required this.data, required this.status});

  factory StockResponse.fromJson(Map<String, dynamic> json) {
    return StockResponse(
      data: (json['data'] as List)
          .map((item) => StockWithAccess.fromJson(item))
          .toList(),
      status: json['status'] ?? 'ok',
    );
  }
}

class StockWithAccess {
  final String symbol;
  final String name;
  final String currency;
  final String exchange;
  final String micCode;
  final String country;
  final String type;

  StockWithAccess({
    required this.symbol,
    required this.name,
    required this.currency,
    required this.exchange,
    required this.micCode,
    required this.country,
    required this.type,
  });

  factory StockWithAccess.fromJson(Map<String, dynamic> json) {
    return StockWithAccess(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? json['instrument_name'] ?? '',
      currency: json['currency'] ?? '',
      exchange: json['exchange'] ?? '',
      micCode: json['mic_code'] ?? '',
      country: json['country'] ?? '',
      type: json['type'] ?? '',
    );
  } 
}