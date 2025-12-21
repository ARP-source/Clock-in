part of 'premium_status_bloc.dart';

abstract class PremiumStatusState extends Equatable {
  const PremiumStatusState();

  @override
  List<Object> get props => [];
}

class PremiumStatusInitial extends PremiumStatusState {
  const PremiumStatusInitial();
}

class PremiumStatusLoading extends PremiumStatusState {
  const PremiumStatusLoading();
}

class PremiumStatusLoaded extends PremiumStatusState {
  final bool isPremium;

  const PremiumStatusLoaded({required this.isPremium});

  @override
  List<Object> get props => [isPremium];
}

class PremiumStatusError extends PremiumStatusState {
  final String message;

  const PremiumStatusError(this.message);

  @override
  List<Object> get props => [message];
}