import 'package:flutter/material.dart';

class NavLinkItem {
  const NavLinkItem({
    required this.name,
    required this.href,
    required this.icon,
  });

  final String name;
  final String href;
  final IconData icon;
}

class WorkPermitItem {
  const WorkPermitItem({
    required this.title,
    required this.slug,
    required this.image,
    required this.customerPrice,
    required this.agentPrice,
    required this.countryName,
    required this.countryFlag,
    required this.workType,
    required this.selectionType,
    required this.createdAt,
  });

  final String title;
  final String slug;
  final String image;
  final int customerPrice;
  final int agentPrice;
  final String countryName;
  final String countryFlag;
  final String workType;
  final String selectionType;
  final DateTime createdAt;
}

const List<NavLinkItem> navLinkData = [
  NavLinkItem(name: 'Home', href: '/', icon: Icons.home),
  NavLinkItem(name: 'Flight Booking', href: '', icon: Icons.flight_takeoff),
  NavLinkItem(name: 'Work Abroad', href: '/filter?service_type=WORK_PERMIT', icon: Icons.handshake_outlined),
  NavLinkItem(name: 'Study Abroad', href: '', icon: Icons.school_outlined),
  NavLinkItem(name: 'Hajj & Umrah', href: '', icon: Icons.mosque_outlined),
  NavLinkItem(name: 'Visa Services', href: '', icon: Icons.volunteer_activism_outlined),
  NavLinkItem(name: 'Tour Packages', href: '', icon: Icons.public_outlined),
  NavLinkItem(name: 'Hotel Booking', href: '', icon: Icons.hotel_outlined),
];
