part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
}

class CreateTransaction extends CheckoutEvent {
  final String bundle;

  const CreateTransaction({required this.bundle});

  @override
  List<Object?> get props => [bundle];
}

class CompleteTransaction extends CheckoutEvent {
  final String reference;

  const CompleteTransaction({required this.reference});

  @override
  List<Object?> get props => [reference];
}

class ChargeMandate extends CheckoutEvent {
  final String mandate;
  final String bundle;

  const ChargeMandate({required this.mandate, required this.bundle});

  @override
  List<Object?> get props => [bundle, mandate];
}

class GetMandates extends CheckoutEvent {
  @override
  List<Object?> get props => [];
}
