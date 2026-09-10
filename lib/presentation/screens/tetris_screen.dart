import '../widgets/tetris_control.dart';
import '../../core/config/game_assets.dart';
import 'dart:async';
import '../../features/economy/models/play_session.dart';
import 'package:flutter/material.dart';
import 'package:tetris_engine/tetris_engine.dart';

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key, this.onReward, this.initialEnergy = 100});
  final ValueChanged<PlayReward>? onReward;
  final double initialEnergy;

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen>
    with WidgetsBindingObserver {
  final TetrisGame _game = TetrisGame();
  PlaySession _session = PlaySession();
  bool _showResults = false;
  bool _replayAfterCollect = false;
  bool _canExit = false;
  Timer? _playTimer;
  late double _energy = widget.initialEnergy;
  TetrisGameStatus? _previousStatus;

  void _syncPlayTimer() {
    final status = _game.state.status;
    if (status == _previousStatus) return;
    _previousStatus = status;
    _playTimer?.cancel();
    if (status == TetrisGameStatus.gameOver) {
      _finish();
      return;
    }
    if (status == TetrisGameStatus.playing) {
      _playTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final reward = _session.tick();
        widget.onReward?.call(reward);
        setState(() => _energy = (_energy - reward.energy).clamp(0.0, 100.0));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _game.onLinesCleared = _session.clearLines;
    _game.addListener(_syncPlayTimer);
    _game.start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _game.pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playTimer?.cancel();
    _game.removeListener(_syncPlayTimer);
    _game.dispose();
    super.dispose();
  }

  void _finish({bool replay = false}) {
    if (_showResults || !mounted) return;
    _showResults = true;
    _replayAfterCollect = replay;
    _playTimer?.cancel();
    _game.pause();
    setState(() {});
  }

  void _collect() {
    if (!_showResults || _canExit) return;
    widget.onReward?.call(_session.claim());
    if (_replayAfterCollect) {
      _session = PlaySession();
      _game.onLinesCleared = _session.clearLines;
      _showResults = false;
      _game.restart();
      setState(() {});
    } else {
      setState(() => _canExit = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  Widget _results() => SafeArea(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFFD9A43E),
              size: 64,
            ),
            const SizedBox(height: 12),
            const Text(
              'Results',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text('Score ${_game.state.scoreState.score}'),
            Text('Lines ${_session.lines}'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(GameAssets.coinIcon, width: 36, height: 36),
                const SizedBox(width: 8),
                Text(
                  '${_session.coins} coins',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_session.xp} XP',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _collect,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Collect'),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canExit,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5E5DE),
        body: _showResults
            ? _results()
            : SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Back',
                          onPressed: () => _finish(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const Expanded(
                          child: Text(
                            'Tetris',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        ListenableBuilder(
                          listenable: _game,
                          builder: (context, _) {
                            final paused =
                                _game.state.status == TetrisGameStatus.paused;
                            return IconButton(
                              tooltip: paused ? 'Resume' : 'Pause',
                              onPressed: paused ? _game.resume : _game.pause,
                              icon: Icon(
                                paused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Restart',
                          onPressed: () => _finish(replay: true),
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      ],
                    ),
                    ListenableBuilder(
                      listenable: _game,
                      builder: (context, _) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Score ${_game.state.scoreState.score}   Speed ${_game.state.levelState.level}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          Text('Energy ${_energy.toStringAsFixed(1)}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 0.5,
                          child: TetrisBoard(
                            game: _game,
                            pauseOverlayBuilder: (_, resume) => _GameOverlay(
                              title: 'Paused',
                              action: 'Resume',
                              onPressed: resume,
                            ),
                            gameOverOverlayBuilder: (_, restart) =>
                                _GameOverlay(
                                  title: 'Game over',
                                  action: 'Play again',
                                  onPressed: restart,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListenableBuilder(
                        listenable: _game,
                        builder: (context, _) {
                          final playing =
                              _game.state.status == TetrisGameStatus.playing;
                          return Wrap(
                            spacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              for (final control
                                  in <(IconData, String, VoidCallback)>[
                                    (
                                      Icons.arrow_back_rounded,
                                      'Move left',
                                      _game.moveLeft,
                                    ),
                                    (
                                      Icons.rotate_right_rounded,
                                      'Rotate',
                                      _game.rotateCW,
                                    ),
                                    (
                                      Icons.arrow_downward_rounded,
                                      'Move down',
                                      _game.softDrop,
                                    ),
                                    (
                                      Icons.vertical_align_bottom_rounded,
                                      'Drop',
                                      _game.hardDrop,
                                    ),
                                    (
                                      Icons.arrow_forward_rounded,
                                      'Move right',
                                      _game.moveRight,
                                    ),
                                  ])
                                TetrisControl(
                                  label: control.$2,
                                  onPressed: playing ? control.$3 : null,
                                  icon: control.$1,
                                  accent:
                                      control.$2 == 'Rotate' ||
                                      control.$2 == 'Drop',
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _GameOverlay extends StatelessWidget {
  const _GameOverlay({
    required this.title,
    required this.action,
    required this.onPressed,
  });
  final String title;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: ColoredBox(
      color: const Color(0xDDFFF2E8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onPressed, child: Text(action)),
          ],
        ),
      ),
    ),
  );
}
