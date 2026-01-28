import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../quran/presentation/pages/quran_home_page.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../domain/entities/home_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigate(BuildContext context, HomeMenuType type) {
    switch (type) {
      case HomeMenuType.quran:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuranHomePage()),
        );
        break;
      case HomeMenuType.lastRead:
        // TODO: Handle this case.
        throw UnimplementedError();
      case HomeMenuType.search:
        // TODO: Handle this case.
        throw UnimplementedError();
      case HomeMenuType.prayer:
        // TODO: Handle this case.
        throw UnimplementedError();
      case HomeMenuType.settings:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(LoadHomeMenus());

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: state.menus.map((menu) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: OutlinedButton(
                      onPressed: () =>
                          _navigate(context, menu.type),
                      style: OutlinedButton.styleFrom(
                        minimumSize:
                            const Size(double.infinity, 52),
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: Text(
                        menu.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
