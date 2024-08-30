import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stock_list/api.dart';
import 'package:stock_list/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  final searchResults = <Stock>[].obs;
  final savedStocks = <Stock>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedStocks();
  }

  void searchSymbols(String query) async {
    if (query.isEmpty) return; 

    isLoading.value = true;
   
    final url = 'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$query&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> matches = data['bestMatches'];
        searchResults.value = matches.map((match) => Stock.fromJson(match)).toList();
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
}