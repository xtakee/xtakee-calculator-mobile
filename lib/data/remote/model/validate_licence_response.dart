import 'package:stake_calculator/domain/model/stake.dart';

class ValidateLicenceResponse {
  ValidateLicenceResponse({
    String? authorization,
    Stake? stake,
  }) {
    _stake = stake;
    _authorization = authorization;
  }

  Stake? _stake;
  String? _authorization;

  Stake? get stake => _stake;

  String? get authorization => _authorization;
}
