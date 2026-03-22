import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  MODEL
// ─────────────────────────────────────────────

class ArtistProfile {
  final String name;
  final String tagline;
  final String bio;
  final String bannerUrl;
  final String avatarUrl;
  final int followers;
  final int following;
  final int posts;
  final int activeGigs;
  final String spotifyUrl;
  final String instagramUrl;
  final String soundcloudUrl;
  final List<GigItem> activeGigs2;
  final List<CatalogItem> catalog;
  final List<String> postImages;

  const ArtistProfile({
    required this.name,
    required this.tagline,
    required this.bio,
    required this.bannerUrl,
    required this.avatarUrl,
    required this.followers,
    required this.following,
    required this.posts,
    required this.activeGigs,
    required this.spotifyUrl,
    required this.instagramUrl,
    required this.soundcloudUrl,
    required this.activeGigs2,
    required this.catalog,
    required this.postImages,
  });
}

class GigItem {
  final String title;
  final String imageUrl;
  GigItem({required this.title, required this.imageUrl});
}

class CatalogItem {
  final String title;
  final String imageUrl;
  final double price;
  CatalogItem({required this.title, required this.imageUrl, required this.price});
}

// ─────────────────────────────────────────────
//  DUMMY DATA  (swap with real API later)
// ─────────────────────────────────────────────

final _dummyProfile = ArtistProfile(
  name: 'Teezy',
  tagline: 'Artist · Producer · Songwriter · DJ',
  bio: 'OCTANE coming out this Friday! 🔥',
  bannerUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
  avatarUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200',
  followers: 67000,
  following: 110,
  posts: 3341,
  activeGigs: 2,
  spotifyUrl: 'https://spotify.com',
  instagramUrl: 'https://instagram.com',
  soundcloudUrl: 'https://soundcloud.com',
  activeGigs2: [
    GigItem(
      title: 'OCTANE Tour',
      imageUrl: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=200',
    ),
    GigItem(
      title: 'Tomorrowland',
      imageUrl: 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=200',
    ),
  ],
  catalog: [
    CatalogItem(
      title: 'TRAVIS x Kanye',
      imageUrl: 'https://images.unsplash.com/photo-1493676304819-0d7a8d026dcf?w=300',
      price: 29.99,
    ),
    CatalogItem(
      title: 'Drake Type Beat',
      imageUrl: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=300',
      price: 39.99,
    ),
    CatalogItem(
      title: 'Carti X Cash',
      imageUrl: 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89?w=300',
      price: 29.99,
    ),
  ],
  postImages: [
    'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?w=400',
    'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400',
    'https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=400',
    'https://images.unsplash.com/photo-1502680390469-be75c86b636f?w=400',
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
    'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
  ],
);

// ─────────────────────────────────────────────
//  THEME CONSTANTS
// ─────────────────────────────────────────────

class AMColors {
  static const bg = Color(0xFF0A0A0A);
  static const surface = Color(0xFF141414);
  static const card = Color(0xFF1C1C1E);
  static const border = Color(0xFF2A2A2A);
  static const accent = Color(0xFF0094FF);      // ArtistMatch blue
  static const accentDim = Color(0xFF00305A);   // dark blue for button backgrounds
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF888888);
  static const spotify = Color(0xFF1DB954);
  static const instagram = Color(0xFFE1306C);
  static const soundcloud = Color(0xFFFF5500);
}

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scroll;
  bool _headerCollapsed = false;
  bool _linksExpanded = false;

  static const double _collapseOffset = 160;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()
      ..addListener(() {
        final collapsed = _scroll.offset > _collapseOffset;
        if (collapsed != _headerCollapsed) {
          setState(() => _headerCollapsed = collapsed);
        }
      });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _dummyProfile;
    return Scaffold(
      backgroundColor: AMColors.bg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(child: _HeroBanner(profile: p)),
              SliverToBoxAdapter(child: _StatsRow(profile: p)),
              SliverToBoxAdapter(child: _IdentityStrip(profile: p)),
              SliverToBoxAdapter(
                child: _BioSection(
                  profile: p,
                  expanded: _linksExpanded,
                  onToggleLinks: () =>
                      setState(() => _linksExpanded = !_linksExpanded),
                ),
              ),
              if (_linksExpanded)
                SliverToBoxAdapter(child: _SocialLinks(profile: p)),
              const SliverToBoxAdapter(child: _Divider()),
              SliverToBoxAdapter(
                child: _SectionHeader(title: 'Active Gigs', count: p.activeGigs),
              ),
              SliverToBoxAdapter(child: _GigsRow(gigs: p.activeGigs2)),
              const SliverToBoxAdapter(child: _Divider()),

              // ── PRODUCER CATALOG COMMENTED OUT ──────
              // To re-enable: remove the /* and */ below
              /*
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Producer Catalog',
                  trailing: _ChipButton(label: 'View All', onTap: () {}),
                ),
              ),
              SliverToBoxAdapter(child: _CatalogRow(items: p.catalog)),
              const SliverToBoxAdapter(child: _Divider()),
              */

              SliverToBoxAdapter(
                child: _SectionHeader(title: 'Posts', count: p.posts),
              ),
              _PostsGrid(images: p.postImages),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          _StickyTopBar(collapsed: _headerCollapsed, name: p.name),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGETS
// ─────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final ArtistProfile profile;
  const _HeroBanner({required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            bottom: 40,
            child: _NetworkImage(url: profile.bannerUrl, fit: BoxFit.cover),
          ),
          Positioned(
            left: 0, right: 0, bottom: 40, height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AMColors.bg],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AMColors.accent, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: AMColors.accent.withOpacity(0.35),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: ClipOval(
                      child: _NetworkImage(url: profile.avatarUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      color: AMColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ArtistProfile profile;
  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    String fmt(int n) {
      if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
      if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}k';
      return n.toString();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AMColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AMColors.border),
      ),
      child: Row(
        children: [
          _StatCell(value: fmt(profile.followers), label: 'Followers'),
          _StatDivider(),
          _StatCell(value: fmt(profile.following), label: 'Following'),
          _StatDivider(),
          _StatCell(value: fmt(profile.posts), label: 'Posts'),
          _StatDivider(),
          _StatCell(value: profile.activeGigs.toString(), label: 'Active Gigs'),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value, label;
  const _StatCell({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AMColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AMColors.textSecondary, fontSize: 10)),
          ],
        ),
      );
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: AMColors.border);
}

class _IdentityStrip extends StatelessWidget {
  final ArtistProfile profile;
  const _IdentityStrip({required this.profile});
  @override
  Widget build(BuildContext context) {
    final roles = profile.tagline.split(' · ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: roles
            .map(
              (r) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AMColors.accentDim,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AMColors.accent.withOpacity(0.5)),
                ),
                child: Text(r,
                    style: const TextStyle(
                        color: AMColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BioSection extends StatelessWidget {
  final ArtistProfile profile;
  final bool expanded;
  final VoidCallback onToggleLinks;
  const _BioSection(
      {required this.profile,
      required this.expanded,
      required this.onToggleLinks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bio',
              style: TextStyle(
                  color: AMColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(profile.bio,
              style: const TextStyle(
                  color: AMColors.textPrimary, fontSize: 13, height: 1.5)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onToggleLinks,
            child: Row(
              children: [
                const Text('View Links',
                    style: TextStyle(
                        color: AMColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic)),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.chevron_right,
                      color: AMColors.accent, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  final ArtistProfile profile;
  const _SocialLinks({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          _SocialChip(label: 'Spotify', icon: Icons.music_note, color: AMColors.spotify, url: profile.spotifyUrl),
          const SizedBox(width: 8),
          _SocialChip(label: 'Instagram', icon: Icons.camera_alt_outlined, color: AMColors.instagram, url: profile.instagramUrl),
          const SizedBox(width: 8),
          _SocialChip(label: 'SoundCloud', icon: Icons.cloud_outlined, color: AMColors.soundcloud, url: profile.soundcloudUrl),
        ],
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  final String label, url;
  final IconData icon;
  final Color color;
  const _SocialChip({required this.label, required this.icon, required this.color, required this.url});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $label…'),
              backgroundColor: AMColors.card,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) =>
      Divider(color: AMColors.border, height: 24, thickness: 1);
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int? count;
  final Widget? trailing;
  const _SectionHeader({required this.title, this.count, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  color: AMColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3)),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AMColors.accentDim,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(count.toString(),
                  style: const TextStyle(
                      color: AMColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
          ],
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _GigsRow extends StatelessWidget {
  final List<GigItem> gigs;
  const _GigsRow({required this.gigs});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: gigs.length,
          itemBuilder: (_, i) {
            final g = gigs[i];
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AMColors.accent, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AMColors.accent.withOpacity(0.25),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: ClipOval(
                      child: _NetworkImage(url: g.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(g.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AMColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            );
          },
        ),
      );
}

// ─────────────────────────────────────────────
//  PRODUCER CATALOG — commented out
//  To re-enable: remove the /* and */ below
// ─────────────────────────────────────────────

/*
class _CatalogRow extends StatelessWidget {
  final List<CatalogItem> items;
  const _CatalogRow({required this.items});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 210,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            return Container(
              width: 140,
              margin: const EdgeInsets.only(right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _NetworkImage(
                        url: item.imageUrl,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 8),
                  Text(item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AMColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added "${item.title}" to cart'),
                          backgroundColor: AMColors.card,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AMColors.accentDim,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AMColors.accent.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: AMColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.shopping_cart_outlined,
                              color: AMColors.accent, size: 13),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
*/

// ─────────────────────────────────────────────
//  POSTS GRID
// ─────────────────────────────────────────────

class _PostsGrid extends StatelessWidget {
  final List<String> images;
  const _PostsGrid({required this.images});

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _NetworkImage(url: images[i], fit: BoxFit.cover),
            ),
            childCount: images.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
        ),
      );
}

class _StickyTopBar extends StatelessWidget {
  final bool collapsed;
  final String name;
  const _StickyTopBar({required this.collapsed, required this.name});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _IconBtn(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
            const Spacer(),
            AnimatedOpacity(
              opacity: collapsed ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Text(name,
                  style: const TextStyle(
                      color: AMColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            _IconBtn(
              icon: Icons.more_horiz,
              onTap: () => _showOptionsSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

void _showOptionsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AMColors.card,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: AMColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          _SheetOption(icon: Icons.share_outlined, label: 'Share Profile'),
          _SheetOption(icon: Icons.flag_outlined, label: 'Report'),
          _SheetOption(icon: Icons.block, label: 'Block Artist'),
        ],
      ),
    ),
  );
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SheetOption({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: AMColors.textSecondary),
        title: Text(label,
            style: const TextStyle(color: AMColors.textPrimary, fontSize: 14)),
        onTap: () => Navigator.pop(context),
      );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AMColors.card,
            shape: BoxShape.circle,
            border: Border.all(color: AMColors.border),
          ),
          child: Icon(icon, color: AMColors.textPrimary, size: 16),
        ),
      );
}

class _ChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ChipButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AMColors.accentDim,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: const TextStyle(
                  color: AMColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ),
      );
}

class _NetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width, height;
  const _NetworkImage({required this.url, required this.fit, this.width, this.height});

  @override
  Widget build(BuildContext context) => Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : Container(
                color: AMColors.card,
                child: const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 1.5, color: AMColors.accent)),
              ),
        errorBuilder: (_, __, ___) => Container(
          color: AMColors.card,
          child: const Icon(Icons.broken_image_outlined, color: AMColors.textSecondary),
        ),
      );
}// User profile screen UI
// Stats row section
// Stats row showing followers, following, and posts
