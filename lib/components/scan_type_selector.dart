import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:text_scanner/providers/providers.dart';

class ScanTypeSelector extends HookConsumerWidget {
  const ScanTypeSelector({super.key});

  void _showTypeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => const ScanTypePicker(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedScanTypeProvider);
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: .6,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2.0,
          color: theme.colorScheme.primary.withValues(alpha: .3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: theme.buttonTheme.height * 1.15,
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () => _showTypeSelection(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ...[
                  Icon(
                    selectedType.icon,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(selectedType.label),
                ],
                // const SizedBox(width: 8),
                const Spacer(),
                const Icon(
                  FluentIcons.chevron_up_down_16_regular,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScanTypePicker extends HookConsumerWidget {
  const ScanTypePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedScanTypeProvider);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Row(
          //     children: [
          //       const Text(
          //         'Select Scan Type',
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       // const Spacer(),
          //       // IconButton(
          //       //   icon: const Icon(Icons.close),
          //       //   onPressed: () => Navigator.pop(context),
          //       // ),
          //     ],
          //   ),
          // ),
          // const Divider(height: 1),
          ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            shrinkWrap: true,
            itemCount: ScanType.values.length,
            itemBuilder: (context, index) {
              final type = ScanType.values[index];
              final isSelected = type == selectedType;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    ref
                        .read(selectedScanTypeProvider.notifier)
                        .selectType(type);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.1),
                        width: isSelected ? 1.3 : .3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            type.icon,
                            color:
                                isSelected ? theme.colorScheme.primary : null,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.label,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  type.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withValues(alpha: .5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              FluentIcons.checkmark_circle_24_filled,
                              color: theme.colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
