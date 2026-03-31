import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme/theme_provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            context.read<ThemeProvider>().toggleTheme();
          },
          icon: Icon(
            context.read<ThemeProvider>().isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
        ),
      ),
    );
  }
}
