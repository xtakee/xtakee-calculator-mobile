part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetSummary extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ChangePassword extends ProfileEvent {
  final String newPassword;
  final String oldPassword;

  const ChangePassword({required this.newPassword, required this.oldPassword});

  @override
  List<Object?> get props => [newPassword, oldPassword];
}
