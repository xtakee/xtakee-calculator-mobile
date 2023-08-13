class Summary {
  num? _wins;
  num? _stakes;
  num? _losses;
  num? _coins;

  Summary({num? stakes, num? losses, num? coins, num? wins}) {
    _wins = wins;
    _losses = losses;
    _coins = coins;
    _stakes = stakes;
  }

  num get losses => _losses ?? 0;

  num get wins => _wins ?? 0;

  num get stakes => _stakes ?? 0;

  num get coins => _coins ?? 0;
}
