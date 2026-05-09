import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  NavLinkItem(name: 'Home', href: '/', icon: FontAwesomeIcons.house),
  NavLinkItem(name: 'Flight Booking', href: '', icon: FontAwesomeIcons.planeDeparture),
  NavLinkItem(name: 'Work Abroad', href: '/filter?service_type=WORK_PERMIT', icon: FontAwesomeIcons.briefcase),
  NavLinkItem(name: 'Study Abroad', href: '', icon: FontAwesomeIcons.graduationCap),
  NavLinkItem(name: 'Hajj & Umrah', href: '', icon: FontAwesomeIcons.kaaba),
  NavLinkItem(name: 'Visa Services', href: '', icon: FontAwesomeIcons.passport),
  NavLinkItem(name: 'Tour Packages', href: '', icon: FontAwesomeIcons.earthAsia),
  NavLinkItem(name: 'Hotel Booking', href: '', icon: FontAwesomeIcons.hotel),
];
