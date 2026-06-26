import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitforge/core/theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _NavTab(icon: FontAwesomeIcons.house, activeIcon: FontAwesomeIcons.house, label: 'Home', path: '/home'),
    _NavTab(icon: FontAwesomeIcons.stopwatch, activeIcon: FontAwesomeIcons.stopwatch, label: 'Timer', path: '/timer'),
    _NavTab(icon: FontAwesomeIcons.utensils, activeIcon: FontAwesomeIcons.utensils, label: 'Diet', path: '/diet'),
    _NavTab(icon: FontAwesomeIcons.chartLine, activeIcon: FontAwesomeIcons.chartLine, label: 'Progress', path: '/progress'),
    _NavTab(icon: FontAwesomeIcons.dumbbell, activeIcon: FontAwesomeIcons.dumbbell, label: 'Programs', path: '/programs'),
  ];

  int _locationToIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBody: true,
      body: child,
      bottomNavigationBar: _FloatingNavBar(
        tabs: _tabs,
        currentIndex: currentIndex,
        onTap: (i) {
          HapticFeedback.lightImpact();
          context.go(_tabs[i].path);
        },
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final List<_NavTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.darkCard.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.darkBorderBright.withValues(alpha: 0.6),
                  width: 1,
                ),
                boxShadow: AppShadows.navBar,
              ),
              child: Stack(
                children: [
                  // Sheen highlight on top edge
                  Positioned(
                    top: 0,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Nav items
                  Row(
                    children: List.generate(tabs.length, (i) {
                      return Expanded(
                        child: _NavItem(
                          tab: tabs[i],
                          isSelected: i == currentIndex,
                          onTap: () => onTap(i),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final _NavTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.isSelected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  gradient: widget.isSelected
                      ? AppGradients.primarySoft
                      : null,
                  color: widget.isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: widget.isSelected
                      ? AppShadows.glow(AppColors.primary, intensity: 0.4)
                      : null,
                ),
                child: FaIcon(
                  widget.tab.icon,
                  size: 16,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 3),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: widget.isSelected
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: widget.isSelected
                      ? AppColors.primary
                      : AppColors.textMuted,
                ),
                child: Text(widget.tab.label),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavTab {
  final FaIconData icon;
  final FaIconData activeIcon;
  final String label;
  final String path;
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });
}
