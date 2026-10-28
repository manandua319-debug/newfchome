import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/index.dart';

/// Port of the 21st.dev "Bottom Nav Bar" (arunachalam/bottom-nav-bar):
/// pill container, only the active tab shows its label, spring-in on mount.
class FcNavItem {
  const FcNavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

class FcBottomNavBar extends StatelessWidget {
  const FcBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<FcNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _labelWidth = 64;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: ((t - 0.9) / 0.1).clamp(0.0, 1.0),
        child: Transform.scale(scale: t, child: child),
      ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: theme.alternate),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 2),
              _tab(context, theme, i),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, FlutterFlowTheme theme, int i) {
    final item = items[i];
    final active = i == currentIndex;
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 40,
          constraints: const BoxConstraints(minWidth: 44),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: active
                ? theme.primary.withOpacity(0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 22,
                color: active ? theme.primary : theme.secondaryText,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: active ? _labelWidth : 0,
                margin: EdgeInsets.only(left: active ? 8 : 0),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 190),
                  opacity: active ? 1 : 0,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom nav wired to the app's routes for either audience.
/// Tabs: Home, Shelters, Food, Health, Supplies.
class FcAudienceNav extends StatelessWidget {
  const FcAudienceNav({super.key, required this.minors, required this.current});

  final bool minors;
  final int current;

  static const _items = [
    FcNavItem('Home', Icons.home_outlined),
    FcNavItem('Shelter', Icons.night_shelter_outlined),
    FcNavItem('Food', Icons.restaurant_outlined),
    FcNavItem('Health', Icons.health_and_safety_outlined),
    FcNavItem('Supplies', Icons.support_outlined),
  ];

  String _route(int i) {
    if (minors) {
      return const [
        'MainPageMinors',
        'SheltersMinors',
        'FoodMinors',
        'HealthMinors',
        'TentsMinors',
      ][i];
    }
    return [
      'MainPageTAY',
      SheltersTAYWidget.routeName,
      FoodTAYWidget.routeName,
      HealthTAYWidget.routeName,
      TentsTAYWidget.routeName,
    ][i];
  }

  void _go(BuildContext context, int i) {
    if (i == current) return;
    if (i == 0) {
      context.goNamed(_route(0));
    } else if (current == 0) {
      context.pushNamed(_route(i));
    } else {
      context.pushReplacementNamed(_route(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Center(
          heightFactor: 1,
          child: FcBottomNavBar(
            items: _items,
            currentIndex: current,
            onTap: (i) => _go(context, i),
          ),
        ),
      ),
    );
  }
}

/// Port of the 21st.dev "Location Card" (lavikatiyar/location-card):
/// rounded-2xl bordered card, title + subtitle left, pill button right whose
/// label slides out for the send icon on press. Image is optional because the
/// resource lists have no photos.
class FcLocationCard extends StatefulWidget {
  const FcLocationCard({
    super.key,
    required this.title,
    this.subtitle,
    this.detail,
    this.imageUrl,
    this.directionsQuery,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? detail;
  final String? imageUrl;
  final String? directionsQuery;
  final VoidCallback onTap;

  @override
  State<FcLocationCard> createState() => _FcLocationCardState();
}

class _FcLocationCardState extends State<FcLocationCard> {
  bool _pressed = false;
  bool _btn = false;

  Future<void> _directions() async {
    final q = widget.directionsQuery;
    if (q == null || q.isEmpty) return;
    setState(() => _btn = true);
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': q,
    });
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (mounted) setState(() => _btn = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.alternate),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.imageUrl != null)
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(widget.imageUrl!, fit: BoxFit.cover),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                            if (widget.detail != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.detail!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.directionsQuery != null) ...[
                        const SizedBox(width: 12),
                        _pill(theme),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill(FlutterFlowTheme theme) {
    return Semantics(
      button: true,
      label: 'Get directions to ${widget.title}',
      child: GestureDetector(
        onTap: _directions,
        child: Container(
          width: 128,
          height: 40,
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _btn ? 0 : 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Directions',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.info,
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                alignment: _btn ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.send_rounded, size: 16, color: theme.info),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Port of 21st.dev "Tracker Card" (kavikatiyar/tracker-card-1) timeline:
/// icon-only steps on a rail, title + link-style description, staggered
/// spring-in. Maps the ttRequests status onto four steps.
class FcTracker extends StatelessWidget {
  const FcTracker({super.key, required this.status});

  final String status;

  static const _titles = [
    'Request Sent',
    'Waiting for Staff',
    'Preparing Your Pass',
    'Pass Sent',
  ];
  static const _descriptions = [
    'We got your request',
    'A staff member will pick it up',
    'Getting your pass ready',
    'Check your texts for the pass',
  ];

  // 0 = completed, 1 = active, 2 = pending
  List<int> _states() {
    switch (status) {
      case 'sent':
        return [0, 0, 0, 0];
      case 'purchased':
      case 'processing':
        return [0, 0, 1, 2];
      default:
        return [0, 1, 2, 2];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final states = _states();
    const green = Color(0xFF22C55E);

    Widget step(int i) {
      final st = states[i];
      final icon = st == 0
          ? Icons.check_circle_outline_rounded
          : st == 1
          ? Icons.edit_outlined
          : Icons.description_outlined;
      final iconColor = st == 0
          ? green
          : st == 1
          ? theme.primary
          : theme.secondaryText;
      final last = i == _titles.length - 1;
      return Padding(
            padding: EdgeInsets.only(bottom: last ? 0 : 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (!last)
                  Positioned(
                    left: 15,
                    top: 40,
                    bottom: -8,
                    width: 2,
                    child: ColoredBox(color: st == 0 ? green : theme.alternate),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.secondaryBackground,
                        ),
                        child: Icon(icon, size: 20, color: iconColor),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 6, bottom: last ? 0 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _titles[i],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                            Text(
                              _descriptions[i],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: st == 2
                                    ? theme.secondaryText
                                    : theme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          .animate(delay: (200 * i).ms)
          .fadeIn(duration: 300.ms)
          .moveY(
            begin: 20,
            end: 0,
            duration: 450.ms,
            curve: Curves.easeOutBack,
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (var i = 0; i < _titles.length; i++) step(i)],
    );
  }
}

/// Port of 21st.dev "Cards Grid" card (kavikatiyar/cards-grid): bordered
/// rounded card, icon + title + muted subtitle, up-right arrow that nudges on
/// hover, scale on hover/press, staggered entrance.
class FcResourceCard extends StatefulWidget {
  const FcResourceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.index = 0,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int index;

  @override
  State<FcResourceCard> createState() => _FcResourceCardState();
}

class _FcResourceCardState extends State<FcResourceCard> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: AnimatedScale(
            scale: _down ? 0.98 : (_hover ? 1.03 : 1),
            duration: const Duration(milliseconds: 150),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => setState(() => _down = true),
              onTapCancel: () => setState(() => _down = false),
              onTapUp: (_) => setState(() => _down = false),
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.alternate),
                  boxShadow: [
                    BoxShadow(
                      color: Color(_hover ? 0x1A000000 : 0x0D000000),
                      blurRadius: _hover ? 8 : 3,
                      offset: Offset(0, _hover ? 4 : 1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryText,
                            ),
                          ),
                          Text(
                            widget.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: theme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 300),
                      offset: _hover ? const Offset(0.2, -0.2) : Offset.zero,
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        size: 20,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: (100 * widget.index).ms)
        .fadeIn(duration: 300.ms)
        .moveY(begin: 20, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
