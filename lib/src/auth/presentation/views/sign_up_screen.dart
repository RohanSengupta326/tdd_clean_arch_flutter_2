import 'package:clean_arch_bloc_2/core/common/app/providers/user_provider.dart';
import 'package:clean_arch_bloc_2/core/common/widgets/gradient_background.dart';
import 'package:clean_arch_bloc_2/core/common/widgets/rounded_button.dart';
import 'package:clean_arch_bloc_2/core/res/fonts.dart';
import 'package:clean_arch_bloc_2/core/res/media_res.dart';
import 'package:clean_arch_bloc_2/core/utils/core_utils.dart';
import 'package:clean_arch_bloc_2/src/auth/data/models/user_model.dart';
import 'package:clean_arch_bloc_2/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_arch_bloc_2/src/auth/presentation/views/sign_in_screen.dart';
import 'package:clean_arch_bloc_2/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:clean_arch_bloc_2/src/dashboard/presentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedUp) {
            // if user is signedUp automatically signIn user.
            // so call the signIn even too below.
            context.read<AuthBloc>().add(
                  SignInEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
          } else if (state is SignedIn) {
            // save user data locally and redirect to dashboard.
            context.read<UserProvider>().initUser(state.user as LocalUserModel);

            // we are storing this data locally in a provider controller class
            // because see here on this page we receive the state with userData.
            // but on other pages if we have to use this userData how can we ?
            // we have keep sending this data as constructors, so that's why we
            // are saving this data locally using provider and even if data
            // changes occur, we can update the locally stored data, and using
            // provider we can change others screens too, which aren't connected
            // with the Bloc.
            // example: signIn screen receives state with User data.
            // but on profile screen we also show userData, so we store it
            // locally on provider class so that we can call provider on profile
            // page and how the data, and also if user data updates,
            // profile page is not connected with this bloc here, but still
            // we would update the providers local data, and then reflect that
            // change on the profile screen as that is connected with Provider.

            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: MediaRes.authGradientBackground,
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      'Easy to learn, discover more skills.',
                      style: TextStyle(
                        fontFamily: Fonts.aeonik,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign up for an account',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        child: const Text('Already have an account?'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SignUpForm(
                      emailController: emailController,
                      fullNameController: fullNameController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 30),
                    if (state is AuthLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      RoundedButton(
                        label: 'Sign Up',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: fullNameController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
