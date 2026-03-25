import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const cAppTitle = "HMS Pro";
const cAboutusTitle = "About HMS";
const cSignupTitle = "Create account";
const cSettingsTitle = "User Profile";
const cRxTitle = "Pharmacy";
const cVaccineTitle = "Vaccine";
const cOPDIPDTitle = "OPD/IPD";
const cMessagesTitle = "Messages";
const cPathologysTitle = "Pathology";
const cAppointment = "Appointments";
const cAdmin = "Admin Console";
const cPerson = "Patient Information";
const cPRecords = "Medical Records";
const cReports = "Analytics";
const cSCM = "Supply Chain";
const cAddressBookTitle = "Directory";
const cAddressBookAddTitle = "Add Contact";
const cAddressBookEditTitle = "Edit Contact";
const cSignUpTitle = "Join HMS";

enum cMessageType { error, success }

// Medical Color Palette
const Color cPrimaryBlue = Color(0xFF1976D2);
const Color cSecondaryAzure = Color(0xFFE3F2FD);
const Color cSurfaceWhite = Color(0xFFFFFFFF);
const Color cAccentBlue = Color(0xFF2196F3);

final TextStyle cNavText = GoogleFonts.inter(
    color: cPrimaryBlue,
    fontSize: 16.0,
    fontWeight: FontWeight.w600);

final TextStyle cNavRightText = GoogleFonts.inter(
    color: cPrimaryBlue,
    fontSize: 14.0,
    fontWeight: FontWeight.w500);

const cEmailID = "support@hms.pro";
const cLabel = "Main Menu";
const cSampleImage =
    "https://ui-avatars.com/api/?name=User&background=1976D2&color=fff&size=128";

final TextStyle cBodyText = GoogleFonts.inter(
  fontWeight: FontWeight.w400,
  color: Colors.black87,
);
final TextStyle cErrorText = GoogleFonts.inter(
  fontWeight: FontWeight.w500,
  color: Colors.redAccent,
);

final TextStyle cHeaderText = GoogleFonts.inter(
    color: cPrimaryBlue,
    fontSize: 22.0,
    fontWeight: FontWeight.w700);

final TextStyle cHeaderWhiteText = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 22.0,
    fontWeight: FontWeight.w700);

final TextStyle cHeaderDarkText = GoogleFonts.inter(
    color: Colors.black87,
    fontSize: 22.0,
    fontWeight: FontWeight.w700);

var cThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: cPrimaryBlue,
    primary: cPrimaryBlue,
    secondary: cSecondaryAzure,
    surface: cSurfaceWhite,
    onPrimary: Colors.white,
    onSecondary: cPrimaryBlue,
  ),
  textTheme: GoogleFonts.interTextTheme(),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: cPrimaryBlue, width: 2),
    ),
    labelStyle: const TextStyle(color: cPrimaryBlue),
    prefixIconColor: cPrimaryBlue,
    suffixIconColor: cPrimaryBlue,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: cPrimaryBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: cPrimaryBlue,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
