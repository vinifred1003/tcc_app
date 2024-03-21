import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text screen_title;
  const BaseAppBar({
    super.key,
    required this.screen_title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: screen_title,
      backgroundColor: Theme.of(context).colorScheme.primary,
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      actions: <Widget>[
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          radius: 20,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.question_mark),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
