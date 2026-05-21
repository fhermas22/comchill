import 'package:comchill_app/widgets/custom_circle_progress_indicator.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    this.onPressed,
    this.label,
    this.isLoading,
    this.borderRadius,
    this.backgroudColor,
    this.textStyle,
    this.prefixIcon,
    this.borderColor,
  });

  final VoidCallback? onPressed;
  final String? label;
  final bool? isLoading;
  final BorderRadiusGeometry? borderRadius;
  final TextStyle? textStyle;
  final Color? backgroudColor;
  final Widget? prefixIcon;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = OutlinedButton.styleFrom(
      side: BorderSide(
        color: borderColor ?? Colors.black.withValues(alpha: 0.2),
      ),
      backgroundColor: backgroudColor ?? Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );

    final Widget buttonContent = (isLoading == true)
        ? const CustomCircleProgressIndicator()
        : Text(
            label ?? "",
            style: textStyle ??
                Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, 
                      fontSize: 16,
                    ),
          );

    return Row(
      children: [
        Expanded(
          child: prefixIcon != null && isLoading != true
            ?OutlinedButton.icon(
              onPressed: onPressed,
              style: buttonStyle,
              icon: prefixIcon!,
              label: buttonContent,
            )
           :OutlinedButton(
              onPressed: onPressed,
                style: buttonStyle,
                child: buttonContent,
            ),
        ),
      ],
    );
  }
}
