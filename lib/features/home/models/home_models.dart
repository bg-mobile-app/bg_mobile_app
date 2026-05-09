import 'package:flutter/material.dart';

class NavLinkItem {
  const NavLinkItem({
    required this.name,
    required this.href,
    required this.icon,
  });

  final String name;
  final String href;
  final dynamic icon;
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
  NavLinkItem(name: 'Home', href: '/', icon: Icons.home_rounded),
  NavLinkItem(name: 'Flight Booking', href: '', icon: Icons.flight_rounded),
  NavLinkItem(name: 'Work Abroad', href: '/filter?service_type=WORK_PERMIT', icon: Icons.work_rounded),
  NavLinkItem(name: 'Study Abroad', href: '', icon: Icons.menu_book_rounded),
  NavLinkItem(name: 'Hajj & Umrah', href: '', icon: Icons.mosque_rounded),
  NavLinkItem(name: 'Visa Services', href: '', icon: Icons.badge_rounded),
  NavLinkItem(name: 'Tour Packages', href: '', icon: Icons.public_rounded),
  NavLinkItem(name: 'Hotel Booking', href: '', icon: Icons.apartment_rounded),
];
