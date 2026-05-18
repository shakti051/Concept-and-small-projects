
class ProductController {
  List<Map<String, dynamic>> products = [];

  bool isLoading = false;
  int page = 1;
  bool hasMore = true;

  Future<void> fetchProducts() async {
    // Prevent multiple API calls
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      // Simulated API response
      await Future.delayed(Duration(seconds: 2));

      List<Map<String, dynamic>> newApiData = getFakeApi(page);

      // No more data
      if (newApiData.isEmpty) {
        hasMore = false;
        return;
      }

      // Duplicate prevention
      final existingIds =
          products.map((e) => e["id"]).toSet();

      final uniqueNewData = newApiData.where((item) {
        return !existingIds.contains(item["id"]);
      }).toList();

      // Merge old + new
      products.addAll(uniqueNewData);

      // Next page
      page++;

      print(products);

    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  // Fake API
  List<Map<String, dynamic>> getFakeApi(int page) {
    if (page == 1) {
      return [
        {"id": 1, "name": "Laptop"},
        {"id": 2, "name": "Phone"},
      ];
    }

    if (page == 2) {
      return [
        {"id": 2, "name": "Phone"},
        {"id": 3, "name": "Tablet"},
      ];
    }

    return [];
  }
}