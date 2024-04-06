import 'package:flutter/material.dart';

class HadafiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasAvatar;

  const HadafiAppBar({
    super.key,
    this.title = "",
    this.hasAvatar = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: hasAvatar ? _hasAvatar() : Text(title));
  }

  Widget _hasAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar.jpeg'),
          ),
        ),
      ],
    );
  }
}
