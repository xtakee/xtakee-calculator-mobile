part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  Account? account;
  Stake? stake;
  bool accountLoading;
  bool stakeLoading;
  String? stakeError;
  String? accountError;
  String? newPassError;
  String? oldPassError;
  String? error;
  bool loading;
  bool success;

  ProfileState(
      {this.account,
      this.stake,
      this.loading = false,
      this.success = false,
      this.newPassError,
      this.oldPassError,
      this.error,
      this.accountError,
      this.stakeError,
      this.accountLoading = false,
      this.stakeLoading = false});

  ProfileState copy(
          {Stake? stake,
          String? error,
          bool? loading = false,
          bool? success = false,
          String? stakeError,
          String? accountError,
          String? newPassError,
          String? oldPassError,
          Account? account,
          bool? accountLoading = false,
          bool? stakeLoading = false}) =>
      ProfileState(
          account: account ?? this.account,
          stakeError: stakeError ?? this.stakeError,
          accountError: accountError ?? this.accountError,
          newPassError: newPassError ?? this.newPassError,
          oldPassError: oldPassError ?? this.oldPassError,
          stake: stake ?? this.stake,
          success: success ?? this.success,
          loading: loading ?? this.loading,
          accountLoading: accountLoading ?? this.accountLoading,
          stakeLoading: stakeLoading ?? this.stakeLoading,
          error: error);

  @override
  List<Object?> get props => [
        accountLoading,
        account,
        stake,
        stakeLoading,
        error,
        success,
        oldPassError,
        newPassError,
        stakeError,
        loading,
        accountError
      ];
}
