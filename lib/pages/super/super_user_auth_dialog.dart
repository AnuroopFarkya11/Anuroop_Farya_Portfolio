import 'package:flutter/material.dart';

class SuperUserDialog extends StatefulWidget {
  const SuperUserDialog({Key? key}) : super(key: key);

  @override
  State<SuperUserDialog> createState() => _SuperUserDialogState();
}

class _SuperUserDialogState extends State<SuperUserDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final String correctPassword = "SuperSecret"; // Replace with your actual password
  String? errorMessage;
  bool _isPasswordVisible = false;

  void _authenticate() {
    setState(() {
      if (_passwordController.text == correctPassword) {
        Navigator.pop(context, true); // Close dialog and return success
      } else {
        errorMessage = "Incorrect password. Please try again.";
      }
    });
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
