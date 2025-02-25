import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../components/custom_button.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);

  OnboardingScreen({super.key});

  // onboarding page data
  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/illust1.png',
      'title': '学習プランや読書プラン',
      'description': '自分のプランを立ててみんなに共有しましょう',
    },
    {
      'image': 'assets/images/illust2.png',
      'title': '自分のゴールを達成しよう',
      'description': '達成したゴールをみんなに褒めてもらおう',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(
        totalPages: 3,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF3E7),
        body: Column(
          children: [
            Expanded(
              child: Consumer<OnboardingViewModel>(
                builder: (context, viewModel, _) {
                  return PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      viewModel.updatePage(index);
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return _buildPage(
                        context,
                        image: data['image']!,
                        title: data['title']!,
                        description: data['description']!,
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<OnboardingViewModel>(
              builder: (context, viewModel, _) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomButton(
                    text: viewModel.currentPage == _onboardingData.length - 1
                        ? 'スタート'
                        : '次へ',
                    onPressed: () {
                      if (viewModel.currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {required String image,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.all(
        16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 200,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
