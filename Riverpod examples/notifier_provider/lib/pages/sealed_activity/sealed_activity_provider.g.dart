// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sealed_activity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SealedActivity)
final sealedActivityProvider = SealedActivityProvider._();

final class SealedActivityProvider
    extends $NotifierProvider<SealedActivity, SealedActivityState> {
  SealedActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sealedActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sealedActivityHash();

  @$internal
  @override
  SealedActivity create() => SealedActivity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SealedActivityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SealedActivityState>(value),
    );
  }
}

String _$sealedActivityHash() => r'421b709a18e7e28c101f67e0a422a70b9cc62afc';

abstract class _$SealedActivity extends $Notifier<SealedActivityState> {
  SealedActivityState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SealedActivityState, SealedActivityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SealedActivityState, SealedActivityState>,
              SealedActivityState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
