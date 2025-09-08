import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  final String heroTag;

  const BookDetailsScreen({
    super.key,
    required this.book,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final volumeInfo = book.volumeInfo;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(volumeInfo?.title ?? "Book Details"),
              background: GestureDetector(
                onTap: () {
                  if (volumeInfo?.imageLinks?.thumbnail != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullscreenImageView(
                          imageUrl: volumeInfo!.imageLinks!.thumbnail!,
                          heroTag: heroTag,
                        ),
                      ),
                    );
                  }
                },
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    volumeInfo?.imageLinks?.thumbnail ??
                        "https://via.placeholder.com/150",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Book details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    volumeInfo?.title ?? "No Title",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Authors
                  if (volumeInfo?.authors != null)
                    Text(
                      "by ${volumeInfo!.authors!.join(', ')}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                    ),

                  const SizedBox(height: 12),

                  // Description
                  if (volumeInfo?.description != null)
                    Text(
                      volumeInfo!.description!,
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                  const SizedBox(height: 20),

                  // Extra Info
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (volumeInfo?.publisher != null)
                        _InfoChip("Publisher", volumeInfo!.publisher!),
                      if (volumeInfo?.publishedDate != null)
                        _InfoChip("Published", volumeInfo!.publishedDate!),
                      if (volumeInfo?.pageCount != null)
                        _InfoChip("Pages", "${volumeInfo!.pageCount}"),
                      if (volumeInfo?.categories != null)
                        _InfoChip(
                          "Category",
                          volumeInfo!.categories!.join(", "),
                        ),
                    ],
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

/// InfoChip widget (for small details like publisher, year, etc.)
class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      backgroundColor: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

/// Fullscreen Image Viewer with pinch-to-zoom
class FullscreenImageView extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullscreenImageView({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: heroTag,
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
