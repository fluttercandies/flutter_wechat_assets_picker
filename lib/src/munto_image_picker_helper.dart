import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muntorial/muntorial.dart';

import '../munto_assets_picker.dart';
import 'delegates/asset_picker_text_delegate_korean.dart';

class MuntoImagePickerHelper {
  MuntoImagePickerHelper._();

  static Future<List<AssetEntity>?> pickImages(
    BuildContext context, {
    Key? key,
    required int maxAssets,
  }) {
    return AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        pickerTheme: _muntoThemeData,
        maxAssets: maxAssets,
        textDelegate: const KoreanAssetPickerTextDelegate(),
      ),
    );
  }

  static final ThemeData _muntoThemeData = ThemeData(
    brightness: Brightness.dark,
    fontFamily: kDefaultFontFamily,
    primaryColor: Colors.grey[900],
    primaryColorLight: Colors.grey[900],
    primaryColorDark: Colors.grey[900],
    canvasColor: Colors.grey[850],
    scaffoldBackgroundColor: Colors.grey[900],
    bottomAppBarColor: Colors.grey[900],
    cardColor: Colors.grey[900],
    highlightColor: Colors.transparent,
    toggleableActiveColor: MuntorialColors.red,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MuntorialColors.red,
      selectionColor: MuntorialColors.red.withAlpha(100),
      selectionHandleColor: MuntorialColors.red,
    ),
    indicatorColor: MuntorialColors.red,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      elevation: 0,
    ),
    buttonTheme: const ButtonThemeData(buttonColor: MuntorialColors.red),
    colorScheme: ColorScheme(
      primary: Colors.grey[900]!,
      primaryVariant: Colors.grey[900],
      secondary: MuntorialColors.red,
      secondaryVariant: MuntorialColors.red,
      background: Colors.grey[900]!,
      surface: Colors.grey[900]!,
      brightness: Brightness.dark,
      error: const Color(0xffcf6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
    ),
  );
}
