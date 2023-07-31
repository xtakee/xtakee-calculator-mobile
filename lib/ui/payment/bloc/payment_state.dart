part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
}

class PaymentInitial extends PaymentState {
  @override
  List<Object> get props => [];
}

class OnLoading extends PaymentState {
  @override
  List<Object?> get props => [];
}

class OnDataLoaded extends PaymentState {
  final TransactionHistoryResponse data;

  const OnDataLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class OnError extends PaymentState {
  final String message;

  const OnError({required this.message});

  @override
  List<Object?> get props => [];
}
