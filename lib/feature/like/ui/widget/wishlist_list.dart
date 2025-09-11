// في ملف wishlist_list.dart

import 'package:broker/feature/like/ui/widget/ai_likes_widget.dart';
// تأكد من صحة هذا المسار
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/fav_cubit.dart';

class WishlistList extends StatelessWidget {
  const WishlistList({super.key});

  @override
  Widget build(BuildContext context) {
    // لا حاجة لـ BlocBuilder هنا لأن الشاشة الأم (LikeScreen) تهتم بذلك
    final favCubit = context.read<FavCubit>();
    final wishList = favCubit.wishList;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: wishList.length,
      itemBuilder: (context, index) {
        final unit = wishList[index];

        return WishlistItemCard(
          key: ValueKey(unit.id), // استخدام مفتاح فريد
          unit: unit,
          
          // تمرير دالة الحذف
          onRemove: () {
            favCubit.removeFromWishList(unit);
          },

          // يمكنك إضافة منطق لهذه الأزرار لاحقًا
          onRequestMeeting: () {
            print("Request meeting for unit: ${unit.id}");
            // TODO: Implement meeting request logic
          },
          onViewDetails: () {
            print("View details for unit: ${unit.id}");
            // TODO: Implement view details logic (e.g., navigate to details screen)
          },
        );
      },
    );
  }
}