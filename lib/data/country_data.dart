class CountryInfo {
  final String name;
  final String flag;
  final String currencySymbol;
  final String currencyCode;
  final int defaultStep;

  const CountryInfo({
    required this.name,
    required this.flag,
    required this.currencySymbol,
    required this.currencyCode,
    this.defaultStep = 10,
  });
}

const List<CountryInfo> kSupportedCountries = [
  CountryInfo(name: 'Germany', flag: '🇩🇪', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'United Kingdom', flag: '🇬🇧', currencySymbol: '£', currencyCode: 'GBP', defaultStep: 10),
  CountryInfo(name: 'United States', flag: '🇺🇸', currencySymbol: '\$', currencyCode: 'USD', defaultStep: 10),
  CountryInfo(name: 'Canada', flag: '🇨🇦', currencySymbol: 'CA\$', currencyCode: 'CAD', defaultStep: 15),
  CountryInfo(name: 'Italy', flag: '🇮🇹', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'South Korea', flag: '🇰🇷', currencySymbol: '₩', currencyCode: 'KRW', defaultStep: 10000),
  CountryInfo(name: 'Switzerland', flag: '🇨🇭', currencySymbol: 'CHF', currencyCode: 'CHF', defaultStep: 25),
  CountryInfo(name: 'Singapore', flag: '🇸🇬', currencySymbol: 'S\$', currencyCode: 'SGD', defaultStep: 10),
  CountryInfo(name: 'Sweden', flag: '🇸🇪', currencySymbol: 'SEK', currencyCode: 'SEK', defaultStep: 100),
  CountryInfo(name: 'Australia', flag: '🇦🇺', currencySymbol: 'A\$', currencyCode: 'AUD', defaultStep: 20),
  CountryInfo(name: 'France', flag: '🇫🇷', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'Netherlands', flag: '🇳🇱', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 15),
  CountryInfo(name: 'Japan', flag: '🇯🇵', currencySymbol: '¥', currencyCode: 'JPY', defaultStep: 1000),
  CountryInfo(name: 'Turkey (Türkiye)', flag: '🇹🇷', currencySymbol: '₺', currencyCode: 'TRY', defaultStep: 100),
  CountryInfo(name: 'Turkey', flag: '🇹🇷', currencySymbol: '₺', currencyCode: 'TRY', defaultStep: 100),
  CountryInfo(name: 'Türkiye', flag: '🇹🇷', currencySymbol: '₺', currencyCode: 'TRY', defaultStep: 100),
  CountryInfo(name: 'Norway', flag: '🇳🇴', currencySymbol: 'NOK', currencyCode: 'NOK', defaultStep: 100),
  CountryInfo(name: 'Denmark', flag: '🇩🇰', currencySymbol: 'DKK', currencyCode: 'DKK', defaultStep: 100),
  CountryInfo(name: 'Finland', flag: '🇫🇮', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'Ireland', flag: '🇮🇪', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'Austria', flag: '🇦🇹', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'Belgium', flag: '🇧🇪', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'Spain', flag: '🇪🇸', currencySymbol: '€', currencyCode: 'EUR', defaultStep: 10),
  CountryInfo(name: 'New Zealand', flag: '🇳🇿', currencySymbol: 'NZ\$', currencyCode: 'NZD', defaultStep: 20),
  CountryInfo(name: 'Pakistan', flag: '🇵🇰', currencySymbol: 'PKR', currencyCode: 'PKR', defaultStep: 500),
  CountryInfo(name: 'India', flag: '🇮🇳', currencySymbol: '₹', currencyCode: 'INR', defaultStep: 500),
  CountryInfo(name: 'United Arab Emirates', flag: '🇦🇪', currencySymbol: 'AED', currencyCode: 'AED', defaultStep: 50),
  CountryInfo(name: 'Saudi Arabia', flag: '🇸🇦', currencySymbol: 'SAR', currencyCode: 'SAR', defaultStep: 50),
  CountryInfo(name: 'Malaysia', flag: '🇲🇾', currencySymbol: 'RM', currencyCode: 'MYR', defaultStep: 50),
  CountryInfo(name: 'Other / International', flag: '🌐', currencySymbol: '\$', currencyCode: 'USD', defaultStep: 10),
];

CountryInfo? findCountryInfo(String countryName) {
  final clean = countryName.trim().toLowerCase();
  if (clean.contains('turk') || clean.contains('türk')) {
    return const CountryInfo(
      name: 'Turkey (Türkiye)',
      flag: '🇹🇷',
      currencySymbol: '₺',
      currencyCode: 'TRY',
      defaultStep: 100,
    );
  }
  for (final c in kSupportedCountries) {
    if (c.name.toLowerCase() == clean || clean.contains(c.name.toLowerCase()) || c.name.toLowerCase().contains(clean)) {
      return c;
    }
  }
  return null;
}
