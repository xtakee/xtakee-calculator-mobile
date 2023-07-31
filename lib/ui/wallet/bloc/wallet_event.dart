part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
}

class GetStake extends WalletEvent {
  @override
  List<Object?> get props => [];
}

class GetPayments extends WalletEvent {
  final int limit;
  final int page;

  const GetPayments({required this.limit, required this.page});

  @override
  List<Object?> get props => [limit, page];
}
