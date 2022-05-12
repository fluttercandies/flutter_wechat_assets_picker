// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

import '../constants/custom_pick_method.dart';
import 'pickers/directory_file_asset_picker.dart';
import 'pickers/multi_tabs_assets_picker.dart';

class CustomPickersPage extends StatefulWidget {
  const CustomPickersPage({super.key});

  @override
  State<CustomPickersPage> createState() => _CustomPickerPageState();
}

class _CustomPickerPageState extends State<CustomPickersPage>
    with AutomaticKeepAliveClientMixin {
  Widget get tips {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        'This page contains customized pickers with different asset types, '
        'different UI layouts, or some use case for specific apps. '
        'Contribute to add your custom picker are welcomed.',
      ),
    );
  }

  List<CustomPickMethod> get pickMethods {
    return <CustomPickMethod>[
      CustomPickMethod(
        icon: '🗄',
        name: 'Directory+File picker',
        description: 'The picker is built with `Directory` and `File` '
            'as entities, which allows users to display/select `File` '
            'through `Directory`.',
        method: (BuildContext context) => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const DirectoryFileAssetPicker(),
          ),
        ),
      ),
      CustomPickMethod(
        icon: '🔀',
        name: 'Multi tab picker',
        description: 'The picker contains multiple tab with different types of '
            'assets for the picking at the same time.',
        method: (BuildContext context) => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => const MultiTabAssetPicker()),
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
        tips,
        Expanded(child: _MethodListView(pickMethods: pickMethods)),
      ],
    );
  }
}

class _MethodListView extends StatelessWidget {
  // TODO(Alex): Tracking if it's a false-positive: https://github.com/dart-lang/linter/issues/3386
  // ignore: unused_element
  const _MethodListView({super.key, required this.pickMethods});

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
                    style: Theme.of(context).textTheme.caption,
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
