import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class MedicinceAnimation extends StatefulWidget {
  const MedicinceAnimation({super.key});

  @override
  State<MedicinceAnimation> createState() => _MedicinceAnimationState();
}

class _MedicinceAnimationState extends State<MedicinceAnimation> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lotties/note_medicines.json',
      fit: BoxFit.contain,
      width: 300.w,
      height: 300.w,
    );
  }
}
