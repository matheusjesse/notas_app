import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomCheckboxBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    String content = text.text.trim(); // remove espaços extras no início/fim

    // Regex para identificar task list
    final checkboxRegex = RegExp(r'^-?\s*\[( |x)\]\s*(.*)');

    final match = checkboxRegex.firstMatch(content);
    if (match != null) {
      final checked = match.group(1) == 'x';
      final label = match.group(2) ?? '';

      return Row(
        children: [
          Icon(
            checked ? Icons.check_box : Icons.check_box_outline_blank,
            size: 20,
            color: checked ? Colors.green : null,
          ),
          const SizedBox(width: 4),
          Expanded(child: Text(label)),
        ],
      );
    }

    return Text(content);
  }
}
