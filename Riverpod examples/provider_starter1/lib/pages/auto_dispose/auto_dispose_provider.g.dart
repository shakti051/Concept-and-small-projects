// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_dispose_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(autoDisposeHello)
final autoDisposeHelloProvider = AutoDisposeHelloProvider._();

final class AutoDisposeHelloProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AutoDisposeHelloProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoDisposeHelloProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoDisposeHelloHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return autoDisposeHello(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$autoDisposeHelloHash() => r'26b7b68c236ca6a9936fc995a96cb58b948651d5';
