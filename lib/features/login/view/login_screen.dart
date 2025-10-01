import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nde_crm/features/login/bloc/login_screen_bloc.dart';
import 'package:nde_crm/features/login/bloc/login_screen_event.dart';
import 'package:nde_crm/features/login/bloc/login_screen_state.dart';
import 'package:nde_crm/features/login/repo/authrepository.dart';
import 'package:nde_crm/features/login/view/password_screen.dart';
import 'package:nde_crm/utils/common/button.dart';
import 'package:nde_crm/utils/common/custom_textfiled.dart';
import 'package:nde_crm/utils/messenger/messenger.dart';
import 'package:nde_crm/utils/router/myrouter.dart';
import 'package:nde_crm/utils/spacer/spacer.dart';
import 'package:nde_crm/utils/validator/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/login_logo.svg'),
              const SizedBox(height: 35),
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) =>
                    previous.email != current.email,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextfomrfiledbox(
                        controller: emailController,
                        hinttext: "Enter your email address",
                        color: Colors.black,
                        validator: (value) =>
                            InputValidator.validateEmail(value ?? ''),
                        onChanged: (value) {
                          context.read<LoginBloc>().add(
                            EmailChanged(email: value),
                          );
                          setState(() {});
                        },
                        suffixIcon: emailController.text.isEmpty
                            ? null
                            : (InputValidator.validateEmail(
                                        emailController.text,
                                      ) ==
                                      null
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        emailController.clear();
                                        context.read<LoginBloc>().add(
                                          EmailChanged(email: ''),
                                        );
                                        setState(() {});
                                      },
                                    )),
                      ),
                      vSpace18,
                      vSpace8,

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Button(
                          color: const Color(0xFF4752EB),
                          width: double.infinity,
                          onPressed: () async {
                            final email = emailController.text.trim();
                            if (email.isNotEmpty) {
                              if (isValidEmail(email)) {
                                final isVerified = await Auth().checkUserEmail(
                                  email,
                                );
                                if (isVerified) {
                                  log(isVerified.toString());
                                  MyRouter.push(
                                    screen: PasswordScreen(email: email),
                                  );
                                } else {
                                  Messenger.alert(msg: "Email not verified.");
                                }
                              } else {
                                Messenger.alert(
                                  msg: "Please enter a valid email address.",
                                );
                              }
                            } else {
                              Messenger.alert(msg: "Please enter your email");
                            }
                          },
                          text: "Next",

                          borderRadius: BorderRadius.circular(20),
                          height: 50,
                          txtcolor: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
