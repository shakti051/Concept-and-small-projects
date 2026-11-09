// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_activity_provider.dart';

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

@ProviderFor(EnumActivity)
final enumActivityProvider = EnumActivityProvider._();

final class EnumActivityProvider
    extends $NotifierProvider<EnumActivity, EnumActivityState> {
  EnumActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enumActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enumActivityHash();

  @$internal
  @override
  EnumActivity create() => EnumActivity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnumActivityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnumActivityState>(value),
    );
  }
}

String _$enumActivityHash() => r'57d2c79d2b7d1c9b69534449ba46ea1d9f02b366';

abstract class _$EnumActivity extends $Notifier<EnumActivityState> {
  EnumActivityState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EnumActivityState, EnumActivityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EnumActivityState, EnumActivityState>,
              EnumActivityState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
