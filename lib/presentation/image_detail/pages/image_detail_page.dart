import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/image_entity.dart';

/// Full-screen view of a single image with metadata (author, stats,
/// tags) pulled straight from the entity handed off by the grid —
/// no extra network round-trip required.
class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final image = Get.arguments as ImageEntity;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image_${image.id}',
                child: CachedNetworkImage(
                  imageUrl: image.largeImageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AuthorRow(name: image.user, avatarUrl: image.userImageUrl),
                  const SizedBox(height: 16),
                  _StatsRow(
                    views: image.views,
                    downloads: image.downloads,
                    likes: image.likes,
                    comments: image.comments,
                  ),
                  const SizedBox(height: 16),
                  if (image.tagList.isNotEmpty) ...[
                    Text('Tags', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: image.tagList
                          .map((tag) => Chip(label: Text(tag)))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const _AuthorRow({required this.name, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: avatarUrl.isNotEmpty ? CachedNetworkImageProvider(avatarUrl) : null,
          child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        const SizedBox(width: 12),
        Text(name, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int views;
  final int downloads;
  final int likes;
  final int comments;

  const _StatsRow({
    required this.views,
    required this.downloads,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatItem(icon: Icons.remove_red_eye_outlined, label: 'Views', value: views),
        _StatItem(icon: Icons.download_outlined, label: 'Downloads', value: downloads),
        _StatItem(icon: Icons.favorite_outline, label: 'Likes', value: likes),
        _StatItem(icon: Icons.comment_outlined, label: 'Comments', value: comments),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _StatItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(value.toString(), style: Theme.of(context).textTheme.titleSmall),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
