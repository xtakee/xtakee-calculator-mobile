part of 'home_bloc.dart';

/*
* States -->
* login
* streakWarning
* limitWarning
* error
* loading
* tagAdded
* stake
* ----->
 */

class HomeState {
  bool login;
  bool streakWarning;
  bool limitWarning;
  String? error;
  bool loading;
  bool reset;
  bool tagAdded;
  Stake? stake;
  List<Odd>? tags;

  HomeState(
      {this.loading = false,
      this.login = false,
      this.reset = false,
      this.error,
      this.stake,
      this.tags,
      this.limitWarning = false,
      this.streakWarning = false,
      this.tagAdded = false});

  HomeState copy(
          {bool login = false,
          bool streakWarning = false,
          bool limitWarning = false,
          bool reset = false,
          String? error,
          List<Odd>? tags,
          bool loading = false,
          bool tagAdded = false,
          Stake? stake}) =>
      HomeState(
          error: error,
          streakWarning: streakWarning,
          limitWarning: limitWarning,
          loading: loading,
          login: login,
          reset: reset,
          tagAdded: tagAdded,
          tags: tags ?? this.tags,
          stake: stake ?? this.stake);
}
