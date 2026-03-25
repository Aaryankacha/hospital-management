import 'package:flutter/material.dart';
import 'package:src/shared/custom_style.dart';

class EmergencyButton extends StatefulWidget {
  final VoidCallback onPressed;

  const EmergencyButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3 * (1.3 - _animation.value + 1)),
                blurRadius: 20 * _animation.value,
                spreadRadius: 10 * _animation.value,
              ),
            ],
          ),
          child: ScaleTransition(
            scale: _animation,
            child: FloatingActionButton.large(
              onPressed: widget.onPressed,
              backgroundColor: Colors.redAccent,
              child: const Icon(
                Icons.emergency_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
