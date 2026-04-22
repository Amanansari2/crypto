class CurrencyHelpers {
  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'INR': '₹',
    'JPY': '¥',
    'CNY': '¥',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'KRW': '₩',
    'RUB': '₽',
    'BRL': 'R\$',
  };

  static String currencySymbol(String code) {
    return currencySymbols[code.toUpperCase()] ?? code.toUpperCase();
  }
}
