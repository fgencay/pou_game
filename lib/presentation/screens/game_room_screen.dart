import 'package:flutter/material.dart';
import '../widgets/tetris_icon.dart';

class GameRoomScreen extends StatelessWidget {
  const GameRoomScreen({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: const Color(0xFFFFF0E5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Color(0xFFB58874), width: 2),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Games',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Semantics(
                button: true,
                label: 'Play Tetris',
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.pop(context, true),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TetrisIcon(),
                        SizedBox(height: 8),
                        Text(
                          'Tetris',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
