part of 'premium_status_bloc.dart';

abstract class PremiumStatusEvent extends Equatable {
  const PremiumStatusEvent();

  @override
  List<Object> get props => [];
}

class CheckPremiumStatus extends PremiumStatusEvent {}

class PurchasePremium extends PremiumStatusEvent {}

class RestorePurchases extends PremiumStatusEvent {}