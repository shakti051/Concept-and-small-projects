part of 'counter_cubit.dart';

final class CounterState extends Equatable {
  final int counter;

  factory CounterState.initial() {
    return const CounterState(counter: 0);
  }

  const CounterState({required this.counter});

  @override
  // TODO: implement props
  List<Object?> get props => [counter];

  @override
  String toString() => 'CounterState(counter: $counter)';

  CounterState copyWith({
    int? counter,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
    );
  }
}
