import 'dart:async';
import 'package:broker/core/sharedWidgets/top_rated_item.dart';
import 'package:broker/core/sharedWidgets/unit_widget.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:broker/feature/map/ui/map_screen.dart';
import 'package:flutter/material.dart';
// تأكد من مسار الويدجت

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    Key? key,
    required this.msg,
    required this.chatIndex,
    this.onFeedback,
    required this.isCurrentlyReceiving,
  }) : super(key: key);

  final String msg;
  final int chatIndex;
  final Function(String feedbackType, String? comment)? onFeedback;
  final bool isCurrentlyReceiving;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  String _displayedText = "";
  String _fullTargetText = "";
  Timer? _typingTimer;
  String? _standaloneLocationLink;
  int _currentCharIndex = 0;
  final Duration _typingSpeed = const Duration(milliseconds: 30);
  List<UnitExtractionResult> _extractedUnits = [];

  @override
  void initState() {
    super.initState();
    _fullTargetText = widget.msg;
    _checkForUnits();
    if (widget.chatIndex == 1 && widget.isCurrentlyReceiving) {
      _startTypingAnimation();
    } else {
      _displayedText = _fullTargetText;
    }
  }

  void _checkForUnits() {
    if (widget.chatIndex == 1) {
      final parsed = extractUnitsWithIntro(widget.msg);
      _extractedUnits = [parsed]; // ✅ لف الكائن في ليست
    }
  }

  UnitExtractionResult extractUnitsWithIntro(String text) {
    final List<UnitModel> units = [];
    String? intro;

    final hasDelimitedUnits = text.contains('[[[UNIT_START]]]');

    final unitBlocks = hasDelimitedUnits
        ? RegExp(r'\[\[\[UNIT_START\]\]\](.*?)\[\[\[UNIT_END\]\]\]',
                dotAll: true)
            .allMatches(text)
            .map((e) => e.group(1)!)
            .toList()
        : [text]; // 🆕 لو مفيش delimiters، اعتبر النص كله وحدة

    // المقدمة في حالة عدم وجود [[[UNIT_START]]]
    if (!hasDelimitedUnits) {
      final match =
          RegExp(r'^(.+?)\n[-•]\s+\*\*', dotAll: true).firstMatch(text);
      intro = match?.group(1)?.trim();
    } else {
      final introMatch = RegExp(r'^(.*?)\[\[\[UNIT_START\]\]\]', dotAll: true)
          .firstMatch(text);
      intro = introMatch?.group(1)?.trim();
    }

    if (intro?.isEmpty ?? true) intro = null;

    for (final block in unitBlocks) {
      print('🔍 block:\n$block');

      final title = RegExp(r'في\s+[\"“”]?(.+?)(?=[\"”])')
          .firstMatch(block)
          ?.group(1)
          ?.trim();

      final location = RegExp(
              r'(?:(?:الموقع|Location)[:：]?\**\**)?(?:\s*[:-])?\s*(الشيخ زايد|القاهرة الجديدة|[^\n،.]+)')
          .firstMatch(block)
          ?.group(1)
          ?.trim();

      final sizeText = RegExp(
              r'(?:(?:المساحة|Size|المساحة الواسعة)[:：]?\**\**)?(?:\s*[:-])?\s*([\d,\.]+)\s*(?:متر)?')
          .firstMatch(block)
          ?.group(1)
          ?.replaceAll(',', '')
          ?.trim();
      final locationLink = RegExp(r'\[رابط الموقع\]\((https?:\/\/[^\s)]+)\)')
          .firstMatch(block)
          ?.group(1);

// final priceText = RegExp(
//   r'(?:\*\*?)?\s*(?:💰)?\s*(?:السعر|Price)\s*(?:[:：])?\s*\*{0,2}?\s*([\d,.]+)',
//   caseSensitive: false,
// ).firstMatch(block)?.group(1)?.replaceAll(',', '')?.trim();

      final priceText =
          RegExp(r'(?:السعر|Price)[\s:：\-\*]*([\d,\.]+)', caseSensitive: false)
              .firstMatch(block)
              ?.group(1)
              ?.replaceAll(',', '')
              ?.trim();

      print("🎯 Extracted price text: $priceText");

      final price = priceText != null ? '$priceText جنيه' : null;
      print("📦 Final Unit price: $price");
      final rooms = int.tryParse(
        RegExp(r'(?:عدد الغرف|غرف النوم|Bedrooms)[:：]?\**\**?\s*[:-]?\s*(\d+)')
                .firstMatch(block)
                ?.group(1) ??
            '',
      );

      final baths = int.tryParse(
        RegExp(r'(?:عدد الحمامات|الحمامات|Bathrooms)[:：]?\**\**?\s*[:-]?\s*(\d+)')
                .firstMatch(block)
                ?.group(1) ??
            '',
      );
final locationLink2 = RegExp(r'\[(?:رابط الموقع|شوف الموقع)\]\((https?:\/\/[^\s)]+)\)')
    .firstMatch(block)
    ?.group(1);

      final description = RegExp(
        r'(?:الوصف|التفاصيل|تقسيط|نظام الدفع|خطة الدفع|المميزات|Description|Features)[:：]?\**\**?\s*[:-]?\s*(.+)',
        caseSensitive: false,
      ).firstMatch(block)?.group(1)?.trim();

      final imageUrl = RegExp(r'!\[.*?\]\((https?:\/\/[^\s)]+)\)')
          .firstMatch(block)
          ?.group(1);

      int? totalSize = sizeText != null ? int.tryParse(sizeText) : null;
      print(totalSize);

      if (imageUrl == null) continue;

      units.add(UnitModel(
        type: location ?? "غير محدد",
        location: locationLink2 ,
        price: (price != null && price.isNotEmpty) ? '$price ' : "غير متوفر",
        size: totalSize,
        rooms: rooms,
        bathrooms: baths,
        description: description,
        images: [imageUrl],
      ));
    }

    return UnitExtractionResult(
      introText: intro,
      units: units,
    );
  }

//   UnitExtractionResult extractUnitsWithIntro(String text) {
//     final List<UnitModel> units = [];
//     String? intro;
// print("🔍 block:\n$text");

//     final hasDelimitedUnits = text.contains('[[[UNIT_START]]]');

//     final unitBlocks = hasDelimitedUnits
//         ? RegExp(r'\[\[\[UNIT_START\]\]\](.*?)\[\[\[UNIT_END\]\]\]',
//                 dotAll: true)
//             .allMatches(text)
//             .map((e) => e.group(1)!)
//             .toList()
//         : [];

//     intro = RegExp(r'^(.*?)\[\[\[UNIT_START\]\]\]', dotAll: true)
//         .firstMatch(text)
//         ?.group(1)
//         ?.trim();
//     if (intro?.isEmpty ?? true) intro = null;

//     for (final block in unitBlocks) {
//       final title = RegExp(r'###\s*(.*)').firstMatch(block)?.group(1)?.trim();
// final priceMatch = RegExp(r'\*\*السعر:\*\*\s*([\d,\.]+)').firstMatch(block);
// final price = priceMatch?.group(1)?.replaceAll(',', '').trim();

// print("💰 Extracted price: $price");

//       final location =
//           RegExp(r'الموقع[:：]?\s*(.*)').firstMatch(block)?.group(1)?.trim();

//       final sizeText =
//           RegExp(r'المساحة[:：]?\s*([^\n]*)').firstMatch(block)?.group(1);
//       final parts = RegExp(r'([\d.]+)');
//       int? totalSize;
//       if (sizeText != null) {
//         final parts = RegExp(r'([\d.]+)')
//             .allMatches(sizeText)
//             .map((m) => double.tryParse(m.group(1)!))
//             .whereType<double>()
//             .toList();

//         if (parts.isNotEmpty) {
//           totalSize = parts.fold(0.0, (sum, part) => sum + part).toInt();
//         }
//       }

//       final rooms = int.tryParse(
//           RegExp(r'الغرف[:：]?\s*(\d+)').firstMatch(block)?.group(1) ?? '');
//       final baths = int.tryParse(
//           RegExp(r'الحمامات[:：]?\s*(\d+)').firstMatch(block)?.group(1) ?? '');

//       final description = RegExp(r'التفاصيل[:：]?\s*(.+)', dotAll: true)
//           .firstMatch(block)
//           ?.group(1)
//           ?.trim();

//       final imageUrl = RegExp(r'!\[.*?\]\((https?:\/\/[^\s)]+)\)')
//           .firstMatch(block)
//           ?.group(1);

//       if (imageUrl == null) continue;

//       units.add(UnitModel(
//         type: title ?? "وحدة سكنية",
//       price: (price != null && price.isNotEmpty) ? '$price جنيه' : "غير متوفر",

//         size: totalSize,
//         location: location ?? "غير محدد",
//         rooms: rooms,
//         bathrooms: baths,
//         description: description,
//         images: [imageUrl],
//       ));
//     }

//     return UnitExtractionResult(
//       introText: intro,
//       units: units,
//     );
//   }

//   List<UnitModel> _extractUnitsFromText(String text) {
//     final unitBlocks = RegExp(r'(\d+\.\s+\*\*(.*?)\*\*.*?)(?=(\n\d+\.|\Z))', dotAll: true)
//         .allMatches(text)
//         .map((e) => e.group(1)!)
//         .toList();

//     return unitBlocks.map((block) {
//       final titleMatch = RegExp(r'\*\*(.*?)\*\*').firstMatch(block);
//       final sizeMatch = RegExp(r'المساحة:\s*(\d+)').firstMatch(block);
//       final priceMatch = RegExp(r'السعر:\s*([\d,\.\s]+)').firstMatch(block);
//       final descMatch = RegExp(r'مقدم.*?(?=(\n|\r|\Z))').firstMatch(block);
//       final linkMatch = RegExp(r'\[رابط\]\((.*?)\)').firstMatch(block);
//     final imageMatch = RegExp(r'!\[.*?\]\((https?:\/\/[^\s)]+?\.(?:jpg|jpeg|png))\)').firstMatch(block) ??
//     RegExp(r'\b(https?:\/\/[^\s)]+?\.(?:jpg|jpeg|png))\b').firstMatch(block);

// final imageUrl = imageMatch?.group(1);

//       final priceRaw = priceMatch?.group(1)?.replaceAll(RegExp(r'[^\d.]'), '');
//   final locationMatch = RegExp(
//       r'(الشيخ زايد|القاهرة الجديدة|العين السخنة|6 أكتوبر|التجمع الثالث|التجمع الخامس|العاصمة الإدارية)',
//       caseSensitive: false,
//     ).firstMatch(block);
//     final location = locationMatch?.group(0)?.trim();
//       return UnitModel(
//         type: titleMatch?.group(1)?.trim(),
//         size: int.tryParse(sizeMatch?.group(1) ?? ''),
//         price: priceRaw != null ? '${priceRaw.trim()} جنيه' : null,
//         description: descMatch?.group(0)?.trim(),
//         location_link: linkMatch?.group(1),
//      images: (imageUrl != null && imageUrl.isNotEmpty) ? [imageUrl] : [],

//             location: location ?? "غير محدد",
//       );
//     }).toList();
//   }

  void _startTypingAnimation() {
    _typingTimer?.cancel();
    _currentCharIndex = 0;
    _displayedText = "";
    if (mounted) {
      setState(() {});
    }

    if (_fullTargetText.isEmpty) return;

    _typingTimer = Timer.periodic(_typingSpeed, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentCharIndex < _fullTargetText.length) {
        _currentCharIndex++;
        setState(() {
          _displayedText = _fullTargetText.substring(0, _currentCharIndex);
        });
      } else {
        timer.cancel();
        _typingTimer = null;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBot = widget.chatIndex == 1;

    final hasIntroOrUnits = _extractedUnits.isNotEmpty &&
        (_extractedUnits.first.introText != null ||
            _extractedUnits.first.units.isNotEmpty);
    if (hasIntroOrUnits) {
      final introText = _extractedUnits.first.introText;
      final units = _extractedUnits.first.units;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (introText != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  introText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

            // ✅ اعرض الوحدات فقط
            ...units.map((unit) => Padding(
                  key: ValueKey(unit),
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: UnitItem(unit),
                )),
          ],
        ),
      );
    }

// ✅ لو locationLink موجود ومفيش وحدات -> اعرضه لوحده
    if (_extractedUnits.isEmpty && _standaloneLocationLink != null) {
      return ChatLocationPreviewMap(locationLink: _standaloneLocationLink!);
    }

    // 👇 fallback لو مفيش وحدات ولا نص تمهيدي
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isBot ? 0 : 16),
                  bottomRight: Radius.circular(isBot ? 16 : 0),
                ),
              ),
              child: Text(
                _displayedText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // List<UnitModel> _extractUnitsFromText(String text) {
  //   final unitBlocks =
  //       RegExp(r'(\d+\.\s+\*\*(.*?)\*\*.*?)(?=(\n\d+\.|\Z))', dotAll: true)
  //           .allMatches(text)
  //           .map((e) => e.group(1)!)
  //           .toList();

  //   return unitBlocks.map((block) {
  //     final titleMatch = RegExp(r'\*\*(.*?)\*\*').firstMatch(block);
  //     final sizeMatch = RegExp(r'المساحة:\s*(\d+)').firstMatch(block);
  //     final priceMatch = RegExp(r'السعر:\s*([\d,\.\s]+)').firstMatch(block);
  //     final descMatch = RegExp(r'مقدم.*?(?=(\n|\r|\Z))').firstMatch(block);
  //     final linkMatch = RegExp(r'\[رابط\]\((.*?)\)').firstMatch(block);
  //     final imageMatch = RegExp(r'!\[.*?\]\((.*?)\)').firstMatch(block);

  //     final priceRaw = priceMatch?.group(1)?.replaceAll(RegExp(r'[^\d.]'), '');

  //     return UnitModel(
  //       type: titleMatch?.group(1)?.trim(),
  //       size: int.tryParse(sizeMatch?.group(1) ?? ''),
  //       price: priceRaw != null ? '${priceRaw.trim()} جنيه' : null,
  //       description: descMatch?.group(0)?.trim(),
  //       location_link: linkMatch?.group(1),
  //       images: imageMatch != null ? [imageMatch.group(1)!] : [],
  //       location: "القاهرة الجديدة",
  //     );
  //   }).toList();
  // }
}

class UnitExtractionResult {
  final String? introText;
  final List<UnitModel> units;

  UnitExtractionResult({this.introText, required this.units});
}
