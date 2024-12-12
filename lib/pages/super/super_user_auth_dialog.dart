import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/provider/super.dart';
class SuperUserDialog extends ConsumerStatefulWidget {
  const SuperUserDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SuperUserDialog> createState() => _SuperUserDialogState();
}

class _SuperUserDialogState extends ConsumerState<SuperUserDialog> {
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;
  bool _isPasswordVisible = false;

  void _authenticate() {
    final notifier = ref.read(isSuperUserProvider.notifier);

    try {
      notifier.loginAsSuperUser(_passwordController.text);
      Navigator.pop(context, true); // Close dialog and return success
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Super User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your password to proceed:'),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Cancel action
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _authenticate,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

void showSuperUserDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => const SuperUserDialog(),
  );

  if (result == true) {
    // Authentication successful
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication Successful!')),
    );
  } else if (result == false) {
    // Dialog canceled
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Authentication Canceled')),
    );
  }
}
