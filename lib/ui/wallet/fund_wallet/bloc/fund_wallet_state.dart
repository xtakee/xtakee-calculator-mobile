part of 'fund_wallet_bloc.dart';

abstract class FundWalletState extends Equatable {
  const FundWalletState();
}

class FundWalletInitial extends FundWalletState {
  @override
  List<Object> get props => [];
}

class OnLoading extends FundWalletState {
  @override
  List<Object?> get props => [];
}

class OnError extends FundWalletState {
  final String message;

  const OnError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OnDataLoaded extends FundWalletState {
  final List<Bundle> bundles;

  const OnDataLoaded({required this.bundles});

  @override
  List<Object?> get props => [bundles];
}
