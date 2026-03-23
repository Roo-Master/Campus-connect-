import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';

// ==================== Enums ====================

enum NewsCardType {
  standard,
  horizontal,
  featured,
  compact,
}

enum NewsCategory {
  academic,
  announcement,
  event,
  career,
  research,
  sports,
  cultural,
  important,
}

// ==================== NewsItem Model ====================

class NewsItem {
  final String id;
  final String title;
  final String summary;
  final NewsCategory category;
  final String author;
  final DateTime publishedAt;
  final String imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final bool isBreaking;
  final NewsCardType cardType;

  NewsItem({
    required this.id,
    required this.title,
    this.summary = '',
    required this.category,
    required this.author,
    required this.publishedAt,
    this.imageUrl = '',
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isBreaking = false,
    this.cardType = NewsCardType.standard,
  });

  String get categoryName => _getCategoryDisplayName(category);
  String get formattedTimeAgo => _formatTimeAgo(publishedAt);

  String _getCategoryDisplayName(NewsCategory cat) {
    switch (cat) {
      case NewsCategory.academic:
        return 'Academic';
      case NewsCategory.announcement:
        return 'Announcement';
      case NewsCategory.event:
        return 'Event';
      case NewsCategory.career:
        return 'Career';
      case NewsCategory.research:
        return 'Research';
      case NewsCategory.sports:
        return 'Sports';
      case NewsCategory.cultural:
        return 'Cultural';
      case NewsCategory.important:
        return 'Important';
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'category': category.index,
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isBreaking': isBreaking,
      'cardType': cardType.index,
    };
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? '',
      category: NewsCategory.values[json['category'] as int],
      author: json['author'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      imageUrl: json['imageUrl'] as String? ?? '',
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      shares: json['shares'] as int? ?? 0,
      isBreaking: json['isBreaking'] as bool? ?? false,
      cardType: NewsCardType.values[json['cardType'] as int? ?? 0],
    );
  }

  factory NewsItem.mock({
    String id = '1',
    String title = 'News Title',
    String summary = '',
    NewsCategory category = NewsCategory.announcement,
    String author = 'Admin',
    DateTime? publishedAt,
    String imageUrl = '',
    int likes = 0,
    int comments = 0,
    int shares = 0,
    bool isBreaking = false,
    NewsCardType cardType = NewsCardType.standard,
  }) {
    return NewsItem(
      id: id,
      title: title,
      summary: summary,
      category: category,
      author: author,
      publishedAt: publishedAt ?? DateTime.now().subtract(const Duration(hours: 2)),
      imageUrl: imageUrl,
      likes: likes,
      comments: comments,
      shares: shares,
      isBreaking: isBreaking,
      cardType: cardType,
    );
  }

  static List<NewsItem> getMockNews() {
    return [
      NewsItem.mock(
        id: '1',
        title: 'Mid-Semester Examination Schedule Released',
        summary: 'The examination office has released the mid-semester exam schedule.',
        category: NewsCategory.academic,
        author: 'Examination Office',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 45,
        comments: 12,
        shares: 5,
        cardType: NewsCardType.featured,
      ),
      NewsItem.mock(
        id: '2',
        title: 'Tech Fest 2024 Registration Open',
        summary: 'Register now for the annual technology festival.',
        category: NewsCategory.event,
        author: 'CS Department',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 128,
        comments: 34,
        shares: 45,
        cardType: NewsCardType.standard,
      ),
      NewsItem.mock(
        id: '3',
        title: 'Career Fair 2024 - Companies Announced',
        summary: 'Over 50 companies will participate.',
        category: NewsCategory.career,
        author: 'Career Services',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 89,
        comments: 23,
        shares: 67,
        cardType: NewsCardType.horizontal,
        imageUrl: 'https://example.com/career-fair.jpg',
      ),
      NewsItem.mock(
        id: '4',
        title: 'Library Hours Extended During Exams',
        summary: 'The main library will remain open 24/7.',
        category: NewsCategory.announcement,
        author: 'Library Administration',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 56,
        comments: 8,
        shares: 12,
        cardType: NewsCardType.standard,
      ),
      NewsItem.mock(
        id: '5',
        title: 'Guest Lecture on AI in Healthcare',
        summary: 'Dr. Robert Chen will deliver a guest lecture.',
        category: NewsCategory.research,
        author: 'AI Research Club',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        likes: 78,
        comments: 15,
        shares: 23,
        cardType: NewsCardType.compact,
      ),
      NewsItem.mock(
        id: '6',
        title: 'Campus Maintenance Notice',
        summary: 'Water supply will be temporarily affected.',
        category: NewsCategory.important,
        author: 'Infrastructure',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        likes: 34,
        comments: 5,
        shares: 8,
        isBreaking: true,
        cardType: NewsCardType.standard,
      ),
    ];
  }
}

// ==================== NewsFeedWidget ====================

class NewsFeedWidget extends StatelessWidget {
  final List<NewsItem> newsItems;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final Function(NewsItem)? onNewsTap;
  final bool showHeader;
  final bool enablePullToRefresh;
  final int maxItems;

  const NewsFeedWidget({
    super.key,
    required this.newsItems,
    this.isLoading = false,
    this.onRefresh,
    this.onNewsTap,
    this.showHeader = true,
    this.enablePullToRefresh = false,
    this.maxItems = 10,
  });



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Campus News',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(List<NewsItem> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: enablePullToRefresh
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final news = items[index];
        return _buildNewsCard(news);
      },
    );
  }

  Widget _buildNewsCard(NewsItem news) {
    switch (news.cardType) {
      case NewsCardType.horizontal:
        return _buildHorizontalCard(news);
      case NewsCardType.featured:
        return _buildFeaturedCard(news);
      case NewsCardType.compact:
        return _buildCompactCard(news);
      case NewsCardType.standard:
      default:
        return _buildStandardCard(news);
    }
  }

  // Standard Card Style
  Widget _buildStandardCard(NewsItem news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => onNewsTap?.call(news),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCategoryBadge(news.categoryName),
                  const Spacer(),
                  _buildTimeAgo(news.formattedTimeAgo),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                news.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (news.summary.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  news.summary,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (news.imageUrl.isNotEmpty) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    news.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(news.categoryName),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              _buildFooter(news),
            ],
          ),
        ),
      ),
    );
  }

  // Horizontal Card Style
  Widget _buildHorizontalCard(NewsItem news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => onNewsTap?.call(news),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: Image.network(
                  news.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderImage(news.categoryName, width: 120, height: 120),
                ),
              )
            else
              _buildPlaceholderImage(news.categoryName, width: 120, height: 120),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryBadge(news.categoryName, fontSize: 10),
                    const SizedBox(height: 8),
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    _buildTimeAgo(news.formattedTimeAgo, fontSize: 11),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Featured Card Style
  Widget _buildFeaturedCard(NewsItem news) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onNewsTap?.call(news),
        child: Stack(
          children: [
            if (news.imageUrl.isNotEmpty)
              Image.network(
                news.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFeaturedPlaceholder(news.categoryName),
              )
            else
              _buildFeaturedPlaceholder(news.categoryName),
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryBadge(news.categoryName, isLight: true),
                  const SizedBox(height: 8),
                  Text(
                    news.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        news.author,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        news.formattedTimeAgo,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (news.isBreaking)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'BREAKING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Compact Card Style
  Widget _buildCompactCard(NewsItem news) {
    return Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
            onTap: () => onNewsTap?.call(news),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                  Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(news.category).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(news.category),
                    color: _getCategoryColor(news.category),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        news.formattedTimeAgo,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
            ),
        ),
    );
  }

  // ==================== Helpers ====================

  Widget _buildFooter(NewsItem news) {
    return Row(
      children: [
        _buildIconText(Icons.thumb_up_alt_outlined, news.likes),
        const SizedBox(width: 16),
        _buildIconText(Icons.chat_bubble_outline, news.comments),
        const SizedBox(width: 16),
        _buildIconText(Icons.share_outlined, news.shares),
      ],
    );
  }

  Widget _buildIconText(IconData icon, int value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBadge(
      String label, {
        double fontSize = 11,
        bool isLight = false,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLight
            ? Colors.white.withOpacity(0.2)
            : AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: isLight ? Colors.white : AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildTimeAgo(
      String time, {
        double fontSize = 12,
        Color? color,
      }) {
    return Text(
      time,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.grey.shade500,
      ),
    );
  }

  Widget _buildPlaceholderImage(
      String category, {
        double width = double.infinity,
        double height = 120,
      }) {
    return Container(
      width: width,
      height: height,
      color: _getCategoryColor(
        NewsCategory.values.firstWhere(
              (c) => c.name.toLowerCase() == category.toLowerCase(),
          orElse: () => NewsCategory.announcement,
        ),
      ).withOpacity(0.1),
      child: Icon(
        _getCategoryIcon(
          NewsCategory.values.firstWhere(
                (c) => c.name.toLowerCase() == category.toLowerCase(),
            orElse: () => NewsCategory.announcement,
          ),
        ),
        size: 40,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildFeaturedPlaceholder(String category) {
    return Container(
      height: 200,
      width: double.infinity,
      color: AppTheme.primary,
      child: const Center(
        child: Icon(
          Icons.campaign,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          "No news available",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  // ==================== Category Helpers ====================

  Color _getCategoryColor(NewsCategory category) {
    switch (category) {
      case NewsCategory.academic:
        return Colors.blue;
      case NewsCategory.announcement:
        return Colors.teal;
      case NewsCategory.event:
        return Colors.orange;
      case NewsCategory.career:
        return Colors.green;
      case NewsCategory.research:
        return Colors.purple;
      case NewsCategory.sports:
        return Colors.red;
      case NewsCategory.cultural:
        return Colors.pink;
      case NewsCategory.important:
        return Colors.deepOrange;
    }
  }

  IconData _getCategoryIcon(NewsCategory category) {
    switch (category) {
      case NewsCategory.academic:
        return Icons.school;
      case NewsCategory.announcement:
        return Icons.campaign;
      case NewsCategory.event:
        return Icons.event;
      case NewsCategory.career:
        return Icons.work;
      case NewsCategory.research:
        return Icons.science;
      case NewsCategory.sports:
        return Icons.sports_soccer;
      case NewsCategory.cultural:
        return Icons.palette;
      case NewsCategory.important:
        return Icons.priority_high;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}