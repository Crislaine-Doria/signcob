import 'package:flutter/material.dart';
import '../theme/signcob_theme.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!compact || constraints.maxWidth >= 180) ...[
          Container(
            padding: EdgeInsets.all(compact ? 8 : 12),
            decoration: BoxDecoration(
              color: SignCobColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: SignCobColors.gold.withValues(alpha: .6),
              ),
            ),
            child: Icon(
              Icons.balance_outlined,
              color: SignCobColors.gold,
              size: compact ? 24 : 30,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SignCob',
                style: TextStyle(
                  color: SignCobColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 22 : 28,
                  letterSpacing: -.5,
                ),
              ),
              const Text(
                'ADVOCACIA',
                style: TextStyle(
                  color: SignCobColors.gold,
                  fontSize: 10,
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
