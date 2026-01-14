part of 'counter_cubit.dart';

final class CounterState extends Equatable {
  const CounterState({
    required this.counter,
  });

  final int counter;

  @override
  List<Object> get props => [counter];

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