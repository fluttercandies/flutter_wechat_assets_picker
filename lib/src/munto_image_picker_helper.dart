import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muntorial/muntorial.dart';

import '../munto_assets_picker.dart';
import 'delegates/asset_picker_text_delegate_korean.dart' as korean;

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
        requestType: RequestType.image,
        textDelegate: const korean.KoreanAssetPickerTextDelegate(),
        // 사진 접근을 '선택한 사진만'으로 허용해도 고른 사진을 바로 보여준다.
        // 기본값은 limited 일 때 그리드를 '사진을 확인할 수 없어요' 안내로 덮어서, 사진을 골랐는데도 못 고른 것처럼 보였다(MUN-510).
        // 사진을 더 고르거나 설정을 바꾸는 건 하단 접근 제한 바로 할 수 있다.
        limitedPermissionOverlayPredicate: (_) => false,
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
    cardColor: Colors.grey[900],
    highlightColor: Colors.transparent,
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
      primaryContainer: Colors.grey[900],
      secondary: MuntorialColors.red,
      secondaryContainer: MuntorialColors.red,
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
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return MuntorialColors.red;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return MuntorialColors.red;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return MuntorialColors.red;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return MuntorialColors.red;
        }
        return null;
      }),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(color: Colors.grey[900]),
  );
}
