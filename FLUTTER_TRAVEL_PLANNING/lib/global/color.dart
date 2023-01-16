import 'package:flutter/material.dart';

class AppColors {
//  ชื่อไฟล์/ชนิด/ชื่อ
  static const Color colorMain = const Color.fromRGBO(242, 208, 86, 1);
  static const Color colorBlue = const Color.fromRGBO(31, 41, 84, 1);
  static const Color color_gold =
      const Color(0xffB58E38); // สีทองใช้อันนี้ได้เลย
  static const Color color =const Color(0xffFFC94B);// สีม่วงใช้อันนี้ได้เลย
  static const Color Black = const Color(0xff333333); // สีดำช้อันนี้ได้เลย
  static const Color color_grey = const Color(0xff8B939A); //สีเทา
  static const Color color_bg_grey = const Color(0xFFf2f5f7); //สีเทาพื้นหลัง
  static const Color color_border = const Color(0xFF999C9D); //สีขอบช่องข้อความ
  static const Color color_line = const Color(0xFFC1C2C3); //สีเส้นขีด hr
  static const Color color_bg_tab = const Color.fromRGBO(240, 240, 245, 1);
  static const Color color_bg = const Color.fromRGBO(235, 238, 243, 1);
  static const Color color_border_grey = const Color.fromRGBO(218, 218, 218, 1);

  static const Color bdColor = const Color(0xfff77710);
  static const Color bgColor = const Color.fromRGBO(227, 226, 243, 1);
  static const Color color_profile = const Color(0xffFFFFFF);
  static const Color color_text = const Color(0xff333333);
  static const Color color_serviceCompany = const Color(0xff333333);
  static const Color color_serviceCompanyDetail = const Color(0xff8B939A);
  static const Color color_blue = const Color.fromRGBO(0, 167, 226, 1);
  static const Color color_white = const Color(0xffFFFFFF);
  static const Color color_black = const Color(0xff000000);

  static const Color color_btn = const Color.fromRGBO(41, 44, 59, 1);

  static const Color color_orange = const Color.fromRGBO(255, 100, 75, 1);
  static const Color color_font_gray = const Color.fromRGBO(84, 85, 99, 1);

  // static const Color color_bg_yellow = const Color.fromRGBO(255, 201, 75, 1);
  static const Color color_bg_yellow = const Color.fromRGBO(255, 201, 75,0.85);
  static const Color color_bg_grey_text = const Color.fromRGBO(196, 196, 196, 1);

  static const Color color_font_hint = const Color.fromRGBO(131, 133, 156, 1);

  static const Color color_head_gery = const Color.fromRGBO(105, 102, 102, 1);
  static const MaterialColor yellow = MaterialColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFE9B7),
      100: Color(0xFFFFE4A7),
      200: Color(0xFFFFE093),
      300: Color(0xFFFFD87E),
      400: Color(0xFFFFD165),
      500: Color(_yellowPrimaryValue),
      600: Color(0xFFFFC132),
      700: Color(0xFFFFBA18),
      800: Color(0xFFFEB100),
      900: Color(0xFFE49F00),
    },
  );
  static const int _yellowPrimaryValue = 0xFFFFC94B;

}
