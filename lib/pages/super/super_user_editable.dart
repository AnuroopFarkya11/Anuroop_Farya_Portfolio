import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/provider/super.dart';

class SuperUserEditable extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onTap;

  const SuperUserEditable({required this.child, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuperUser = ref.watch(isSuperUserProvider);

    return GestureDetector(
      onTap: isSuperUser ? onTap : null,
      child: child,
    );
  }
}
