// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(autoDisposeAge)
final autoDisposeAgeProvider = AutoDisposeAgeProvider._();

final class AutoDisposeAgeProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AutoDisposeAgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoDisposeAgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoDisposeAgeHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return autoDisposeAge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$autoDisposeAgeHash() => r'09b3d3d3904a36f4ef6e53edd137ecf821da76ed';
