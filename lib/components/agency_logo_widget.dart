import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Widget that displays actual transit agency logos
/// Uses real logo images for VTA, Muni, SamTrans, Caltrain, BART
class AgencyLogoWidget extends StatelessWidget {
  final String agencyId;
  final double size;

  const AgencyLogoWidget({super.key, required this.agencyId, this.size = 48});

  String _getLogoAsset(String id) {
    final String normalizedId = id.toUpperCase().trim();

    switch (normalizedId) {
      case 'VTA':
        return 'assets/images/vta.png';
      case 'MUNI':
        return 'assets/images/muni.webp';
      case 'SAMTRANS':
        return 'assets/images/samtrans.png';
      case 'CALTRAIN':
        return 'assets/images/caltrain.png';
      case 'BART':
        return 'assets/images/bart.png';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoAsset = _getLogoAsset(agencyId);

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: logoAsset.isNotEmpty
          ? Image.asset(
              logoAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: size * 0.5,
                  color: kFcMuted,
                );
              },
            )
          : Icon(Icons.directions_transit, size: size * 0.5, color: kFcMuted),
    );
  }
}
