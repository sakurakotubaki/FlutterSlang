import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slang_example/i18n/strings.g.dart';

// Notifierを使用する場合
class LocaleNotifier extends Notifier<AppLocale> {
  @override
   build() {
    return LocaleSettings.currentLocale;
  }

  void changeLocale(AppLocale newLocale) {
    state = newLocale;
    LocaleSettings.setLocale(newLocale);
  }
}

class CounterNotifier extends Notifier<int> {
  @override
   build() {
    return 0;
  }

  void increment() {
    state++;
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(LocaleNotifier.new);

final counterProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

/// [StateNotifierを使用した場合のコード]
// class LocaleState extends StateNotifier<AppLocale> {
//   LocaleState() : super(LocaleSettings.currentLocale);

//   void changeLocale(AppLocale newLocale) {
//     state = newLocale;
//     LocaleSettings.setLocale(newLocale);
//   }
// }

// class CounterNotifier extends StateNotifier<int> {
//   CounterNotifier() : super(0);

//   void increment() {
//     state++;
//   }
// }

// final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) => CounterNotifier());

// final localeProvider = StateNotifierProvider<LocaleState, AppLocale>((ref) => LocaleState());
