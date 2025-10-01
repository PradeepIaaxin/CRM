import 'package:flutter/material.dart';
import '../../../utils/common/font_sizes.dart';
import '../../../utils/themes/light_theme.dart';
import '../styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final List<Widget>? actions;
  final Widget? leadingWidget;

  const CustomAppBar({super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.leadingWidget,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: robotoMedium(context).copyWith(
          fontSize: FontSizes.fontSizeExtraLarge(context),
          backgroundColor: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
      centerTitle: true,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isBackButtonExist)
            IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pop(context),
            ),
          if (leadingWidget != null) leadingWidget!,
        ],
      ),
      backgroundColor: AppColors.bluePrimary,
      surfaceTintColor:  AppColors.bluePrimary,
      shadowColor:  AppColors.bluePrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(1170, 50);
}
