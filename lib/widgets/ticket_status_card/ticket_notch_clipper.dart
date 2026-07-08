library ticket_notch_clipper;

import 'package:flutter/material.dart';

/// Default corner radius for the ticket card shape.
const double kTicketNotchCornerRadius = 22;

/// Default semicircular notch radius on the left and right edges.
const double kTicketNotchRadius = 15;

/// Clips a rounded rectangle with semicircular notches centered on the left
/// and right edges — the ticket-style silhouette used by [TicketStatusCard].
class TicketNotchClipper extends CustomClipper<Path> {
  const TicketNotchClipper({
    this.cornerRadius = kTicketNotchCornerRadius,
    this.notchRadius = kTicketNotchRadius,
  });

  final double cornerRadius;
  final double notchRadius;

  @override
  Path getClip(Size size) {
    final r = cornerRadius;
    final nr = notchRadius;
    final w = size.width;
    final h = size.height;
    final centerY = h / 2;

    return Path()
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
      ..lineTo(w, centerY - nr)
      ..arcToPoint(
        Offset(w, centerY + nr),
        radius: Radius.circular(nr),
        clockwise: false,
      )
      ..lineTo(w, h - r)
      ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
      ..lineTo(r, h)
      ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
      ..lineTo(0, centerY + nr)
      ..arcToPoint(
        Offset(0, centerY - nr),
        radius: Radius.circular(nr),
        clockwise: false,
      )
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..close();
  }

  @override
  bool shouldReclip(covariant TicketNotchClipper oldClipper) =>
      cornerRadius != oldClipper.cornerRadius ||
      notchRadius != oldClipper.notchRadius;
}
