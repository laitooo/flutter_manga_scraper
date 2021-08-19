import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocEvent<B extends BaseBloc, S> {
  const BlocEvent();

  Stream<S> toState(B bloc, S current);
}

abstract class BaseBloc<S> extends Bloc<BlocEvent<BaseBloc, S>, S> {
  BaseBloc(_initialState) : super(_initialState);

  @override
  Stream<S> mapEventToState(BlocEvent<BaseBloc, S> event) {
    return event.toState(this, state);
  }

  @override
  void onEvent(event) {
    print("==================");
    print("Event dispatched for bloc: $this");
    print("\tevent: $event");
    print("\tcurrentState: $state");
    print("==================");
    super.onEvent(event);
  }

  @override
  void onTransition(transition) {
    print("==================");
    print("Successful transition for bloc: $this");
    print("\tevent: ${transition.event}");
    print("\tcurrentState: ${transition.currentState}");
    print("\tnextState: ${transition.nextState}");
    print("==================");
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print("==================");
    print("Error occurred while dispatching event for bloc: $this");
    print("\terror: $error");
    print("\tstacktrace: $stackTrace");
    print("==================");
    super.onError(error, stackTrace);
  }

  @override
  String toString() => runtimeType.toString();
}
