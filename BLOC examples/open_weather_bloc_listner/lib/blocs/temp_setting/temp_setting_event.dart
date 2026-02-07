
import 'package:equatable/equatable.dart';

sealed class TempSettingsEvent extends Equatable {
  const TempSettingsEvent();

  @override
  List<Object> get props => [];
}

final class ToggleTempUnitEvent extends TempSettingsEvent {}