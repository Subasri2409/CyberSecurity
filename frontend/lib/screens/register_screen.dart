import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedGender;
  bool _obscureText = true;

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      final response = await ApiService.registerUser(
        nameController.text,
        emailController.text,
        phoneController.text,
        selectedGender ?? "",
        passwordController.text,
      );

      if (response["msg"] == "User registered successfully") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration successful!")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response["msg"])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.teal.shade600, Colors.green.shade400], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Register", style: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                        validator: (value) => value!.isEmpty ? "Enter your name" : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                        validator: (value) => value!.isEmpty ? "Enter a valid email" : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
                        validator: (value) => value!.length < 10 ? "Enter a valid phone number" : null,
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(border: OutlineInputBorder(), prefixIcon: Icon(Icons.person_outline)),
                        hint: Text("Select Gender"),
                        value: selectedGender,
                        items: ["Male", "Female", "Other"].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                        onChanged: (value) => setState(() => selectedGender = value),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                        validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(onPressed: registerUser, child: Text("Register", style: TextStyle(fontSize: 18))),
                      TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())), child: Text("Already have an account? Login")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
