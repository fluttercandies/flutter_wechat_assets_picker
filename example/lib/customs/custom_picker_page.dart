// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

import '../constants/custom_pick_method.dart';
import '../constants/extensions.dart';
import 'pickers/directory_file_asset_picker.dart';
import 'pickers/insta_asset_picker.dart';
import 'pickers/multi_tabs_assets_picker.dart';

class CustomPickersPage extends StatefulWidget {
  const CustomPickersPage({super.key});

  @override
  State<CustomPickersPage> createState() => _CustomPickerPageState();
}

class _CustomPickerPageState extends State<CustomPickersPage>
    with AutomaticKeepAliveClientMixin {
  Widget tips(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(context.l10n.customPickerNotice),
    );
  }

  List<CustomPickMethod> pickMethods(BuildContext context) {
    return <CustomPickMethod>[
      CustomPickMethod(
        icon: '🗄',
        name: context.l10n.customPickerDirectoryAndFileName,
        description: context.l10n.customPickerDirectoryAndFileDescription,
        method: (BuildContext context) => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const DirectoryFileAssetPicker(),
          ),
        ),
      ),
      CustomPickMethod(
        icon: '🔀',
        name: context.l10n.customPickerMultiTabName,
        description: context.l10n.customPickerMultiTabDescription,
        method: (BuildContext context) => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => const MultiTabAssetPicker()),
        ),
      ),
      CustomPickMethod(
        icon: '📷',
        name: context.l10n.customPickerInstagramLayoutName,
        description: context.l10n.customPickerInstagramLayoutDescription,
        method: (BuildContext context) => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => const InstaAssetPicker()),
        ),
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        tips(context),
        Expanded(child: _MethodListView(pickMethods: pickMethods(context))),
      ],
    );
  }
}

class _MethodListView extends StatelessWidget {
  const _MethodListView({required this.pickMethods});

  final List<CustomPickMethod> pickMethods;

  Widget methodItemBuilder(BuildContext context, int index) {
    final CustomPickMethod model = pickMethods[index];
    return InkWell(
      onTap: () => model.method(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0,
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(2.0),
              width: 48,
              height: 48,
              child: Center(
                child: Text(
                  model.icon,
                  style: const TextStyle(fontSize: 28.0),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    model.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      itemCount: pickMethods.length,
      itemBuilder: methodItemBuilder,
    );
  }
}
