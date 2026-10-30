
import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/provider/content_provider.dart';

class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  final Set<int> _expandedQuestions = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final faqAsync = ref.watch(faqProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: faqAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 42),
                const SizedBox(height: 12),
                const Text(
                  'Unable to load FAQs.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(faqProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (response) {
          if (!response.success) {
            return const Center(
              child: Text('FAQs are unavailable.'),
            );
          }

          final faq = response.data;

          final categories = faq.categories
              .where((category) => category.questions.isNotEmpty)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                faq.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (faq.description.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  faq.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              if (categories.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No FAQs available.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

              ...categories.map((category) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category heading — no chips
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        bottom: 16,
                      ),
                      child: Text(
                        category.category,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                    ),

                    // Questions under this category
                    ...category.questions.map((question) {
                      final expanded =
                      _expandedQuestions.contains(question.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:  AppColors.blue.withOpacity(0.8),
                            width: expanded ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  if (expanded) {
                                    _expandedQuestions.remove(question.id);
                                  } else {
                                    _expandedQuestions.add(question.id);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        question.question,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colors.onSurface,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue

                                      ),
                                      child: Icon(
                                        expanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (expanded) ...[
                              Divider(
                                height: 1,
                                color: AppColors.blue.withOpacity(0.8),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  12,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    question.answer,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: colors.onSurfaceVariant,
                                      height: 1.8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 8),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
