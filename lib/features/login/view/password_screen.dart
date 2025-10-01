import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nde_crm/features/crm_home/home_screen.dart';
import 'package:nde_crm/features/login/bloc/login_screen_bloc.dart';
import 'package:nde_crm/features/login/bloc/login_screen_event.dart';
import 'package:nde_crm/features/login/bloc/login_screen_state.dart';
import 'package:nde_crm/utils/common/button.dart';
import 'package:nde_crm/utils/common/custom_textfiled.dart';
import 'package:nde_crm/utils/messenger/messenger.dart';
import 'package:nde_crm/utils/router/myrouter.dart';

class PasswordScreen extends StatefulWidget {
  final String email;

  const PasswordScreen({super.key, required this.email});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = widget.email.isNotEmpty
        ? widget.email[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            MyRouter.pushRemoveUntil(screen: HomeScreen());
            context.read<LoginBloc>().add(LoginStatusReset());
          } else if (state.status == LoginStatus.networkErrorScreen ||
              state.status == LoginStatus.backendErrorScreen ||
              state.status == LoginStatus.errorScreen) {
            Messenger.alertError('Something Went Wrong!');
            context.read<LoginBloc>().add(LoginStatusReset());
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF4752EB),
                  child: Text(
                    firstLetter,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome ",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                /// Password Input
                BlocBuilder<LoginBloc, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.password != current.password,
                  builder: (context, state) {
                    return MyTextfomrfiledbox(
                      controller: passwordController,
                      hinttext: "Enter Password",
                      color: Colors.black,
                      obscureText: _obscureText,
                      onChanged: (value) {
                        context.read<LoginBloc>().add(
                          PasswordChanged(password: value),
                        );
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                /// Sign In Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Button(
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(20),
                        height: 50,
                        color: const Color(0xFF2330E7),
                        txtcolor: Colors.white,
                        text: "Sign In",
                        isLoading: state.status == LoginStatus.loading,
                        onPressed: () {
                          final password = passwordController.text.trim();

                          if (password.isEmpty) {
                            Messenger.alertError('Password cannot be empty');
                            return;
                          }

                          if (password.length < 6) {
                            Messenger.alertError(
                              'Password must be at least 6 characters',
                            );
                            return;
                          }

                          context.read<LoginBloc>().add(
                            LoginApi(email: widget.email, password: password),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
