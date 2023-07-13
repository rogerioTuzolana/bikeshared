import 'package:flutter/material.dart';

class showMessageAuthError extends StatelessWidget {
  final BuildContext context;
  const showMessageAuthError({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: size.height * 0.1,
      
      child: const Text(
        "ID ou Senha inválida!",
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.redAccent),
      ),
    );
  }
}