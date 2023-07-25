import 'package:flutter/material.dart';

class AuthInput extends StatefulWidget {
  final TextEditingController id;
  final bool obscureText;
  final String hintText;
  final String message;
  final Icon icon;
  const AuthInput({
    super.key,
    required this.id,
    required this.hintText,
    required this.message,
    required this.obscureText,
    required this.icon
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  
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
        validator: (valor){
          if (valor!.isEmpty) {
            return widget.message;
          }
          return null;
        }
      );
  }
}