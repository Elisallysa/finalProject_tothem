import 'package:flutter/material.dart';
import '../../screens/screens.dart';

IconButton getGreenIconButton(BuildContext context, void Function() onPressed,
    IconData icon, Color iconBorder) {
  ColorScheme colorScheme = Theme.of(context).colorScheme;

  return IconButton(
    icon: Icon(icon),
    onPressed: onPressed,
    style: IconButton.styleFrom(
      focusColor: colorScheme.onSurfaceVariant.withOpacity(0.12),
      highlightColor: colorScheme.onSurface.withOpacity(0.12),
      side: BorderSide(color: iconBorder),
    ).copyWith(
      foregroundColor:
          MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return colorScheme.onSurface;
        }
        return null;
      }),
    ),
  );
}
