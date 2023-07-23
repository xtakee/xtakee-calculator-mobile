part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();
}

class WalletInitial extends WalletState {
  @override
  List<Object> get props => [];
}

class OnLoading extends WalletState {
  @override
  List<Object?> get props => [];
}

class OnError extends WalletState {
  final String message;

  const OnError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OnDataLoaded extends WalletState {
  final Stake stake;

  const OnDataLoaded({required this.stake});

  @override
  List<Object?> get props => [stake];
}
