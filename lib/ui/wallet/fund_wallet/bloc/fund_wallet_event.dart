part of 'fund_wallet_bloc.dart';

abstract class FundWalletEvent extends Equatable {
  const FundWalletEvent();
}

class GetBundles extends FundWalletEvent {
  @override
  List<Object?> get props => [];
}
