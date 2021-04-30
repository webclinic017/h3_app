import 'package:equatable/equatable.dart';

abstract class State extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  State(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  State getStateCopy();

  State getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnState extends State {

  UnState(int version) : super(version);

  @override
  String toString() => 'UnState';

  @override
  UnState getStateCopy() {
    return UnState(0);
  }

  @override
  UnState getNewVersion() {
    return UnState(version+1);
  }
}

/// Initialized
class InState extends State {
  final String hello;

  InState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InState $hello';

  @override
  InState getStateCopy() {
    return InState(version, hello);
  }

  @override
  InState getNewVersion() {
    return InState(version+1, hello);
  }
}

class ErrorState extends State {
  final String errorMessage;

  ErrorState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorState';

  @override
  ErrorState getStateCopy() {
    return ErrorState(version, errorMessage);
  }

  @override
  ErrorState getNewVersion() {
    return ErrorState(version+1, 
    errorMessage);
  }
}
