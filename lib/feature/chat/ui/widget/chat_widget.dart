// lib/feature/chat/ui/widgets/chat_widget.dart

import 'dart:async';
import 'package:broker/core/sharedWidgets/unit_widget.dart';
import 'package:broker/core/theming/colors.dart';
import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/calendar/ui/CalendarScreen.dart';
import 'package:broker/feature/home/data/models/unit_model.dart';
import 'package:broker/feature/like/logic/fav_cubit.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    Key? key,
    required this.msg, 
    this.messageId,
    // msg سيكون الآن هو الرد الكامل من الموديل
    required this.chatIndex,
    this.onFeedback,
    required this.isCurrentlyReceiving,
  }) : super(key: key);

  final String msg;
  final int chatIndex;
  final  String? messageId;
  // ✅ تم تحديث توقيع الدالة لتشمل messageId
  final Function(String messageId, String feedbackType, String? comment)?
      onFeedback;
  final bool isCurrentlyReceiving;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  // --- متغيرات الحالة (State) ---
  String _displayedText = "";
  String _fullIntroText = "";
  String? _messageId;

  Timer? _typingTimer;
  int _currentCharIndex = 0;
  final Duration _typingSpeed = const Duration(milliseconds: 25);

  List<UnitModel> _extractedUnits = [];
  bool _shouldShowCalendar = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: 0.88); // لترك مساحة بين الوحدات
    _initializeMessage();
  }

  // هذه الدالة تعمل عند تحديث الـ Widget (عند وصول رد جديد)
  @override
  void didUpdateWidget(covariant ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.msg != oldWidget.msg) {
      _initializeMessage();
    }
  }

  void _initializeMessage() {
    _typingTimer?.cancel(); // أوقف أي أنيميشن قديم

    // إذا كانت رسالة مستخدم، اعرضها مباشرة
    if (widget.chatIndex == 0) {
      setState(() {
        _fullIntroText = widget.msg;
        _displayedText = widget.msg;
        _extractedUnits = [];
        _messageId = null;
      });
      return;
    }

    // إذا كانت رسالة بوت، قم بتحليلها
    final parsedResult = extractUnitsWithIntro(widget.msg);
    print("11111");
    print(widget.msg);
    print(parsedResult);
    final appointmentRegex = RegExp(
        r'(تاريخ|معاد|حجز موعد|موعد|وقت|لمعاينة|تحديد ميعاد)',
        caseSensitive: false);
         final appointmentRequestRegex = RegExp(r'(تاريخ|معاد|حجز موعد|وقت|لمعاينة|تحديد ميعاد)', caseSensitive: false);
  final appointmentConfirmationRegex = RegExp(r'(تم حجز موعد|حجزك تأكد)', caseSensitive: false);

    setState(() {
      _fullIntroText = parsedResult.introText ?? "";
      _extractedUnits = parsedResult.units;
      _messageId = parsedResult.messageId; // حفظ الـ ID للتقييم
      _shouldShowCalendar = 
        appointmentRequestRegex.hasMatch(_fullIntroText) && 
        !appointmentConfirmationRegex.hasMatch(_fullIntroText) && 
        _extractedUnits.isEmpty;
    });

    _startTypingAnimation();
  }
  void _startTypingAnimation() {
    _currentCharIndex = 0;
    setState(() => _displayedText = "");
    
    // النص الذي سيتم عمل أنيميشن له هو النص التمهيدي فقط
    final textToAnimate = _fullIntroText;

    if (textToAnimate.isEmpty || !widget.isCurrentlyReceiving) {
      setState(() => _displayedText = textToAnimate);
      return;
    }

    _typingTimer = Timer.periodic(_typingSpeed, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_currentCharIndex < textToAnimate.length) {
        _currentCharIndex++;
        setState(() => _displayedText = textToAnimate.substring(0, _currentCharIndex));
      } else {
        timer.cancel();
        _typingTimer = null;
      }
    });
  } @override
  void dispose() {
    _typingTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // =========================================================================
  // ✅ دالة تحليل النص الجديدة والأكثر قوة
  // في ملف: lib/feature/chat/ui/widgets/chat_widget.dart

// VVV استبدل هذه الدالة بالكامل VVV
  UnitExtractionResult extractUnitsWithIntro(String text) {
    print("--- Parsing New Bot Message ---");
    final List<UnitModel> units = [];
    String? intro;
    // الـ messageId يتم استخراجه الآن في الـ Cubit، لذا لا حاجة له هنا
    // لكننا سنتركه في الكلاس المساعد للتوافقية

    try {
      // الخطوة 1: فصل النص التمهيدي عن كتل الوحدات
      final introMatch = RegExp(r'^(.*?)(\[\[\[UNIT_START\]\]\])', dotAll: true)
          .firstMatch(text);
      if (introMatch != null) {
        intro = introMatch.group(1)?.trim();
      } else {
        intro = text;
      }
      if (intro?.isEmpty ?? true) intro = null;

      // الخطوة 2: استخراج كتل الوحدات
      final unitBlocks = RegExp(
              r'\[\[\[UNIT_START\]\]\](.*?)\[\[\[UNIT_END\]\]\]',
              dotAll: true)
          .allMatches(text)
          .map((e) => e.group(1)!)
          .toList();

      print("Found ${unitBlocks.length} unit blocks.");

      // الخطوة 3: تحليل كل كتلة
      for (final block in unitBlocks) {
        // دالة مساعدة مرنة تتجاهل الرموز والنصوص الزائدة
        String? extractValue(String pattern) {
          return RegExp(pattern, caseSensitive: false, multiLine: true)
              .firstMatch(block)
              ?.group(1)
              ?.trim();
        }

        // VVV هذه هي التعبيرات النمطية (RegEx) الجديدة والمحسّنة VVV
        final unitIdText =
            extractValue(r'\[\[رقم الوحدة\]\]:\s*\[\[\[(\d+)\]\]\]');
        final projectName = extractValue(r'اسم المشروع:\s*"(.*?)"');
        // يتجاهل الرموز والمسافات ويأخذ الرقم والعملة
        final priceText = extractValue(r'السعر:.*?([\d,.\s]+(?:جنيه|مصري)+)');
        final sizeText = extractValue(r'المساحة:.*?([\d,.]+)\s*متر');
        final roomsText = extractValue(r'الغرف:.*?(\d+)');
        final location = extractValue(r'الموقع:\s*(.+)');
        // يتجاهل أي شيء بين "الصور:" والقوس المربع "["
        final imageUrl = extractValue(r'الصور:.*?\((https?:\/\/[^\s)]+)\)');
        final locationLink =
            extractValue(r'رابط الموقع:.*?\((https?:\/\/[^\s)]+)\)');

        final unitId = unitIdText != null ? int.tryParse(unitIdText) : null;

        // شرط أساسي: إذا لم يتم العثور على صورة، تجاهل الوحدة
        if (imageUrl == null) {
          print("DEBUG: Image URL not found in block. Skipping unit.");
          print("--- Block Content ---\n$block\n--------------------");
          continue;
        }

        units.add(UnitModel(
          id: unitId,
          type: projectName, // استخدام اسم المشروع كنوع
          location: location ?? "غير محدد",
          locationLink: locationLink,
          price: priceText,
          size: sizeText != null
              ? int.tryParse(sizeText.replaceAll(',', ''))
              : null,
          rooms: roomsText != null ? int.tryParse(roomsText) : null,
          bathrooms: null,
          description: null,
          images: [imageUrl],
        ));
      }
    } catch (e) {
      print("Error during message parsing: $e");
      return UnitExtractionResult(introText: text, units: [], messageId: null);
    }

    return UnitExtractionResult(
        introText: intro, units: units, messageId:widget.messageId);
  }

  @override
  // Widget build(BuildContext context) {
  //   final isBot = widget.chatIndex == 1;
  //   final isAnimationDone = _typingTimer == null;

  //   if (isBot && _shouldShowCalendar) {
  //     return const Padding(
  //       padding: EdgeInsets.symmetric(vertical: 12.0),
  //       child: CalendarScreen(),
  //     );
  //   }

  //   Widget mainContent;
  //   if (isBot && _extractedUnits.isNotEmpty) {
  //     mainContent = _buildUnitsCarousel(isAnimationDone);
  //   } else {
  //     mainContent = _buildSimpleTextMessage();
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Column(
  //       crossAxisAlignment:
  //           isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
  //       children: [
  //         mainContent,
  //         if (isBot && isAnimationDone) _buildFeedbackButtons(),
  //       ],
  //     ),
  //   );
  // }
   Widget build(BuildContext context) {
    final isBot = widget.chatIndex == 1;

    // ==========================================================
    // VVV              هذا هو التعديل الأساسي               VVV
    // ==========================================================
    
    // إذا كانت رسالة بوت وتحتوي على وحدات، اعرض الكاروسيل
    if (isBot && _extractedUnits.isNotEmpty) {
      return _buildUnitsCarousel();
    }
    
    // إذا كانت رسالة بوت وتتطلب التقويم
    if (isBot && _shouldShowCalendar) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: CalendarScreen(),
      );
    }
    
    // في جميع الحالات الأخرى، اعرض رسالة نصية بسيطة
    return _buildSimpleTextMessage();
  }


  Widget _buildSimpleTextMessage() {
    final bool isBot = widget.chatIndex == 1;
    return Align(
      alignment:
          widget.chatIndex == 1 ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: widget.chatIndex == 1
              ? Colors.transparent.withOpacity(0.1)
              : Colors.transparent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _displayedText,
          // استخدم الأنماط المعرفة مسبقاً من كلاس TextStyles
          style: isBot
              ? TextStyles.chatBotMessageStyleCustom // أو .chatBotMessageStyle
              : TextStyles.chatUserMessageStyle,
        ),
      ),
    );
  }  Widget _buildUnitsCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_fullIntroText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 16.0),
            child: Text(
              _displayedText, // هذا سيعرض النص التمهيدي مع الأنيميشن
              style: TextStyles.chatBotMessageStyleCustom,
            ),
          ),
        
        // الكاروسيل سيظهر مباشرةً
        SizedBox(
          height: 420,
          child: BlocBuilder<FavCubit, FavState>(
            builder: (context, state) {
              final favCubit = context.read<FavCubit>();
              final profileCubit = context.read<ProfileCubit>();
              return PageView.builder(
                controller: _pageController,
                itemCount: _extractedUnits.length,
                itemBuilder: (context, index) {
                  final UnitModel unit = _extractedUnits[index];
                  final bool isFavorite = favCubit.favorite.contains(unit.id);
                  return Padding(
                    key: ValueKey('${unit.id}_$index'),
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: UnitItem(
                      unit,
                      isFavorite: isFavorite,
                      onFavoriteTap: () {
                     if (profileCubit.profileUser != null) {
                        // ✅ الحل: استخدم 'unit' هنا أيضاً
                        if (isFavorite) {
                          favCubit.removeFromWishList(unit);
                        } else {
                          favCubit.addToWishList(model: unit);
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "You Don't have an account",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: ColorsManager.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // أزرار التقييم تظهر بعد انتهاء الأنيميشن
        if (_typingTimer == null) _buildFeedbackButtons(),
      ],
    );
  } Widget _buildFeedbackButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _feedbackButton(Icons.thumb_up_alt_outlined, 'like'),
          const SizedBox(width: 12),
          _feedbackButton(Icons.thumb_down_alt_outlined, 'dislike'),
        ],
      ),
    );
  }

  Widget _feedbackButton(IconData icon, String feedbackType) {
    return InkWell(
      onTap: () {
        if (widget.onFeedback != null && widget.messageId!= null) {
          widget.onFeedback!(widget.messageId!, feedbackType, null);
          Fluttertoast.showToast(msg: "Thanks for your feedback!");
        } else if (widget.onFeedback != null) {
          Fluttertoast.showToast(
              msg: "Could not find message ID for feedback.");
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
      ),
    );
  }
}

// كلاس مساعد لتنظيم البيانات المستخرجة
class UnitExtractionResult {
  final String? introText;
  final List<UnitModel> units;
  final String? messageId;

  UnitExtractionResult({this.introText, required this.units, this.messageId});
}
