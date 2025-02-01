import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_projecet/core/app_router.dart';
import 'package:vision_projecet/features/image_capture/presentation/providers/object_selection_provider.dart';
import 'package:vision_projecet/features/image_capture/presentation/screens/object_selection_screen.dart';
import 'package:vision_projecet/features/object_detection/presentation/providers/object_detection_provicer.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ObjectDetectionProvider()),
        ChangeNotifierProvider(create: (context) => ObjectSelectionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Vision Project',
      debugShowCheckedModeBanner: false,
      initialRoute: ObjectSelectionScreen.route,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
