import 'package:rx_cubit/rx_cubit.dart';

/// This class functions as an aggregation for all functions related to testing
/// RxCubits.
class RxCubitTester {
  /// This function collections all state emitted by the cubit and returns them.
  /// [build] is a closure returning the cubit
  /// [act] is a callback which receives the cubit as an argument and performs
  /// actions on the cubit.
  static Future<List<T>> getRxCubitStates<C extends RxCubit<T>, T>({
    required C Function() build,
    Future<void> Function(C cubit)? act,
  }) async {
    final states = <T>[];
    final cubit = build();
    final subscription = cubit.stream.listen(states.add);
    await act?.call(cubit);

    await Future.delayed(Duration.zero);
    await subscription.cancel();
    await cubit.dispose();

    return states;
  }
}
