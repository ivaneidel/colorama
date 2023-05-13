import 'package:flutter/material.dart';

// Future<bool> willPop(BuildContext context) async {
//   final leave = await showDialog<bool?>(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text('Salir'),
//       content: const Text('Si salís se va a perder la partida'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancelar'),
//         ),
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(true),
//           child: const Text('Salir'),
//         ),
//       ],
//     ),
//   );
//   if (leave == true) {
//     Navigator.of(context).popUntil((route) => route.settings.name == '/');
//   }

//   return false;
// }

Color getTextColor(Color backgroundColor) {
  return ThemeData.estimateBrightnessForColor(backgroundColor) ==
          Brightness.light
      ? Colors.black
      : Colors.white;
}
