import 'package:flutter/material.dart';

class MultiStyledText extends StatelessWidget {
  final String text;
  final Map<String, TextStyle> highlightedWords;
  final TextStyle defaultStyle;
  final TextAlign? textAlign;

  const MultiStyledText({
    super.key,
    required this.text,
    required this.highlightedWords,
    this.defaultStyle = const TextStyle(fontSize: 16, color: Colors.black),
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];

    String remainingText = text;

    while (remainingText.isNotEmpty) {
      // Find the first occurrence of any highlighted word
      int? firstIndex;
      String? firstWord;

      highlightedWords.forEach((word, style) {
        int index = remainingText.indexOf(word);
        if (index != -1 && (firstIndex == null || index < firstIndex!)) {
          firstIndex = index;
          firstWord = word;
        }
      });

      if (firstIndex == null || firstWord == null) {
        // No more highlighted words, add remaining text
        spans.add(TextSpan(text: remainingText, style: defaultStyle));
        break;
      }

      // Add text before the highlighted word
      if (firstIndex! > 0) {
        spans.add(
          TextSpan(
            text: remainingText.substring(0, firstIndex),
            style: defaultStyle,
          ),
        );
      }

      // Add highlighted word
      spans.add(TextSpan(text: firstWord, style: highlightedWords[firstWord]!));

      // Move remainingText forward
      remainingText = remainingText.substring(firstIndex! + firstWord!.length);
    }

    return RichText(
      textAlign: textAlign!,
      text: TextSpan(children: spans),
    );
  }
}
