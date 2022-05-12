// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

import '../constants/picker_method.dart';

class MethodListView extends StatefulWidget {
  const MethodListView({
    super.key,
    required this.pickMethods,
    required this.onSelectMethod,
  });

  final List<PickMethod> pickMethods;
  final void Function(PickMethod method) onSelectMethod;

  @override
  State<MethodListView> createState() => _MethodListViewState();
}

class _MethodListViewState extends State<MethodListView> {
  final ScrollController _controller = ScrollController();

  Widget methodItemBuilder(BuildContext context, int index) {
    final PickMethod model = widget.pickMethods[index];
    return InkWell(
      onTap: () => widget.onSelectMethod(model),
      onLongPress: model.onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    model.description,
                    style: Theme.of(context).textTheme.caption,
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(bottom: 10.0),
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        radius: const Radius.circular(999),
        child: ListView.builder(
          controller: _controller,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: widget.pickMethods.length,
          itemBuilder: methodItemBuilder,
        ),
      ),
    );
  }
}
