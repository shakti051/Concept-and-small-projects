// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(age)
final ageProvider = AgeProvider._();

final class AgeProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  AgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ageHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return age(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$ageHash() => r'1100ba3cd563fdbfeeb73cfe39f48705f2cd7417';
