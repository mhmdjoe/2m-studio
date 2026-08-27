enum ProjectCategory { fashion, product }

enum ProjectSubCategory { indoor, outdoor, flatlay, shoes, commercial, none }

class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final ProjectCategory category;
  final ProjectSubCategory subCategory;
  final String? beforeImageUrl; 
  final List<String> tags;
  final bool isPremium;
  final DateTime createdAt;
  final List<String> galleryUrls;
  final String year;
  final String studio;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.subCategory,
    this.beforeImageUrl,
    this.tags = const [],
    this.isPremium = false,
    DateTime? createdAt,
    this.galleryUrls = const [],
    this.year = '2024',
    this.studio = '2M STUDIO',
  }) : createdAt = createdAt ?? DateTime.now();

  factory Project.fromMap(Map<String, dynamic> map, String docId) {
    return Project(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: ProjectCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ProjectCategory.fashion,
      ),
      subCategory: ProjectSubCategory.values.firstWhere(
        (e) => e.name == map['subCategory'],
        orElse: () => ProjectSubCategory.none,
      ),
      beforeImageUrl: map['beforeImageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      isPremium: map['isPremium'] ?? false,
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) 
          : DateTime.now(),
      galleryUrls: List<String>.from(map['galleryUrls'] ?? []),
      year: map['year'] ?? '2024',
      studio: map['studio'] ?? '2M STUDIO',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category.name,
      'subCategory': subCategory.name,
      'beforeImageUrl': beforeImageUrl,
      'tags': tags,
      'isPremium': isPremium,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'galleryUrls': galleryUrls,
      'year': year,
      'studio': studio,
    };
  }
}

// Curated Permanent Portfolio (One session per category)
// TIP: To use photos from your hard disk: 
// 1. Put them in assets/images/ folder
// 2. Change the imageUrl to 'assets/images/your_photo.jpg'
final List<Project> mockProjects = [
  Project(
    id: '9',
    title: 'High-End Brand Campaign',
    description: 'Commercial fashion shoot for international labels.',
    imageUrl: 'https://res.cloudinary.com/twkcybze/image/upload/v1787066966/wallpaper.jpg',
    galleryUrls: [
      'https://res.cloudinary.com/twkcybze/image/upload/v1787066298/main-sample.png',
    ],
    category: ProjectCategory.fashion,
    subCategory: ProjectSubCategory.commercial,
    isPremium: true,
    tags: ['Commercial', 'Fashion', 'Campaign'],
  ),
  Project(
    id: '3',
    title: 'High-End Fashion Indoor',
    description: 'Indoor fashion session focusing on silhouette and texture.',
    imageUrl: 'https://images.unsplash.com/photo-1515516089376-88db1e26e9c0?auto=format&fit=crop&q=80&w=1000',
    category: ProjectCategory.fashion,
    subCategory: ProjectSubCategory.indoor,
    isPremium: true,
    tags: ['Industrial', 'Architecture', 'Interior'],
  ),
  Project(
    id: '6',
    title: 'Street Style Fashion',
    description: 'Outdoor street photography for an urban apparel brand.',
    imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&q=80&w=1000',
    category: ProjectCategory.fashion,
    subCategory: ProjectSubCategory.outdoor,
    tags: ['Fashion', 'Street', 'Urban'],
  ),
  Project(
    id: '5',
    title: 'Editorial Flatlay Concept',
    description: 'Advanced fashion flatlay composition.',
    imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=1000',
    category: ProjectCategory.fashion,
    subCategory: ProjectSubCategory.flatlay,
    isPremium: true,
    tags: ['Editorial', 'Style'],
  ),
  Project(
    id: '7',
    title: 'Elite Sneakers Session',
    description: 'Specialized footwear photography for premium brands.',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=1000',
    category: ProjectCategory.fashion,
    subCategory: ProjectSubCategory.shoes,
    isPremium: true,
    tags: ['Shoes', 'Commercial', 'Footwear'],
  ),
  Project(
    id: '1',
    title: 'Luxury Perfume Campaign',
    description: 'Commercial shoot for a premium fragrance brand.',
    imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&q=80&w=1000',
    category: ProjectCategory.product,
    subCategory: ProjectSubCategory.none,
    isPremium: true,
    tags: ['Luxury', 'Fragrance', 'Commercial'],
  ),
];
