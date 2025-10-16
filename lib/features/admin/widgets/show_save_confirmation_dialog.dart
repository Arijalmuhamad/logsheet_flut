import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showSaveConfirmationDialog<T>(
  BuildContext context, {
  required bool Function(T provider) providerSelector,
  required Future<void> Function() onConfirm,
  String title = "Konfirmasi Input",
  String content = "Apakah Anda Yakin?",
}) async {
  final provider = Provider.of<T>(context, listen: false);
  bool isLoading = providerSelector(provider);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
              isLoading
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : TextButton(
                    onPressed: () async {
                      await onConfirm();
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: const Text("Yes"),
                  ),
            ],
          );
        },
      );
    },
  );
}
