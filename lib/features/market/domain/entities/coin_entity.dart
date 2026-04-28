class CoinEntity {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double price;
  final double change24h;
  final String marketCap;
  final String volume;
  final int rank;
  final List<double> sparklines;

  const CoinEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.change24h,
    required this.marketCap,
    required this.volume,
    required this.rank,
    required this.sparklines,
  });
}
