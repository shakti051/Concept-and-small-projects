import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
part 'localization_state.dart';

const engLocale = Locale('en', 'US');
const spanishLocale = Locale('es', 'ES');

class LocalizationCubit extends Cubit<Locale> {
  LocalizationCubit() : super(engLocale);
  void selectEnglishLocale()=>emit(engLocale);
  
  void selectSpanishLocale()=>emit(spanishLocale);
  
}
