part of 'payment_method_bloc.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();
}

class PaymentMethodInitial extends PaymentMethodState {
  @override
  List<Object> get props => [];
}

class OnLoading extends PaymentMethodState {
  @override
  List<Object?> get props => [];
}

class OnError extends PaymentMethodState {
  final String message;

  const OnError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OnDeleted extends PaymentMethodState {
  final String mandate;

  const OnDeleted({required this.mandate});

  @override
  List<Object?> get props => [];
}
