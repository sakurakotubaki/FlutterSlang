import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:slang_example/i18n/strings.g.dart';
import 'package:slang_example/local_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // initialize with the right locale
  /* TranslationProviderでアプリをラップしないと
  "Please wrap your app with "TranslationProvider"." というエラーが出る
  */
  runApp(ProviderScope(child: TranslationProvider(child: const MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);// localeProviderのstateを参照している

    return MaterialApp(
      title: 'Flutter Demo',
      // locale: TranslationProvider.of(context).flutterLocale,// localeProviderのstateを参照している
      // supportedLocales: AppLocaleUtils.supportedLocales,// AppLocaleUtils.supportedLocalesを参照している
      // localizationsDelegates: GlobalMaterialLocalizations.delegates,// GlobalMaterialLocalizations.delegatesを参照している
      locale: currentLocale.flutterLocale,// localeProviderのstateを参照している
      supportedLocales: AppLocaleUtils.supportedLocales,// AppLocaleUtils.supportedLocalesを参照している
      localizationsDelegates: GlobalMaterialLocalizations.delegates,// GlobalMaterialLocalizations.delegatesを参照している
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(t.mainScreen.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // カウンターの表示を多言語対応
            Text(t.mainScreen.counter(n: counter)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // 言語切り替えボタン
              children: AppLocale.values.map((locale) {
                // ボタンが押されたらlocaleProviderのstateを変更する
                final activeLocale = ref.watch(localeProvider);
                // ボタンの状態をlocaleProviderのstateと比較して決める
                final bool active = activeLocale == locale;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: active ? Colors.blue.shade100 : null,
                    ),
                    // ボタンが押されたらlocaleProviderのstateを変更する
                    onPressed: () =>
                        ref.read(localeProvider.notifier).changeLocale(locale),
                    // ボタンのテキストの表示される言語を変更
                    child: Text(t.locales[locale.languageTag]!),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: t.mainScreen.tapMe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
