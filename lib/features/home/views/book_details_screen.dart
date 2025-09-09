import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/features/home/models/books_model.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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

    return BaseWidget(
      screen: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
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
                  child: NetworkImageWithPlaceholder(
                    imageUrl: volumeInfo?.imageLinks?.thumbnail ?? "",
                    placeholderAsset: "",
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
                  AppText(
                    volumeInfo?.title ?? "No Title",

                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),

                  // Authors
                  if (volumeInfo?.authors != null)
                    AppText(
                      "by ${volumeInfo!.authors!.join(', ')}",
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700] ?? Colors.black,
                    ),

                  const SizedBox(height: 12),

                  // Description
                  if (volumeInfo?.description != null)
                    AppText(
                      volumeInfo!.description!,
                      textAlign: TextAlign.justify,
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
          AppText(label, fontSize: 10, color: Colors.white),
          AppText(
            value,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: HexColor(ColorConstants.themeColor),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

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
              backgroundDecoration: const BoxDecoration(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
