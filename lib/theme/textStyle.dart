import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle lightText(BuildContext context) => GoogleFonts.manrope(
  fontSize: 12,
  fontWeight: FontWeight.w300,
  color: Theme.of(context).textTheme.bodyMedium!.color,
);

TextStyle regularText(BuildContext context) => GoogleFonts.manrope(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Theme.of(context).textTheme.bodyMedium!.color,
);


TextStyle mediumText(BuildContext context) => GoogleFonts.manrope(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Theme.of(context).textTheme.bodyMedium!.color,
);

TextStyle semiboldText(BuildContext context) => GoogleFonts.manrope(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Theme.of(context).textTheme.bodyMedium!.color,
);

TextStyle boldText(BuildContext context) => GoogleFonts.manrope(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: Theme.of(context).textTheme.bodyMedium!.color,
);

TextStyle blackText(BuildContext context) => GoogleFonts.manrope(
  fontSize: 24,
  fontWeight: FontWeight.w900,
  color: Theme.of(context).textTheme.bodyMedium!.color,
);
