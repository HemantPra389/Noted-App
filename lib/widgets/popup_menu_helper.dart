import 'package:flutter/material.dart';
import 'package:noted/core/app_colors.dart';

typedef PopupMenuCallback = void Function(String value);

class PopupMenuHelper {
  static Widget buildPopupMenu(BuildContext context,
      {required PopupMenuCallback onSelected,
      required List<Map<String, String>> optionsList}) {
    return PopupMenuButton<String>(
      color: Colors.white,
      padding: EdgeInsets.zero,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return List.generate(
          optionsList.length,
          (index) => PopupMenuItem<String>(
            value: optionsList[index].entries.first.key,
            child: Text(optionsList[index].entries.first.value),
          ),
        );
      },
      child: Container(
        height: 36,
        width: 48,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.fingerprint),
      ),
    );
  }
}
