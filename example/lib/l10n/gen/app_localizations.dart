import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'WeChat Asset Picker Demo'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String appVersion(Object version);

  /// No description provided for @appVersionUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get appVersionUnknown;

  /// No description provided for @navMulti.
  ///
  /// In en, this message translates to:
  /// **'Multi'**
  String get navMulti;

  /// No description provided for @navSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get navSingle;

  /// No description provided for @navCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get navCustom;

  /// No description provided for @selectedAssetsText.
  ///
  /// In en, this message translates to:
  /// **'Selected Assets'**
  String get selectedAssetsText;

  /// No description provided for @pickMethodNotice.
  ///
  /// In en, this message translates to:
  /// **'Pickers in this page are located at the {dist}, defined by `pickMethods`.'**
  String pickMethodNotice(Object dist);

  /// No description provided for @pickMethodImageName.
  ///
  /// In en, this message translates to:
  /// **'Image picker'**
  String get pickMethodImageName;

  /// No description provided for @pickMethodImageDescription.
  ///
  /// In en, this message translates to:
  /// **'Only pick image from device.'**
  String get pickMethodImageDescription;

  /// No description provided for @pickMethodVideoName.
  ///
  /// In en, this message translates to:
  /// **'Video picker'**
  String get pickMethodVideoName;

  /// No description provided for @pickMethodVideoDescription.
  ///
  /// In en, this message translates to:
  /// **'Only pick video from device. (Includes Live Photos on iOS and macOS.)'**
  String get pickMethodVideoDescription;

  /// No description provided for @pickMethodAudioName.
  ///
  /// In en, this message translates to:
  /// **'Audio picker'**
  String get pickMethodAudioName;

  /// No description provided for @pickMethodAudioDescription.
  ///
  /// In en, this message translates to:
  /// **'Only pick audio from device.'**
  String get pickMethodAudioDescription;

  /// No description provided for @pickMethodCameraName.
  ///
  /// In en, this message translates to:
  /// **'Pick from camera'**
  String get pickMethodCameraName;

  /// No description provided for @pickMethodCameraDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow to pick an asset through camera.'**
  String get pickMethodCameraDescription;

  /// No description provided for @pickMethodCameraAndStayName.
  ///
  /// In en, this message translates to:
  /// **'Pick from camera and stay'**
  String get pickMethodCameraAndStayName;

  /// No description provided for @pickMethodCameraAndStayDescription.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or video with the camera picker, select the result and stay in the entities list.'**
  String get pickMethodCameraAndStayDescription;

  /// No description provided for @pickMethodCommonName.
  ///
  /// In en, this message translates to:
  /// **'Common picker'**
  String get pickMethodCommonName;

  /// No description provided for @pickMethodCommonDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick images and videos.'**
  String get pickMethodCommonDescription;

  /// No description provided for @pickMethodThreeItemsGridName.
  ///
  /// In en, this message translates to:
  /// **'3 items grid'**
  String get pickMethodThreeItemsGridName;

  /// No description provided for @pickMethodThreeItemsGridDescription.
  ///
  /// In en, this message translates to:
  /// **'Picker will served as 3 items on cross axis. (pageSize must be a multiple of the gridCount)'**
  String get pickMethodThreeItemsGridDescription;

  /// No description provided for @pickMethodCustomFilterOptionsName.
  ///
  /// In en, this message translates to:
  /// **'Custom filter options'**
  String get pickMethodCustomFilterOptionsName;

  /// No description provided for @pickMethodCustomFilterOptionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add filter options for the picker.'**
  String get pickMethodCustomFilterOptionsDescription;

  /// No description provided for @pickMethodPrependItemName.
  ///
  /// In en, this message translates to:
  /// **'Prepend special item'**
  String get pickMethodPrependItemName;

  /// No description provided for @pickMethodPrependItemDescription.
  ///
  /// In en, this message translates to:
  /// **'A special item will prepend to the assets grid.'**
  String get pickMethodPrependItemDescription;

  /// No description provided for @pickMethodNoPreviewName.
  ///
  /// In en, this message translates to:
  /// **'No preview'**
  String get pickMethodNoPreviewName;

  /// No description provided for @pickMethodNoPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'You cannot preview assets during the picking, the behavior is like the WhatsApp/MegaTok pattern.'**
  String get pickMethodNoPreviewDescription;

  /// No description provided for @pickMethodKeepScrollOffsetName.
  ///
  /// In en, this message translates to:
  /// **'Keep scroll offset'**
  String get pickMethodKeepScrollOffsetName;

  /// No description provided for @pickMethodKeepScrollOffsetDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick assets from same scroll position.'**
  String get pickMethodKeepScrollOffsetDescription;

  /// No description provided for @pickMethodChangeLanguagesName.
  ///
  /// In en, this message translates to:
  /// **'Change Languages'**
  String get pickMethodChangeLanguagesName;

  /// No description provided for @pickMethodChangeLanguagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Pass AssetPickerTextDelegate to change between languages (e.g. EnglishAssetPickerTextDelegate).'**
  String get pickMethodChangeLanguagesDescription;

  /// No description provided for @pickMethodPreventGIFPickedName.
  ///
  /// In en, this message translates to:
  /// **'Prevent GIF being picked'**
  String get pickMethodPreventGIFPickedName;

  /// No description provided for @pickMethodPreventGIFPickedDescription.
  ///
  /// In en, this message translates to:
  /// **'Use selectPredicate to banned GIF picking when tapped.'**
  String get pickMethodPreventGIFPickedDescription;

  /// No description provided for @pickMethodCustomizableThemeName.
  ///
  /// In en, this message translates to:
  /// **'Customizable theme (ThemeData)'**
  String get pickMethodCustomizableThemeName;

  /// No description provided for @pickMethodCustomizableThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Picking assets with the light theme or with a different color.'**
  String get pickMethodCustomizableThemeDescription;

  /// No description provided for @pickMethodPathNameBuilderName.
  ///
  /// In en, this message translates to:
  /// **'Path name builder'**
  String get pickMethodPathNameBuilderName;

  /// No description provided for @pickMethodPathNameBuilderDescription.
  ///
  /// In en, this message translates to:
  /// **'Add 🍭 after paths name.'**
  String get pickMethodPathNameBuilderDescription;

  /// No description provided for @pickMethodWeChatMomentName.
  ///
  /// In en, this message translates to:
  /// **'WeChat Moment'**
  String get pickMethodWeChatMomentName;

  /// No description provided for @pickMethodWeChatMomentDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick assets with images or only 1 video.'**
  String get pickMethodWeChatMomentDescription;

  /// No description provided for @pickMethodCustomImagePreviewThumbSizeName.
  ///
  /// In en, this message translates to:
  /// **'Custom image preview thumb size'**
  String get pickMethodCustomImagePreviewThumbSizeName;

  /// No description provided for @pickMethodCustomImagePreviewThumbSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'You can reduce the thumb size to get faster load speed.'**
  String get pickMethodCustomImagePreviewThumbSizeDescription;

  /// No description provided for @customPickerNotice.
  ///
  /// In en, this message translates to:
  /// **'This page contains customized pickers with different asset types, different UI layouts, or some use case for specific apps. Contribute to add your custom picker are welcomed.\nPickers in this page are located at the lib/customs/pickers folder.'**
  String get customPickerNotice;

  /// No description provided for @customPickerCallThePickerButton.
  ///
  /// In en, this message translates to:
  /// **'🎁 Call the Picker'**
  String get customPickerCallThePickerButton;

  /// No description provided for @customPickerDirectoryAndFileName.
  ///
  /// In en, this message translates to:
  /// **'Directory+File picker'**
  String get customPickerDirectoryAndFileName;

  /// No description provided for @customPickerDirectoryAndFileDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a custom picker built for `File`.\nBy browsing this picker, we want you to know that you can build your own picker components using the entity\'s type you desired.\n\nIn this page, picker will grab files from `getApplicationDocumentsDirectory`, then check whether it contains images. Put files into the path to see how this custom picker work.'**
  String get customPickerDirectoryAndFileDescription;

  /// No description provided for @customPickerMultiTabName.
  ///
  /// In en, this message translates to:
  /// **'Multi tab picker'**
  String get customPickerMultiTabName;

  /// No description provided for @customPickerMultiTabDescription.
  ///
  /// In en, this message translates to:
  /// **'The picker contains multiple tab with different types of assets for the picking at the same time.'**
  String get customPickerMultiTabDescription;

  /// No description provided for @customPickerMultiTabTab1.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get customPickerMultiTabTab1;

  /// No description provided for @customPickerMultiTabTab2.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get customPickerMultiTabTab2;

  /// No description provided for @customPickerMultiTabTab3.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get customPickerMultiTabTab3;

  /// No description provided for @customPickerInstagramLayoutName.
  ///
  /// In en, this message translates to:
  /// **'Instagram layout picker'**
  String get customPickerInstagramLayoutName;

  /// No description provided for @customPickerInstagramLayoutDescription.
  ///
  /// In en, this message translates to:
  /// **'The picker reproduces Instagram layout with preview and scroll animations. It\'s also published as the package insta_assets_picker.'**
  String get customPickerInstagramLayoutDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
