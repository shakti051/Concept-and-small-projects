// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_second_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(City)
final cityProvider = CityProvider._();

final class CityProvider extends $NotifierProvider<City, Cities> {
  CityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cityHash();

  @$internal
  @override
  City create() => City();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Cities value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Cities>(value),
    );
  }
}

String _$cityHash() => r'52eb79862338a7e39c29ce67deb860df0092250c';

abstract class _$City extends $Notifier<Cities> {
  Cities build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Cities, Cities>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Cities, Cities>,
              Cities,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(weatherSecond)
final weatherSecondProvider = WeatherSecondProvider._();

final class WeatherSecondProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  WeatherSecondProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherSecondProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherSecondHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return weatherSecond(ref);
  }
}

String _$weatherSecondHash() => r'e1b3624197d24b7f6c1af62172ff3df96c656838';
