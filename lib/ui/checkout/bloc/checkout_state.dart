part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {
  @override
  List<Object> get props => [];
}

class OnError extends CheckoutState {
  final String message;

  const OnError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OnTimeOutError extends CheckoutState {
  @override
  List<Object?> get props => [];
}

class OnLoading extends CheckoutState {
  @override
  List<Object?> get props => [];
}

class OnSuccess extends CheckoutState {
  final Transaction transaction;

  const OnSuccess({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class OnComplete extends CheckoutState {
  final Transaction transaction;

  const OnComplete({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class OnPaymentGateway extends CheckoutState {
  final List<PaymentGateway> gateways;

  const OnPaymentGateway({required this.gateways});

  @override
  List<Object?> get props => [gateways];
}

class OnMandates extends CheckoutState {
  final List<Mandate> mandates;

  const OnMandates({required this.mandates});

  @override
  List<Object?> get props => [mandates];
}
