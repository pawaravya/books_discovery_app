// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';

// class NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final int index;
//   final TabsRouter tabsRouter;

//   const NavItem({
//     required this.icon,
//     required this.label,
//     required this.index,
//     required this.tabsRouter,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isActive = tabsRouter.activeIndex == index;
//     return InkWell(
//       onTap: () => tabsRouter.setActiveIndex(index),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: isActive ? Colors.blue : Colors.grey),
//             Text(label,
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: isActive ? Colors.blue : Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }