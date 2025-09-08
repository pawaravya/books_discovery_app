
class Book {
  final String? kind;
  final String? id;
  final String? etag;
  final String? selfLink;
  final VolumeInfo? volumeInfo;
  final SaleInfo? saleInfo;
  final AccessInfo? accessInfo;
  final SearchInfo? searchInfo;
  Book({
    this.kind,
    this.id,
    this.etag,
    this.selfLink,
    this.volumeInfo,
    this.saleInfo,
    this.accessInfo,
    this.searchInfo,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      kind: json['kind'] as String?,
      id: json['id'] as String?,
      etag: json['etag'] as String?,
      selfLink: json['selfLink'] as String?,
      volumeInfo: json['volumeInfo'] == null
          ? null
          : VolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
      saleInfo: json['saleInfo'] == null
          ? null
          : SaleInfo.fromJson(json['saleInfo'] as Map<String, dynamic>),
      accessInfo: json['accessInfo'] == null
          ? null
          : AccessInfo.fromJson(json['accessInfo'] as Map<String, dynamic>),
      searchInfo: json['searchInfo'] == null
          ? null
          : SearchInfo.fromJson(json['searchInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'id': id,
      'etag': etag,
      'selfLink': selfLink,
      'volumeInfo': volumeInfo?.toJson(),
      'saleInfo': saleInfo?.toJson(),
      'accessInfo': accessInfo?.toJson(),
      'searchInfo': searchInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Book(kind: $kind, id: $id, volumeInfo: $volumeInfo)';
  }
}

class VolumeInfo {
  final String? title;
  final String? subtitle;
  final List<String>? authors;
  final String? publisher;
  final String? publishedDate;
  final String? description;
  final List<IndustryIdentifier>? industryIdentifiers;
  final ReadingModes? readingModes;
  final int? pageCount;
  final String? printType;
  final List<String>? categories;
  final String? maturityRating; 
  final bool? allowAnonLogging;
  final String? contentVersion;
  final PanelizationSummary? panelizationSummary;
  final ImageLinks? imageLinks;
  final String? language;
  final String? previewLink;
  final String? infoLink;
  final String? canonicalVolumeLink;

  VolumeInfo({
    this.title,
    this.subtitle,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.description,
    this.industryIdentifiers,
    this.readingModes,
    this.pageCount,
    this.printType,
    this.categories,
    this.maturityRating,
    this.allowAnonLogging,
    this.contentVersion,
    this.panelizationSummary,
    this.imageLinks,
    this.language,
    this.previewLink,
    this.infoLink,
    this.canonicalVolumeLink,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      // Handle authors list
      authors: (json['authors'] as List?)
          ?.map((e) => e as String)
          .toList(),
      publisher: json['publisher'] as String?,
      publishedDate: json['publishedDate'] as String?,
      description: json['description'] as String?,
      // Handle industryIdentifiers list
      industryIdentifiers: (json['industryIdentifiers'] as List?)
          ?.map((e) => IndustryIdentifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      readingModes: json['readingModes'] == null
          ? null
          : ReadingModes.fromJson(json['readingModes'] as Map<String, dynamic>),
      pageCount: json['pageCount'] as int?,
      printType: json['printType'] as String?,
      // Handle categories list
      categories: (json['categories'] as List?)
          ?.map((e) => e as String)
          .toList(),
      maturityRating: json['maturityRating'] as String?,
      allowAnonLogging: json['allowAnonLogging'] as bool?,
      contentVersion: json['contentVersion'] as String?,
      panelizationSummary: json['panelizationSummary'] == null
          ? null
          : PanelizationSummary.fromJson(
              json['panelizationSummary'] as Map<String, dynamic>),
      imageLinks: json['imageLinks'] == null
          ? null
          : ImageLinks.fromJson(json['imageLinks'] as Map<String, dynamic>),
      language: json['language'] as String?,
      previewLink: json['previewLink'] as String?,
      infoLink: json['infoLink'] as String?,
      canonicalVolumeLink: json['canonicalVolumeLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'industryIdentifiers':
          industryIdentifiers?.map((e) => e.toJson()).toList(),
      'readingModes': readingModes?.toJson(),
      'pageCount': pageCount,
      'printType': printType,
      'categories': categories,
      'maturityRating': maturityRating,
      'allowAnonLogging': allowAnonLogging,
      'contentVersion': contentVersion,
      'panelizationSummary': panelizationSummary?.toJson(),
      'imageLinks': imageLinks?.toJson(),
      'language': language,
      'previewLink': previewLink,
      'infoLink': infoLink,
      'canonicalVolumeLink': canonicalVolumeLink,
    };
  }

  @override
  String toString() {
    return 'VolumeInfo(title: $title, authors: $authors, publishedDate: $publishedDate)';
  }
}

/// Represents an industry identifier for the volume.
class IndustryIdentifier {
  /// The type of identifier (e.g., "ISBN_10", "ISBN_13").
  final String? type;

  /// The identifier value.
  final String? identifier;

  IndustryIdentifier({this.type, this.identifier});

  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifier(
      type: json['type'] as String?,
      identifier: json['identifier'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'identifier': identifier,
    };
  }

  @override
  String toString() {
    return 'IndustryIdentifier(type: $type, identifier: $identifier)';
  }
}

/// Represents the reading modes available for the volume.
class ReadingModes {
  /// Is text reading available?
  final bool? text;

  /// Is image reading available?
  final bool? image;

  ReadingModes({this.text, this.image});

  factory ReadingModes.fromJson(Map<String, dynamic> json) {
    return ReadingModes(
      text: json['text'] as bool?,
      image: json['image'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'ReadingModes(text: $text, image: $image)';
  }
}

/// Summary of panelization information.
class PanelizationSummary {
  /// Does the volume contain epub bubbles?
  final bool? containsEpubBubbles;

  /// Does the volume contain image bubbles?
  final bool? containsImageBubbles;

  PanelizationSummary({this.containsEpubBubbles, this.containsImageBubbles});

  factory PanelizationSummary.fromJson(Map<String, dynamic> json) {
    return PanelizationSummary(
      containsEpubBubbles: json['containsEpubBubbles'] as bool?,
      containsImageBubbles: json['containsImageBubbles'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'containsEpubBubbles': containsEpubBubbles,
      'containsImageBubbles': containsImageBubbles,
    };
  }

  @override
  String toString() {
    return 'PanelizationSummary(containsEpubBubbles: $containsEpubBubbles, containsImageBubbles: $containsImageBubbles)';
  }
}

/// URLs to view the image links for the volume.
class ImageLinks {
  /// URL for the small thumbnail image.
  final String? smallThumbnail;

  /// URL for the standard thumbnail image.
  final String? thumbnail;

  /// URL for the medium image.
  final String? medium;

  /// URL for the large image.
  final String? large;

  /// URL for the extra large image.
  final String? extraLarge;

  /// URL for the small image.
  final String? small;

  ImageLinks({
    this.smallThumbnail,
    this.thumbnail,
    this.medium,
    this.large,
    this.extraLarge,
    this.small,
  });

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    return ImageLinks(
      smallThumbnail: json['smallThumbnail'] as String?,
      thumbnail: json['thumbnail'] as String?,
      medium: json['medium'] as String?,
      large: json['large'] as String?,
      extraLarge: json['extraLarge'] as String?,
      small: json['small'] as String?,
    );
    // Note: The API might provide other image sizes not explicitly listed here.
    // You might want to handle a more dynamic structure if needed.
  }

  Map<String, dynamic> toJson() {
    return {
      'smallThumbnail': smallThumbnail,
      'thumbnail': thumbnail,
      'medium': medium,
      'large': large,
      'extraLarge': extraLarge,
      'small': small,
    };
  }

  @override
  String toString() {
    return 'ImageLinks(thumbnail: $thumbnail)';
  }
}

/// Information about the sale of the volume.
class SaleInfo {
  /// The country where the sale is happening.
  final String? country;

  /// Whether the volume is for sale.
  final String? saleability; // Consider enum if values are fixed

  /// Whether the volume is an ebook.
  final bool? isEbook;

  /// The list of offers for the volume.
  final List<Offer>? offers; // This field wasn't in your sample but is in the API

  SaleInfo({
    this.country,
    this.saleability,
    this.isEbook,
    this.offers,
  });

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    return SaleInfo(
      country: json['country'] as String?,
      saleability: json['saleability'] as String?,
      isEbook: json['isEbook'] as bool?,
      // Handle offers list if present
      offers: (json['offers'] as List?)
          ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'saleability': saleability,
      'isEbook': isEbook,
      'offers': offers?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'SaleInfo(country: $country, saleability: $saleability)';
  }
}

/// Represents an offer for the volume.
class Offer {
  /// The country for which the offer applies.
  final String? country;

  /// The offer price in the currency specified by 'currencyCode'.
  final num? priceAmount; // Can be int or double

  /// The currency code for the offer price (ISO 4217).
  final String? currencyCode;

  /// The formatted offer price.
  final String? formattedPrice;

  /// The link to the offer.
  final String? offerLink;

  Offer({
    this.country,
    this.priceAmount,
    this.currencyCode,
    this.formattedPrice,
    this.offerLink,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      country: json['country'] as String?,
      priceAmount: json['priceAmount'] as num?,
      currencyCode: json['currencyCode'] as String?,
      formattedPrice: json['formattedPrice'] as String?,
      offerLink: json['offerLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'priceAmount': priceAmount,
      'currencyCode': currencyCode,
      'formattedPrice': formattedPrice,
      'offerLink': offerLink,
    };
  }

  @override
  String toString() {
    return 'Offer(country: $country, priceAmount: $priceAmount, currencyCode: $currencyCode)';
  }
}

/// Information about the access to the volume.
class AccessInfo {
  /// The country for which the access information applies.
  final String? country;

  /// The viewability status of the volume.
  final String? viewability; // Consider enum if values are fixed

  /// Whether the volume can be embedded.
  final bool? embeddable;

  /// Whether the volume is public domain.
  final bool? publicDomain;

  /// The text-to-speech permission for the volume.
  final String? textToSpeechPermission; // Consider enum if values are fixed

  /// Information about the epub version.
  final Epub? epub;

  /// Information about the PDF version.
  final Pdf? pdf;

  /// URL to the web reader.
  final String? webReaderLink;

  /// The access view status of the volume.
  final String? accessViewStatus; // Consider enum if values are fixed

  /// Whether quote sharing is allowed.
  final bool? quoteSharingAllowed;

  AccessInfo({
    this.country,
    this.viewability,
    this.embeddable,
    this.publicDomain,
    this.textToSpeechPermission,
    this.epub,
    this.pdf,
    this.webReaderLink,
    this.accessViewStatus,
    this.quoteSharingAllowed,
  });

  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(
      country: json['country'] as String?,
      viewability: json['viewability'] as String?,
      embeddable: json['embeddable'] as bool?,
      publicDomain: json['publicDomain'] as bool?,
      textToSpeechPermission: json['textToSpeechPermission'] as String?,
      epub: json['epub'] == null
          ? null
          : Epub.fromJson(json['epub'] as Map<String, dynamic>),
      pdf: json['pdf'] == null
          ? null
          : Pdf.fromJson(json['pdf'] as Map<String, dynamic>),
      webReaderLink: json['webReaderLink'] as String?,
      accessViewStatus: json['accessViewStatus'] as String?,
      quoteSharingAllowed: json['quoteSharingAllowed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'viewability': viewability,
      'embeddable': embeddable,
      'publicDomain': publicDomain,
      'textToSpeechPermission': textToSpeechPermission,
      'epub': epub?.toJson(),
      'pdf': pdf?.toJson(),
      'webReaderLink': webReaderLink,
      'accessViewStatus': accessViewStatus,
      'quoteSharingAllowed': quoteSharingAllowed,
    };
  }

  @override
  String toString() {
    return 'AccessInfo(viewability: $viewability, accessViewStatus: $accessViewStatus)';
  }
}

/// Information about the epub version of the volume.
class Epub {
  /// Whether the epub version is available.
  final bool? isAvailable;

  /// The URL to the ACS token link for the epub (if applicable).
  final String? acsTokenLink;

  /// Whether the epub is available for download.
  final bool? isAvailableForDownload; // Might not be in all API responses

  /// The download link for the epub (if available).
  final String? downloadLink; // Might not be in all API responses

  Epub({
    this.isAvailable,
    this.acsTokenLink,
    this.isAvailableForDownload,
    this.downloadLink,
  });

  factory Epub.fromJson(Map<String, dynamic> json) {
    return Epub(
      isAvailable: json['isAvailable'] as bool?,
      acsTokenLink: json['acsTokenLink'] as String?,
      isAvailableForDownload: json['isAvailableForDownload'] as bool?,
      downloadLink: json['downloadLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'acsTokenLink': acsTokenLink,
      'isAvailableForDownload': isAvailableForDownload,
      'downloadLink': downloadLink,
    };
  }

  @override
  String toString() {
    return 'Epub(isAvailable: $isAvailable)';
  }
}

/// Information about the PDF version of the volume.
class Pdf {
  /// Whether the PDF version is available.
  final bool? isAvailable;

  /// The URL to the ACS token link for the PDF (if applicable).
  final String? acsTokenLink;

  /// Whether the PDF is available for download.
  final bool? isAvailableForDownload; // Might not be in all API responses

  /// The download link for the PDF (if available).
  final String? downloadLink; // Might not be in all API responses

  Pdf({
    this.isAvailable,
    this.acsTokenLink,
    this.isAvailableForDownload,
    this.downloadLink,
  });

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(
      isAvailable: json['isAvailable'] as bool?,
      acsTokenLink: json['acsTokenLink'] as String?,
      isAvailableForDownload: json['isAvailableForDownload'] as bool?,
      downloadLink: json['downloadLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'acsTokenLink': acsTokenLink,
      'isAvailableForDownload': isAvailableForDownload,
      'downloadLink': downloadLink,
    };
  }

  @override
  String toString() {
    return 'Pdf(isAvailable: $isAvailable)';
  }
}

/// Search result information related to the volume.
class SearchInfo {
  /// A text snippet containing the search terms.
  final String? textSnippet;

  SearchInfo({this.textSnippet});

  factory SearchInfo.fromJson(Map<String, dynamic> json) {
    return SearchInfo(
      textSnippet: json['textSnippet'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textSnippet': textSnippet,
    };
  }

  @override
  String toString() {
    return 'SearchInfo(textSnippet: ${textSnippet?.substring(0, 30)}...)'; // Truncate for brevity
  }
}