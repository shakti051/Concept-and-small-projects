part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

final class ChangeThemeEvent extends ThemeEvent {
  const ChangeThemeEvent({
    required this.randInt,
  });

  final int randInt;

  @override
  String toString() => 'ChangeThemeEvent(randInt: $randInt)';

  @override
  List<Object> get props => [randInt];
}