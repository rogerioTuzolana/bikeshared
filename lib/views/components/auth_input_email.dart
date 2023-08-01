import 'package:flutter/material.dart';

class AuthInputEmail extends StatefulWidget {
  final TextEditingController id;
  final bool obscureText;
  final String hintText;
  final String message;
  final Icon icon;
  const AuthInputEmail({
    super.key,
    required this.id,
    required this.hintText,
    required this.message,
    required this.obscureText,
    required this.icon
  });

  @override
  State<AuthInputEmail> createState() => _AuthInputEmailState();
}

class _AuthInputEmailState extends State<AuthInputEmail> {
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  @override
  Widget build(BuildContext context) {
    return 
      TextFormField(
        controller: widget.id,
        keyboardType: TextInputType.text,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: widget.icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 32, 72, 82)),
              borderRadius: BorderRadius.circular(50)
          ),
        ),
        maxLines: 1,
        validator: (value){
          if (value!.isEmpty) {
            return widget.message;
          }
          if (!_emailRegex.hasMatch(value)) {
            return 'Por favor, insira um email válido.';
          }
          return null;
        }
      );
  }
}