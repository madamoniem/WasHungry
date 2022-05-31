import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static Color primary = const Color(0xff6c5ce7);
  static Color secondary = const Color(0xffE8E2D2);
  static Color textColor = const Color(0xff2d3436);
  static Color getColor = const Color(0xffe17055);
}

TextStyle statTextStyles = GoogleFonts.poppins(
  color: CustomColors.textColor,
  fontSize: 18,
  fontWeight: FontWeight.w400,
);

TextStyle goldStatTextStyles = GoogleFonts.poppins(
  color: CustomColors.getColor,
  fontSize: 18,
  fontWeight: FontWeight.w800,
);

class CustomText extends StatelessWidget {
  const CustomText(
      {Key? key,
      required this.text,
      this.fontSize = 50,
      this.color = Colors.black})
      : super(key: key);
  final String text;
  final double fontSize;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return NeumorphicText(
      text,
      style: NeumorphicStyle(
        depth: 4,
        shape: NeumorphicShape.concave,
        surfaceIntensity: 1.0,
        intensity: 0,
        color: color,
      ),
      textStyle: NeumorphicTextStyle(
        fontFamily: 'Poppins',
        fontSize: fontSize,
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      style: TextStyle(color: CustomColors.textColor),
      controller: controller,
      cursorColor: CustomColors.textColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: CustomColors.textColor),
        focusColor: CustomColors.textColor,
        fillColor: CustomColors.textColor,
        hoverColor: CustomColors.textColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 3,
            color: CustomColors.textColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: CustomColors.textColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
