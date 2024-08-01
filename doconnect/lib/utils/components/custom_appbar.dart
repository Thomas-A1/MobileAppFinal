// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//   CustomAppBar({Key? key, this.appTitle, this.route, this.icon, this.actions})
//       : super(key: key);
//   @override
//   Size get preferredSize => const Size.fromHeight(60);

//   final String? appTitle;
//   final String? route;
//   final FaIcon? icon;
//   final List<Widget>? actions;

//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: true,
//       backgroundColor: Colors.white, //background color is white in this app
//       elevation: 0,
//       title: Text(
//         widget.appTitle!,
//         style: const TextStyle(
//           fontSize: 20,
//           color: Colors.black,
//         ),
//       ),
//       //if icon is not set, return null
//       leading: widget.icon != null
//           ? Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.greenAccent,
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   //if route is given, then this icon button will navigate to that route
//                   if (widget.route != null) {
//                     Navigator.of(context).pushNamed(widget.route!);
//                   } else {
//                     //else, just simply pop back to previous page
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 icon: widget.icon!,
//                 iconSize: 16,
//                 color: Colors.white,
//               ),
//             )
//           : null,
//       //if action is not set, return null
//       actions: widget.actions ?? null,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Get.back(), icon: Icon(Icons.arrow_back))
            : leadingIcon != null ? IconButton(
                onPressed: leadingOnPressed,
                icon: Icon(leadingIcon),
              ) : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
