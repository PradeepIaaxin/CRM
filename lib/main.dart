import 'package:flutter/material.dart';
import 'package:nde_crm/utils/error_screen/backend_error_screen.dart';
import 'package:nde_crm/utils/error_screen/network_error_screen.dart';
import 'package:nde_crm/utils/theme/themes.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Demo',
    debugShowCheckedModeBanner: false ,
     
       

      home:  BackendErrorScreen(message: 'something went wrong',),
    );
  }
}

