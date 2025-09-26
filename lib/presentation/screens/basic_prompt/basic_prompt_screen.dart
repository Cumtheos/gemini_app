import 'package:flutter/material.dart';

class BasicPromptScreen extends StatelessWidget {
  const BasicPromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic_prompt_screen'),
      ),
      body: const Center(
        child: Text('Basic_prompt_screen Screen'),
      ),
    );
  }
}