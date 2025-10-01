import 'package:flutter/material.dart';
import 'package:nde_crm/utils/common/font_sizes.dart';


TextStyle robotoRegular(BuildContext context){
  return TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
  fontSize: FontSizes.fontSizeDefault(context),
);
}
TextStyle robotoMedium (BuildContext context){
  return TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w500,
  fontSize: FontSizes.fontSizeDefault(context),
);}

TextStyle robotoBold (BuildContext context){
  return TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w700,
  fontSize: FontSizes.fontSizeDefault(context),
);}

TextStyle robotoBlack (BuildContext context){
  return TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w900,
  fontSize: FontSizes.fontSizeDefault(context),
);}
