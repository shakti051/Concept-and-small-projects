import 'package:flutter/material.dart';

Future<bool?> showAsyncAppDialog({
  required BuildContext context,
  required String title,
  required Widget Function(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) contentBuilder,
  required Future<void> Function() onConfirm,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool barrierDismissible = false,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => _AsyncAppDialog(
      title: title,
      contentBuilder: contentBuilder,
      onConfirm: onConfirm,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
}

class _AsyncAppDialog extends StatefulWidget {
  const _AsyncAppDialog({
    required this.title,
    required this.contentBuilder,
    required this.onConfirm,
    required this.confirmText,
    required this.cancelText,
  });

  final String title;
  final Widget Function(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) contentBuilder;
  final Future<void> Function() onConfirm;
  final String confirmText;
  final String cancelText;

  @override
  State<_AsyncAppDialog> createState() => _AsyncAppDialogState();
}

class _AsyncAppDialogState extends State<_AsyncAppDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (_isLoading) return;

    // Validate before starting the async operation.
    if (!(_formKey.currentState?.validate() ?? true)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onConfirm();

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.contentBuilder(context, _formKey),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],

              if (_isLoading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () => Navigator.of(context).pop(false),
          child: Text(widget.cancelText),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(widget.confirmText),
        ),
      ],
    );
  }
}
