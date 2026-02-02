import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quran_bloc.dart';
import '../bloc/quran_event.dart';
import '../bloc/quran_state.dart';
import 'juz_detail_page.dart';
import '../../../../core/utils/app_colors.dart';

class JuzPage extends StatefulWidget {
  const JuzPage({super.key});

  @override
  State<JuzPage> createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuranBloc>().add(LoadJuzList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranBloc, QuranState>(
      buildWhen: (p, c) =>
          p.juzList != c.juzList || p.loadingJuz != c.loadingJuz,
      builder: (context, state) {
        if (state.loadingJuz && state.juzList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.juzList.isEmpty) {
          return const Center(child: Text('Tidak ada data juz'));
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<QuranBloc>().add(LoadJuzList());
          },
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: state.juzList.length,
            itemBuilder: (_, i) {
              final juz = state.juzList[i];

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<QuranBloc>(),
                        child: JuzDetailPage(juz: juz),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AppColors.premiumGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          Icons.grid_view_rounded,
                          size: 80,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$juz',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Juz',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
