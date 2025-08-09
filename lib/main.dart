import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant/bloc/auth/auth_block.dart';
import 'package:restaurant/bloc/cities/city_bloc.dart';
import 'package:restaurant/bloc/cities/city_event.dart';
import 'package:restaurant/bloc/location/location_bloc.dart';
import 'package:restaurant/data/repositories/auth_repository.dart';
import 'package:restaurant/data/repositories/cities_location_repository.dart';
import 'package:restaurant/data/repositories/location_repository.dart';
import 'package:restaurant/presentation/screens/location_screen.dart';
import 'package:restaurant/presentation/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepository()),
        ),
        BlocProvider(create: (_) => CityBloc(CityRepository())..add(LoadCities()),),
        BlocProvider(
      create: (_) => LocationBloc(LocationRepository()),
    ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF2F9F2),
        fontFamily: 'Roboto',
      ),
      home: const AppStartScreen(),
    );
  }
}

class AppStartScreen extends StatelessWidget {
  const AppStartScreen({super.key});

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const LocationScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
