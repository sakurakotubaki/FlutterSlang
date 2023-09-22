import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slang_example/i18n/strings.g.dart';

class LocaleState extends StateNotifier<AppLocale> {
  LocaleState() : super(LocaleSettings.currentLocale);

  void changeLocale(AppLocale newLocale) {
    state = newLocale;
    LocaleSettings.setLocale(newLocale);
  }
}

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() {
    state++;
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) => CounterNotifier());

final localeProvider = StateNotifierProvider<LocaleState, AppLocale>((ref) => LocaleState());
