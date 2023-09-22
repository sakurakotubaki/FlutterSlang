# Flutterの多言語対応
今回は、slangを使って多言語対応を行います。

## 必要なパッケージを追加
パッケージを配置する箇所は決まってるので注意してください。
```yaml
name: slang_example
description: A new Flutter project.
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: '>=3.1.0 <4.0.0'

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter
  slang: ^3.23.0
  slang_flutter: ^3.23.0
  flutter_riverpod: ^2.4.0 # 後で使うので追加しておく
  # dependenciesの位置に配置する
  flutter_localizations:
    sdk: flutter  # sdk: flutterが必要なので追加

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  # dev_dependenciesに自動生成のためのパッケージを追加
  build_runner: ^2.4.6
  slang_build_runner: ^3.23.0

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^2.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
```

## 多言語対応のためのファイルを作成
libディレクトリに以下にi18nディレクトリを作成し、その中に多言語対応に必要なjsonファイルを作成します。
最初に表示する言語の設定を記載します。公式の参考にして作りましたが、英語と日本語のみ対応しています。ドイツ語には対応してないです。
strings_ja.i18n.jsonを作成して、日本語対応のJSONファイルを作成します。
```json
{
  "mainScreen": {
    "title": "日本語のタイトル",
    "counter": {
      "one": "ボタンを$n回押しました。",
      "other": "ボタンを$n回押しました。"
    },
    "tapMe": "押してね"
  },
  "locales(map)": {
    "en": "英語",
    "de": "ドイツ語",
    "ja": "日本語"
  }
}
```

次に英語に対応したファイルを作成します。
strings.i18n.json
```json
{
  "mainScreen": {
    "title": "Japanese Title",
    "counter": {
      "one": "I pressed the button $n times.",
      "other": "I pressed the button $n times."
    },
    "tapMe": "Push it"
  },
  "locales(map)": {
    "en": "English",
    "de": "Deutsch",
    "ja": "Japanese"
  }
}
```

ファイルを自動生成するコマンドを実行します。
```bash
flutter pub run build_runner build
```

main.dartのカウンターアプリのコードを多言語対応したコードに書き換えます。
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:slang_example/i18n/strings.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // initialize with the right locale
  runApp(TranslationProvider(
    // wrap with TranslationProvider
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      // error GlobalMaterialLocalizations
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    LocaleSettings.getLocaleStream().listen((event) {
      print('locale changed: $event');
    });
  }

  @override
  Widget build(BuildContext context) {
    // get t variable, will trigger rebuild on locale change
    // otherwise just call t directly (if locale is not changeable)
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        // error mainScreen
        title: Text(t.mainScreen.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // error mainScreen
            Text(t.mainScreen.counter(n: _counter)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              // lets loop over all supported locales
              children: AppLocale.values.map((locale) {
                // active locale
                AppLocale activeLocale = LocaleSettings.currentLocale;

                // typed version is preferred to avoid typos
                bool active = activeLocale == locale;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: active ? Colors.blue.shade100 : null,
                    ),
                    onPressed: () {
                      // locale change, will trigger a rebuild (no setState needed)
                      LocaleSettings.setLocale(locale);
                    },
                    // error mainScreen
                    child: Text(t.locales[locale.languageTag]!),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _counter++);
        },
        // error mainScreen
        tooltip: context.t.mainScreen.tapMe, // using extension method
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Riverpodで状態を管理する
多言語対応した状態をRiverpodで管理します。

多言語対応の状態を管理するnotifierを作成します。
```dart
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
```

エラーが出てハマった箇所があるのですが、main関数のMyAppをTranslationProviderでラップしないとエラーが出でしまうようです!

error code
```
 "Please wrap your app with "TranslationProvider"."
```

以下のように修正する。
```dart
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
        backgroundColor: Colors.green,
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
```