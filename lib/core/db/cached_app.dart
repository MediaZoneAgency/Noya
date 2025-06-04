

import 'cash_helper.dart';

enum CachedDataType { categories, profile ,productHome,wishlist,categoryProduct}

class CachedKeys {
  static Map<String, int> expirationCacheTime = {
    CachedDataType.categories.name: 600000,
    CachedDataType.profile.name: 600000,
    CachedDataType.productHome.name: 600000,
    CachedDataType.wishlist.name:60000,
    CachedDataType.categoryProduct.name:60000
  };
}

class CachedApp {
  static Map<String, CachedItem> cachedData = {};
  static void saveData(dynamic data, String key) {
    cachedData[key] = CachedItem(data);
  }

   static void clearCache() {
    cachedData.clear();
  }

  void removeFromCache(String key) {
    cachedData.remove(key);
  }

  static dynamic getCachedData(String key) {
    CachedItem? cachedItem = cachedData[key];
    int time = CachedKeys.expirationCacheTime.containsKey(key) &&
            CachedKeys.expirationCacheTime[key] != null
        ? CachedKeys.expirationCacheTime[key]!
        
        : 600000;
    if (cachedItem != null &&
        cachedItem.isValid(time)) {
      return cachedItem.data;
    } else {
      throw "Data not found in cache";
    }
  }

}

class CachedItem {
  dynamic data;
  int cachedTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int timeInMillisecond) =>
      DateTime.now().millisecondsSinceEpoch - cachedTime < timeInMillisecond;
}
