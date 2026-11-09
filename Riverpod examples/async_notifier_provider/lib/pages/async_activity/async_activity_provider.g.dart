// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_activity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AsyncActivity)
final asyncActivityProvider = AsyncActivityProvider._();

final class AsyncActivityProvider
    extends $AsyncNotifierProvider<AsyncActivity, Activity> {
  AsyncActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'asyncActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$asyncActivityHash();

  @$internal
  @override
  AsyncActivity create() => AsyncActivity();
}

String _$asyncActivityHash() => r'2785baf63226b8d9808d66aaf2f95eb86947f288';

abstract class _$AsyncActivity extends $AsyncNotifier<Activity> {
  FutureOr<Activity> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Activity>, Activity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Activity>, Activity>,
              AsyncValue<Activity>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
