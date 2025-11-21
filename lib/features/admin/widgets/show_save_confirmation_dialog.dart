import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showSaveConfirmationDialog<T>(
  BuildContext context, {
  required bool Function(T provider) providerSelector,
  required Future<void> Function() onConfirm,
  String title = "Konfirmasi Input",
  String content = "Apakah Anda Yakin?",
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Consumer<T>(
        builder: (context, provider, _) {
          final isLoading = providerSelector(provider);
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed:
                    isLoading
                        ? null
                        : () {
                          Navigator.of(context).pop();
                        },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await onConfirm();
                  if (context.mounted) Navigator.of(context).pop();
                },
                child:
                    isLoading
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text("Yes"),
              ),
            ],
          );
        },
      );
    },
  );
}
