// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WeChat Asset Picker Demo';

  @override
  String appVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String get appVersionUnknown => 'unknown';

  @override
  String get navMulti => 'Multi';

  @override
  String get navSingle => 'Single';

  @override
  String get navCustom => 'Custom';

  @override
  String get selectedAssetsText => 'Selected Assets';

  @override
  String pickMethodNotice(Object dist) {
    return 'Pickers in this page are located at the $dist, defined by `pickMethods`.';
  }

  @override
  String get pickMethodImageName => 'Image picker';

  @override
  String get pickMethodImageDescription => 'Only pick image from device.';

  @override
  String get pickMethodVideoName => 'Video picker';

  @override
  String get pickMethodVideoDescription =>
      'Only pick video from device. (Includes Live Photos on iOS and macOS.)';

  @override
  String get pickMethodAudioName => 'Audio picker';

  @override
  String get pickMethodAudioDescription => 'Only pick audio from device.';

  @override
  String get pickMethodLivePhotoName => 'Live Photo picker';

  @override
  String get pickMethodLivePhotoDescription =>
      'Only pick Live Photos from device.';

  @override
  String get pickMethodCameraName => 'Pick from camera';

  @override
  String get pickMethodCameraDescription =>
      'Allow to pick an asset through camera.';

  @override
  String get pickMethodCameraAndStayName => 'Pick from camera and stay';

  @override
  String get pickMethodCameraAndStayDescription =>
      'Take a photo or video with the camera picker, select the result and stay in the entities list.';

  @override
  String get pickMethodCommonName => 'Common picker';

  @override
  String get pickMethodCommonDescription => 'Pick images and videos.';

  @override
  String get pickMethodThreeItemsGridName => '3 items grid';

  @override
  String get pickMethodThreeItemsGridDescription =>
      'Picker will served as 3 items on cross axis. (pageSize must be a multiple of the gridCount)';

  @override
  String get pickMethodCustomFilterOptionsName => 'Custom filter options';

  @override
  String get pickMethodCustomFilterOptionsDescription =>
      'Add filter options for the picker.';

  @override
  String get pickMethodPrependItemName => 'Prepend special item';

  @override
  String get pickMethodPrependItemDescription =>
      'A special item will prepend to the assets grid.';

  @override
  String get pickMethodNoPreviewName => 'No preview';

  @override
  String get pickMethodNoPreviewDescription =>
      'You cannot preview assets during the picking, the behavior is like the WhatsApp/MegaTok pattern.';

  @override
  String get pickMethodKeepScrollOffsetName => 'Keep scroll offset';

  @override
  String get pickMethodKeepScrollOffsetDescription =>
      'Pick assets from same scroll position.';

  @override
  String get pickMethodChangeLanguagesName => 'Change Languages';

  @override
  String get pickMethodChangeLanguagesDescription =>
      'Pass AssetPickerTextDelegate to change between languages (e.g. EnglishAssetPickerTextDelegate).';

  @override
  String get pickMethodPreventGIFPickedName => 'Prevent GIF being picked';

  @override
  String get pickMethodPreventGIFPickedDescription =>
      'Use selectPredicate to banned GIF picking when tapped.';

  @override
  String get pickMethodCustomizableThemeName =>
      'Customizable theme (ThemeData)';

  @override
  String get pickMethodCustomizableThemeDescription =>
      'Picking assets with the light theme or with a different color.';

  @override
  String get pickMethodPathNameBuilderName => 'Path name builder';

  @override
  String get pickMethodPathNameBuilderDescription => 'Add 🍭 after paths name.';

  @override
  String get pickMethodWeChatMomentName => 'WeChat Moment';

  @override
  String get pickMethodWeChatMomentDescription =>
      'Pick assets with images or only 1 video.';

  @override
  String get pickMethodCustomImagePreviewThumbSizeName =>
      'Custom image preview thumb size';

  @override
  String get pickMethodCustomImagePreviewThumbSizeDescription =>
      'You can reduce the thumb size to get faster load speed.';

  @override
  String get customPickerNotice =>
      'This page contains customized pickers with different asset types, different UI layouts, or some use case for specific apps. Contribute to add your custom picker are welcomed.\nPickers in this page are located at the lib/customs/pickers folder.';

  @override
  String get customPickerCallThePickerButton => '🎁 Call the Picker';

  @override
  String get customPickerDirectoryAndFileName => 'Directory+File picker';

  @override
  String get customPickerDirectoryAndFileDescription =>
      'This is a custom picker built for `File`.\nBy browsing this picker, we want you to know that you can build your own picker components using the entity\'s type you desired.\n\nIn this page, picker will grab files from `getApplicationDocumentsDirectory`, then check whether it contains images. Put files into the path to see how this custom picker work.';

  @override
  String get customPickerMultiTabName => 'Multi tab picker';

  @override
  String get customPickerMultiTabDescription =>
      'The picker contains multiple tab with different types of assets for the picking at the same time.';

  @override
  String get customPickerMultiTabTab1 => 'All';

  @override
  String get customPickerMultiTabTab2 => 'Videos';

  @override
  String get customPickerMultiTabTab3 => 'Images';

  @override
  String get customPickerInstagramLayoutName => 'Instagram layout picker';

  @override
  String get customPickerInstagramLayoutDescription =>
      'The picker reproduces Instagram layout with preview and scroll animations. It\'s also published as the package insta_assets_picker.';
}
