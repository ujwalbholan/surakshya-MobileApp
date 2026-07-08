library ticket_status_card;

import 'package:flutter/material.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';
import 'package:suraksha/widgets/ticket_status_card/scalloped_icon_bezel.dart';
import 'package:suraksha/widgets/ticket_status_card/ticket_notch_clipper.dart';

enum TicketStatus { success, error, info }

const double kTicketStatusCardMinHeight = 88;
const double kTicketStatusCardPaddingH = S.md;
const double kTicketStatusCardPaddingV = S.md;
const double kTicketStatusCardContentGap = S.md;
const double kTicketStatusCardTitleGap = S.xs;
const double kTicketStatusCloseTapSize = 44;
const double kTicketStatusCloseIconSize = 20;
const double kTicketStatusIconSize = 24;
const double kTicketStatusInfoIconSize = 18;
const double kTicketStatusInfoTapPadding = S.xs;

const Color ticketInfoBezelStart = surakshaInfo;
const Color ticketInfoBezelEnd = Color(0xFF5D6D7E);

/// Ticket-shaped status overlay with scalloped icon bezel and dismiss control.
class TicketStatusCard extends StatelessWidget {
  const TicketStatusCard({
    super.key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.onDismiss,
    this.onInfoTap,
  });

  final TicketStatus status;
  final String title;
  final String subtitle;
  final VoidCallback onDismiss;
  final VoidCallback? onInfoTap;

  List<Color> get _bezelColors => switch (status) {
        TicketStatus.success => [statusGreen, surakshaSuccess],
        TicketStatus.error => [surakshaDanger, surakshaCrimsonLight],
        TicketStatus.info => [ticketInfoBezelStart, ticketInfoBezelEnd],
      };

  IconData get _statusIcon => switch (status) {
        TicketStatus.success => Icons.check_rounded,
        TicketStatus.error => Icons.error_outline_rounded,
        TicketStatus.info => Icons.info_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const TicketNotchClipper(),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [dashboardSheetBg, dashboardCard],
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kTicketStatusCardMinHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kTicketStatusCardPaddingH,
              vertical: kTicketStatusCardPaddingV,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScallopedIconBezel(
                  colors: _bezelColors,
                  child: Icon(
                    _statusIcon,
                    size: kTicketStatusIconSize,
                    color: surakshaForeground,
                  ),
                ),
                const SizedBox(width: kTicketStatusCardContentGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: SurakshaTypography.dashTitle.copyWith(
                                color: surakshaAuthText,
                              ),
                            ),
                          ),
                          if (onInfoTap != null)
                            GestureDetector(
                              onTap: onInfoTap,
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.all(
                                  kTicketStatusInfoTapPadding,
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  size: kTicketStatusInfoIconSize,
                                  color: surakshaSubtle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: kTicketStatusCardTitleGap),
                      Text(
                        subtitle,
                        style: SurakshaTypography.dashSubtitle.copyWith(
                          fontSize: 14,
                          color: surakshaMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: kTicketStatusCloseTapSize,
                  height: kTicketStatusCloseTapSize,
                  child: InkWell(
                    onTap: onDismiss,
                    customBorder: const CircleBorder(),
                    child: const Center(
                      child: Icon(
                        Icons.close,
                        size: kTicketStatusCloseIconSize,
                        color: surakshaSubtle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
