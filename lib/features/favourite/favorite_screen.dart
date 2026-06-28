import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';
import '../../common/theme/app_palette.dart';
import '../../common/theme/app_text_styles.dart';
import '../home/dashboard_screen.dart';
import '../home/widgets/work_permit_card.dart';
import 'services/favorite_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  List<FavoriteWorkPermit> _favorites = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _favoriteService.getFavorites();
      if (mounted) {
        setState(() {
          _favorites = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load favorite list.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPageScaffold(
      currentHref: '/dashboard/favorites',
      child: Container(
        color: AppPalette.pageBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _breadcrumb(),
                const SizedBox(height: 8),
                Text(
                  'My Favorites (${_favorites.length})',
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'List of your saved and favorited work permits',
                  style: AppTextStyles.body2.copyWith(
                    color: AppPalette.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  _errorState()
                else
                  Skeletonizer(
                    enabled: _isLoading,
                    child: _favorites.isEmpty && !_isLoading
                        ? _emptyState()
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: _isLoading ? 3 : _favorites.length,
                            itemBuilder: (context, index) {
                              if (_isLoading) {
                                return const SizedBox(
                                  height: 200,
                                  child: Card(child: Center(child: CircularProgressIndicator())),
                                );
                              }
                              final fav = _favorites[index];
                              return WorkPermitCard(
                                item: fav.workPermit,
                                brandBlue: AppPalette.brandBlue,
                                onViewDetails: () => context.push('/search/details', extra: fav.workPermit),
                                formatBdt: (val) => '৳ $val',
                                timeAgo: (val) => '',
                              );
                            },
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _breadcrumb() {
    return BreadCrumb(
      items: <BreadCrumbItem>[
        BreadCrumbItem(
          content: Text(
            'Dashboard',
            style: AppTextStyles.caption.copyWith(color: AppPalette.textMuted),
          ),
        ),
        BreadCrumbItem(
          content: Text(
            'Favorites',
            style: AppTextStyles.caption.copyWith(
              color: AppPalette.brandBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      divider: const Icon(
        Icons.chevron_right_rounded,
        size: 16,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.borderSoftBlue),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            size: 60,
            color: AppPalette.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites found',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppPalette.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Work permits you save will show up here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body2.copyWith(color: AppPalette.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 14),
          Text(
            _error ?? 'Failed to load favorites',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadFavorites,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.brandBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
