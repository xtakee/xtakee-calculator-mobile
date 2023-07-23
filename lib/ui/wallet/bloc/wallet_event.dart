part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
}

class GetStake extends WalletEvent {
  @override
  List<Object?> get props => [];
}
