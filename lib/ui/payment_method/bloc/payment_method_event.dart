part of 'payment_method_bloc.dart';

abstract class PaymentMethodEvent extends Equatable {
  const PaymentMethodEvent();
}

class DeleteMandate extends PaymentMethodEvent {
  final String mandate;

  const DeleteMandate({required this.mandate});

  @override
  List<Object?> get props => [mandate];
}
