import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetsGallery extends StatelessWidget {
  const AssetsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final DefaultAssetPickerProvider provider =
        DefaultAssetPickerProvider(requestType: RequestType.all);
    final Future<PermissionState> ps = AssetPicker.permissionCheck(
      requestOption: PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: provider.requestType,
          mediaLocation: false,
        ),
      ),
    );

    return FutureBuilder(
      future: ps,
      builder: (context, snapshot) => snapshot.hasData
          ? DefaultAssetPickerBuilderDelegate(
                  provider: provider,
                  initialPermission: snapshot.data!,
                  specialPickerType: SpecialPickerType.noSelection,
                  locale: Localizations.maybeLocaleOf(context))
              .build(context)
          : const CircularProgressIndicator(),
    );
  }
}
