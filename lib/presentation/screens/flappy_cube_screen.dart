import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/config/game_assets.dart';
import '../../features/economy/models/play_session.dart';

class FlappyCubeScreen extends StatefulWidget {
  const FlappyCubeScreen({super.key, this.onReward, this.initialEnergy = 100});
  final ValueChanged<PlayReward>? onReward;
  final double initialEnergy;

  @override
  State<FlappyCubeScreen> createState() => _FlappyCubeScreenState();
}

class _PipeData {
  _PipeData(this.x, this.topHeight, this.gapHeight);
  double x;
  final double topHeight;
  final double gapHeight;
  bool passed = false;
}

class _FlappyCubeScreenState extends State<FlappyCubeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late Ticker _ticker;
  PlaySession _session = PlaySession();
  bool _showResults = false;
  bool _replayAfterCollect = false;
  bool _canExit = false;
  bool _isPaused = false;
  bool _isGameOver = false;

  Timer? _playTimer;
  late double _energy = widget.initialEnergy;
  final Random _random = Random();

  // Physics parameters
  static const double _gravity = 980.0;
  static const double _jumpForce = -340.0;
  static const double _scrollSpeed = 150.0;
  static const double _cubeSize = 36.0;
  static const double _pipeWidth = 60.0;
  static const double _gapHeight = 140.0;
  static const double _pipeSpacing = 180.0;

  double _cubeY = 200.0;
  double _velocity = 0.0;
  int _score = 0;
  final List<_PipeData> _pipes = [];
  Duration _lastTimeStamp = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _ticker = createTicker(_onTick);
    _startSession();
  }

  void _startSession() {
    _session = PlaySession();
    _score = 0;
    _cubeY = 180.0;
    _velocity = 0.0;
    _pipes.clear();
    _isPaused = false;
    _isGameOver = false;
    _showResults = false;
    _lastTimeStamp = Duration.zero;

    _playTimer?.cancel();
    _playTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPaused || _isGameOver || _showResults) return;
      final reward = _session.tick();
      widget.onReward?.call(reward);
      setState(() => _energy = (_energy - reward.energy).clamp(0.0, 100.0));
    });

    _ticker.start();
  }

  void _onTick(Duration timeStamp) {
    if (_lastTimeStamp == Duration.zero) {
      _lastTimeStamp = timeStamp;
      return;
    }

    final double dt = (timeStamp - _lastTimeStamp).inMicroseconds / 1000000.0;
    _lastTimeStamp = timeStamp;

    if (_isPaused || _isGameOver || _showResults || dt <= 0 || dt > 0.1) {
      return;
    }

    setState(() {
      _velocity += _gravity * dt;
      _cubeY += _velocity * dt;

      const gameHeight = 400.0;
      const gameWidth = 320.0;
      const cubeX = 60.0;

      // Pipe movement and scoring
      for (final pipe in _pipes) {
        pipe.x -= _scrollSpeed * dt;
        if (!pipe.passed && pipe.x + _pipeWidth < cubeX) {
          pipe.passed = true;
          _score++;
          _session.clearLines(1);
        }
      }

      // Remove offscreen pipes
      _pipes.removeWhere((p) => p.x < -_pipeWidth);

      // Spawn new pipes
      if (_pipes.isEmpty || _pipes.last.x < gameWidth - _pipeSpacing) {
        final topH = 50.0 + _random.nextDouble() * 150.0;
        _pipes.add(_PipeData(gameWidth, topH, _gapHeight));
      }

      // Check boundary collisions
      if (_cubeY <= 0 || _cubeY + _cubeSize >= gameHeight) {
        _triggerGameOver();
      }

      // Check pipe collisions
      for (final pipe in _pipes) {
        if (cubeX + _cubeSize > pipe.x && cubeX < pipe.x + _pipeWidth) {
          if (_cubeY < pipe.topHeight ||
              _cubeY + _cubeSize > pipe.topHeight + pipe.gapHeight) {
            _triggerGameOver();
          }
        }
      }
    });
  }

  void _jump() {
    if (_isGameOver || _isPaused || _showResults) return;
    setState(() {
      _velocity = _jumpForce;
    });
  }

  void _triggerGameOver() {
    if (_isGameOver) return;
    _isGameOver = true;
    _finish();
  }

  void _finish({bool replay = false}) {
    if (_showResults || !mounted) return;
    _showResults = true;
    _replayAfterCollect = replay;
    _playTimer?.cancel();
    _ticker.stop();
    setState(() {});
  }

  void _collect() {
    if (!_showResults || _canExit) return;
    widget.onReward?.call(_session.claim());
    if (_replayAfterCollect) {
      _startSession();
      setState(() {});
    } else {
      setState(() => _canExit = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      setState(() => _isPaused = true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playTimer?.cancel();
    _ticker.dispose();
    super.dispose();
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
                Text(
                  'Score $_score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: _collect,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Collect'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        widget.onReward?.call(_session.claim());
                        _startSession();
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Play Again'),
                    ),
                  ],
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
                            'Flappy Cube',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: _isPaused ? 'Resume' : 'Pause',
                          onPressed: () => setState(() => _isPaused = !_isPaused),
                          icon: Icon(
                            _isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Restart',
                          onPressed: () => _finish(replay: true),
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'Score $_score',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 320 / 400,
                          child: GestureDetector(
                            key: const ValueKey('flappy-game-board'),
                            behavior: HitTestBehavior.opaque,
                            onTap: _jump,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF81D4FA),
                                      Color(0xFFE0F7FA),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Pipes
                                    for (final pipe in _pipes) ...[
                                      // Top Pipe
                                      Positioned(
                                        left: pipe.x,
                                        top: 0,
                                        width: _pipeWidth,
                                        height: pipe.topHeight,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF66BB6A),
                                            border: Border.all(
                                              color: const Color(0xFF2E7D32),
                                              width: 2,
                                            ),
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Bottom Pipe
                                      Positioned(
                                        left: pipe.x,
                                        top: pipe.topHeight + pipe.gapHeight,
                                        bottom: 0,
                                        width: _pipeWidth,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF66BB6A),
                                            border: Border.all(
                                              color: const Color(0xFF2E7D32),
                                              width: 2,
                                            ),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    // Flappy Cube
                                    Positioned(
                                      left: 60.0,
                                      top: _cubeY.clamp(0.0, 400.0 - _cubeSize),
                                      width: _cubeSize,
                                      height: _cubeSize,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFCA28),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFFE65100),
                                            width: 2.5,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x33000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Eye
                                            Positioned(
                                              right: 6,
                                              top: 8,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_isPaused)
                                      Positioned.fill(
                                        child: ColoredBox(
                                          color: const Color(0x99000000),
                                          child: Center(
                                            child: Text(
                                              'PAUSED',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
      ),
    );
  }
}
