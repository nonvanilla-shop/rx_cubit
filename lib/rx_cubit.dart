library rx_cubit;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

export 'rx_cubit_testing_extension.dart';

/// An implementation of Cubit using RxDart and Change Notifier.
class RxCubit<T> extends ChangeNotifier {
  final List<StreamSubscription> _subscriptions;
  final BehaviorSubject<T> _subject;

  Stream<T> get stream => _subject.stream;
  T get state => _subject.value;

  RxCubit(T initial)
      : _subject = BehaviorSubject.seeded(initial),
        _subscriptions = [];

  /// Add a subscription that is then automatically closed for you once the Cubit
  /// is being disposed.
  void addSubscription(StreamSubscription subscription) =>
      _subscriptions.add(subscription);

  /// Emits a new State.
  void emit(T state) {
    _subject.add(state);
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await Future.wait(_subscriptions.map((sub) => sub.cancel()));
    await _subject.close();
    super.dispose();
  }
}
