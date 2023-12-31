import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gv_key_app/app/components/auth_widgets.dart';
import 'package:gv_key_app/app/controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  RegisterPage({super.key});

  // final controller = Get.put(RegisterController());
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.2, horizontal: width * 0.05),
          child: Form(
            key: _form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create your new account',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Enter your valid credentials to continue',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 30),
                authForm(
                  formController: controller.usernameController,
                  formValidator: controller.usernameValidate,
                  keyboardType: TextInputType.text,
                  hintText: "Enter your username",
                  iconForm: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                authForm(
                  formController: controller.emailController,
                  formValidator: controller.emailValidate,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter your email",
                  iconForm: const Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                authForm(
                    formController: controller.passwordController,
                    formValidator: controller.passwordValidate,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Enter your password",
                    iconForm: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    obscureText: true),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.89,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        controller.registerApi();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                authTextButton(
                  controller: () {
                    controller.clearController();
                    Get.back();
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
