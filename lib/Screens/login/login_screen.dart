import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_marko/Screens/login/cubit/cubit.dart';
import 'package:super_marko/Screens/login/cubit/state.dart';
import 'package:super_marko/Screens/register/register_screen.dart';
import 'package:super_marko/layout/home_screen.dart';
import 'package:super_marko/network/cache_helper.dart';
import 'package:super_marko/shared/components/buttons.dart';
import 'package:super_marko/shared/components/check_box.dart';
import 'package:super_marko/shared/components/constants.dart';
import 'package:super_marko/shared/components/navigator.dart';
import 'package:super_marko/shared/components/show_toast.dart';
import 'package:super_marko/shared/components/text_form_field.dart';
import 'package:super_marko/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status!) {
              showToast(
                text: state.loginModel.message!,
                state: ToastStates.success,
              );
              if (kDebugMode) {
                print(state.loginModel.message);
              }
              if (kDebugMode) {
                print(state.loginModel.data!.token);
              }

              CacheHelper.saveData(
                      key: "token", value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token!;
                navigateAndFinish(context, const HomeScreen());
              });
            } else {
              showToast(
                text: state.loginModel.message!,
                state: ToastStates.error,
              );
              if (kDebugMode) {
                print(state.loginModel.message);
              }
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          left: -156.w,
                          top: -113.h,
                          child: Container(
                            width: 510.w,
                            height: 420.h,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFFF7A2F),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 214.w,
                          top: -47.h,
                          child: Container(
                            width: 458.w,
                            height: 350.h,
                            decoration: const ShapeDecoration(
                              color: Color(0xFF07625D),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 20.w,
                            top: 150.h,
                            child: Container(
                              width: 200.w,
                              height: 300.h,
                              decoration: const ShapeDecoration(
                                shape: OvalBorder(),
                              ),
                              child: Text(
                                'Welcome\nBack',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DefaultTextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefix: Icons.email,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter email';
                                }
                                return null;
                              },
                              label: 'Email',
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            DefaultTextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              prefix: Icons.key,
                              suffix: LoginCubit.get(context).suffix,
                              isPassword: LoginCubit.get(context).isPassword,
                              suffixPressed: () {
                                LoginCubit.get(context).changePassword();
                              },
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              label: 'Password',
                            ),
                            defaultTextButton(
                              function: () {},
                              text: "Forgot Password ?",
                              context: context,
                              color: const Color(0xFF303030),
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            LoginCubit.get(context).isCheck
                                ? defaultMaterialButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        LoginCubit.get(context).userLogin(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    },
                                    text: 'Sign In',
                                    radius: 15,
                                    context: context,
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15).r,
                                      color: AppColorsLight.mainColor
                                          .withOpacity(0.4),
                                    ),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    checkBox(context),
                                    Text(
                                      'By creating an account, you agree to our',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 45.0).r,
                                  child: Text(
                                    'Term and Conditions',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          height: 0.2,
                                          color: const Color(0xFF5FD068),
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 43.h,
                    decoration: const BoxDecoration(color: Color(0xFFFF7A2F)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        defaultTextButton(
                          function: () {
                            navigateTo(context, RegisterScreen());
                          },
                          text: 'Sign Up'.toUpperCase(),
                          color: AppColorsLight.mainColor,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
