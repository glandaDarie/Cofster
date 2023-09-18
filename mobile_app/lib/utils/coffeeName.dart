import 'package:coffee_orderer/utils/localUserInformation.dart'
    show loadUserInformationFromCache, fromStringCachetoMapCache;

Future<String> getCoffeeNameFromCache() async {
  final String cacheStr = await loadUserInformationFromCache();
  final Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
  return cache["cardCoffeeName"];
}
