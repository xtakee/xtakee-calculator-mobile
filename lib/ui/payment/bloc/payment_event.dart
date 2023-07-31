part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class GetPayments extends PaymentEvent {
  final int limit;
  final int page;

  const GetPayments({required this.limit, required this.page});

  @override
  List<Object?> get props => [limit, page];
}
