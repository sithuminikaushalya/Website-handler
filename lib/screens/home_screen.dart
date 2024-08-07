import 'package:flutter/material.dart';
import 'gold_list_screen.dart';
import '../widgets/ad_banner.dart';
import 'dart:async';
import 'wave_painter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _animated = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation periodically
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        _animated = !_animated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background with curved design
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 190, 166, 5),
                  Color.fromARGB(255, 253, 211, 156)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomPaint(
              painter: WavePainter(),
              child: Container(height: 300),
            ),
          ),
          // Main content
          Column(
            children: [
              AppBar(
                title: Text('Gold Rate Manager'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              SizedBox(height: 10), // Small gap below the AppBar
              Center(
                child: Text(
                  'Welcome to Gold Rate Manager',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20), // Small gap below the welcome text
              Expanded(
                child: Center(
                  child: AnimatedContainer(
                    duration: Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    width: _animated ? 200 : 150,
                    height: _animated ? 200 : 150,
                    child: ClipOval(
                      child: Image.asset('assets/gold_image.jpg',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovering = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering = false;
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoldListScreen()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      decoration: BoxDecoration(
                        color: _isHovering
                            ? Color.fromARGB(255, 179, 210, 228)
                            : Color.fromARGB(255, 209, 199, 132),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          if (_isHovering)
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            )
                        ],
                      ),
                      child: Text(
                        'View Gold Rates',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some gap below the button
              AdBanner(), // Placeholder for an advertisement
            ],
          ),
        ],
      ),
    );
  }
}
