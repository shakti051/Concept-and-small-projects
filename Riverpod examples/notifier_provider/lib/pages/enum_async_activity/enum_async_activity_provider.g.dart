// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_async_activity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyCounter)
final myCounterProvider = MyCounterProvider._();

final class MyCounterProvider extends $NotifierProvider<MyCounter, int> {
  MyCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myCounterHash();

  @$internal
  @override
  MyCounter create() => MyCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$myCounterHash() => r'08aa79aa72de3999f55247db1de2cabfa13c9357';

abstract class _$MyCounter extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(EnumAsyncActivity)
final enumAsyncActivityProvider = EnumAsyncActivityProvider._();

final class EnumAsyncActivityProvider
    extends $NotifierProvider<EnumAsyncActivity, EnumAsyncActivityState> {
  EnumAsyncActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enumAsyncActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enumAsyncActivityHash();

  @$internal
  @override
  EnumAsyncActivity create() => EnumAsyncActivity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnumAsyncActivityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnumAsyncActivityState>(value),
    );
  }
}

String _$enumAsyncActivityHash() => r'9cb0cc9811f6ae9cdf7fb9c19896446183b35f29';

abstract class _$EnumAsyncActivity extends $Notifier<EnumAsyncActivityState> {
  EnumAsyncActivityState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<EnumAsyncActivityState, EnumAsyncActivityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EnumAsyncActivityState, EnumAsyncActivityState>,
              EnumAsyncActivityState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
