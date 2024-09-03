import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stock_list/repository/api.dart';
import 'package:stock_list/model/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  final searchResults = <Stock>[].obs;
  final savedStocks = <Stock>[].obs;
  final allStocks = <Stock>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedStocks();
    fetchAllStocks();
  }

  void searchSymbols(String query) async {
    if (query.isEmpty) {
      cancelSearch();
      return;
    }

    isLoading.value = true;
    isSearching.value = true;

    final url = 'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$query&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> matches = data['bestMatches'];
        searchResults.value = await Future.wait(matches.map((match) async {
          Stock stock = Stock.fromJson(match);
          await fetchStockPrice(stock);
          return stock;
        }));
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error searching symbols: $e');
      Get.snackbar('Error', 'Failed to search for stocks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStockPrice(Stock stock) async {
    final url = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${stock.symbol}&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final quote = data['Global Quote'];
        if (quote != null && quote['05. price'] != null) {
          stock.price = quote['05. price'];
        }
      }
    } catch (e) {
      print('Error fetching stock price: $e');
    }
  }

  void cancelSearch() {
    isSearching.value = false;
    searchResults.clear();
  }

  void addToSavedStocks(Stock stock) async {
    if (!savedStocks.contains(stock)) {
      savedStocks.add(stock);
      await saveStocksToHive();
      Get.snackbar('Success', '${stock.name} added to watchlist');
    } else {
      Get.snackbar('Info', '${stock.name} is already in your watchlist');
    }
  }

  void removeStock(int index) async {
    savedStocks.removeAt(index);
    await saveStocksToHive();
    Get.snackbar('Success', 'Stock removed from watchlist');
  }

  Future<void> loadSavedStocks() async {
    final box = await Hive.openBox<Stock>('stocks');
    savedStocks.value = box.values.toList();
  }

  Future<void> saveStocksToHive() async {
    final box = await Hive.openBox<Stock>('stocks');

    await box.clear();
    await box.addAll(savedStocks);
  }

  Future<void> fetchAllStocks() async {
    isLoading.value = true;

    final url = 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timeSeries = data['Time Series (Daily)'] as Map<String, dynamic>;
        
        allStocks.clear();
        timeSeries.forEach((date, values) {
          allStocks.add(Stock(
            symbol: 'IBM',
            name: 'International Business Machines',
            price: values['4. close'],
          ));
        });
      } else {
        throw Exception('Failed to load stocks');
      }
    } catch (e) {
      print('Error fetching stocks: $e');
      Get.snackbar('Error', 'Failed to fetch stocks');
    } finally {
      isLoading.value = false;
    }
  }
} 