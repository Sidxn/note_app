import 'package:app_note/features/notes/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/colorScheme.dart';

class CustomizationBar extends StatelessWidget {
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final TextAlign textAlign;

  final ValueChanged<double> onFontSizeChanged;
  final VoidCallback onBoldToggled;
  final VoidCallback onItalicToggled;
  final ValueChanged<TextAlign> onAlignChanged;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final NoteController noteController;
  final VoidCallback pushUndo;

  const CustomizationBar({
    super.key,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.textAlign,
    required this.onFontSizeChanged,
    required this.onBoldToggled,
    required this.onItalicToggled,
    required this.onAlignChanged,
    required this.onUndo,
    required this.onRedo,
    required this.noteController,
    required this.pushUndo,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _icon(
              icon: Icons.undo,
              onPressed: noteController.canUndo ? onUndo : null,
              color: noteController.canUndo
                  ? _activeColor(context)
                  : _disabledColor(context),
              tooltip: 'Undo',
            ),
            _icon(
              icon: Icons.redo,
              onPressed: noteController.canRedo ? onRedo : null,
              color: noteController.canRedo
                  ? _activeColor(context)
                  : _disabledColor(context),
              tooltip: 'Redo',
            ),
            _divider(context),

            _icon(
              icon: Icons.format_size,
              onPressed: () => _showFontSizeDialog(context),
              color: _activeColor(context),
              tooltip: 'Font Size',
            ),
            _icon(
              icon: isBold ? Icons.format_bold : Icons.format_bold_outlined,
              onPressed: () {
                onBoldToggled();
                pushUndo();
              },
              color: isBold ? _activeColor(context) : _inactiveColor(context),
              tooltip: 'Bold',
            ),
            _icon(
              icon: isItalic ? Icons.format_italic : Icons.format_italic_outlined,
              onPressed: () {
                onItalicToggled();
                pushUndo();
              },
              color: isItalic ? _activeColor(context) : _inactiveColor(context),
              tooltip: 'Italic',
            ),
            _divider(context),

            _icon(
              icon: Icons.format_align_left,
              onPressed: () {
                onAlignChanged(TextAlign.start);
                pushUndo();
              },
              color: textAlign == TextAlign.start
                  ? _activeColor(context)
                  : _inactiveColor(context),
              tooltip: 'Align Left',
            ),
            _icon(
              icon: Icons.format_align_center,
              onPressed: () {
                onAlignChanged(TextAlign.center);
                pushUndo();
              },
              color: textAlign == TextAlign.center
                  ? _activeColor(context)
                  : _inactiveColor(context),
              tooltip: 'Align Center',
            ),
            _icon(
              icon: Icons.format_align_right,
              onPressed: () {
                onAlignChanged(TextAlign.end);
                pushUndo();
              },
              color: textAlign == TextAlign.end
                  ? _activeColor(context)
                  : _inactiveColor(context),
              tooltip: 'Align Right',
            ),
          ],
        ),
      ),
    );
  }

  /// Icon builder
  Widget _icon({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    required String tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }

  /// Divider between sections
  Widget _divider(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Theme.of(context).dividerColor.withOpacity(0.4),
    );
  }

  /// Font size dialog
  void _showFontSizeDialog(BuildContext context) {
    double tempFontSize = fontSize;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Font Size'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: tempFontSize,
                  min: 12,
                  max: 30,
                  divisions: 18,
                  label: '${tempFontSize.toInt()}',
                  onChanged: (value) => setState(() => tempFontSize = value),
                ),
                Text('Size: ${tempFontSize.toInt()}', style: const TextStyle(fontSize: 14)),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onFontSizeChanged(tempFontSize);
              pushUndo();
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  /// Color helpers for theming
  Color _activeColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.primaryBlue;
  }

  Color _inactiveColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : AppColors.textGray;
  }

  Color _disabledColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white38
        : Colors.grey;
  }
}
