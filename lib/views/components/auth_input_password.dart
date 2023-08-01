import 'package:flutter/material.dart';

class AuthInputPassword extends StatefulWidget {
  final TextEditingController id;
  final bool obscureText;
  final String hintText;
  final List<String> message;
  const AuthInputPassword({
    super.key,
    required this.id,
    required this.hintText,
    required this.message,
    required this.obscureText
  });

  @override
  State<AuthInputPassword> createState() => _AuthInputPasswordState();
}

class _AuthInputPasswordState extends State<AuthInputPassword> {
  
  Icon _icon = const Icon(Icons.visibility_off);
  bool _obscureText = true;
  _showOrHideText() {
    setState(() {
      if (_obscureText) {
        _icon = const Icon(Icons.visibility);
        _obscureText = false;
      } else {
        _icon = const Icon(Icons.visibility_off);
        _obscureText = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
      TextFormField(
        controller: widget.id,
        keyboardType: TextInputType.text,
        obscureText: _obscureText,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.blueGrey,
          ),
          suffixIcon: IconButton(
            color: Colors.blueGrey,
            icon: _icon,
            onPressed: () => _showOrHideText(),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 32, 70, 82)),
              borderRadius: BorderRadius.circular(50)
          ),
        ),
        maxLines: 1,
        validator: (valor){
          if (valor == null || valor.isEmpty) {
            return widget.message[0];
          }else if (valor.length < 4) {
            return widget.message[1];
          }
          return null;
        }
      );
  }
}