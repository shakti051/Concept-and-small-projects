// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Counter)
final counterProvider = CounterFamily._();

final class CounterProvider extends $AsyncNotifierProvider<Counter, int> {
  CounterProvider._({
    required CounterFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'counterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  @override
  String toString() {
    return r'counterProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Counter create() => Counter();

  @override
  bool operator ==(Object other) {
    return other is CounterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$counterHash() => r'46ebeeb4f2909f22fe65e21c6e0e8819987f5cf8';

final class CounterFamily extends $Family
    with
        $ClassFamilyOverride<
          Counter,
          AsyncValue<int>,
          int,
          FutureOr<int>,
          int
        > {
  CounterFamily._()
    : super(
        retry: null,
        name: r'counterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CounterProvider call(int initialValue) =>
      CounterProvider._(argument: initialValue, from: this);

  @override
  String toString() => r'counterProvider';
}

abstract class _$Counter extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as int;
  int get initialValue => _$args;

  FutureOr<int> build(int initialValue);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
