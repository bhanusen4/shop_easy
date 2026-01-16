import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                /// Title
                const Text(
                  "Hello Again!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  "Welcome back you've\nbeen missed!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,

                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                /// Email
                CustomTextField(
                  hint: "Enter email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Email is required";
                    }
                    if (!v.contains('@')) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// Password
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return CustomTextField(
                      hint: "Password",
                      isPassword: true,
                      obscureText: auth.obscurePassword, // Gets value from Provider
                      onSuffixTap: () => auth.togglePasswordVisibility(), // Calls Provider method
                      validator: (value) => value!.length < 6 ? "Too short" : null,
                    );
                  },
                ),

                const SizedBox(height: 10),

                /// Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Recovery Password",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Sign In Button
                Consumer<AuthProvider>(
                  builder: (_, auth, __) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomButton(
                        title: "Sign In",
                        loading: auth.isLoading,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await auth.login(
                              email: "test@mail.com",
                              password: "123456",
                            );
                            if (success) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.dashboard);
                            }
                          }
                        },
                      ),
                    );
                  },
                ),


                const SizedBox(height: 30),

                /// Divider
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or continue with"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                /// Social Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton("assets/images/google.png"),
                    const SizedBox(width: 16),
                    _socialButton("assets/images/apple.png"),
                    const SizedBox(width: 16),
                    _socialButton("assets/images/facebook.png"),

                  ],
                ),

                const SizedBox(height: 30),

                /// Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member? "),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _socialButton(String logo) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(logo, fit: BoxFit.contain, ),
      ),
    );
  }
}
