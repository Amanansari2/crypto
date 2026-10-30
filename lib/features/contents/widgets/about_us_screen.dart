
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/content_provider.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutAsync = ref.watch(aboutUsProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: aboutAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 42,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Unable to load About Us.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(aboutUsProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (response) {
          if (!response.success) {
            return const Center(
              child: Text('About Us is unavailable.'),
            );
          }

          final about = response.data;

          final sections = [...about.sections]
            ..sort(
                  (a, b) =>
                  a.sectionOrder.compareTo(b.sectionOrder),
            );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                about.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (about.description.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  about.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              ...sections.map((section) {
                final blocks = [...section.blocks]
                  ..sort(
                        (a, b) => a.order.compareTo(b.order),
                  );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      if (section.eyebrow != null &&
                          section.eyebrow!.trim().isNotEmpty) ...[
                        Text(
                          section.eyebrow!,
                          style:
                          theme.textTheme.labelMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],

                      Text(
                        section.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...blocks.map((block) {
                        final content = block.content.trim();

                        if (content.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        switch (block.type.toLowerCase()) {
                          case 'subheading':
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 6,
                              ),
                              child: Text(
                                content,
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );

                          case 'list_item':
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 9,
                                left: 4,
                              ),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 6),
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      size: 17,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      content,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            );

                          case 'text':
                          default:
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Text(
                                content,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(height: 1.6),
                              ),
                            );
                        }
                      }),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
