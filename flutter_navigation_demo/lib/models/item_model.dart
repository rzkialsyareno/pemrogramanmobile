class ItemModel {
  final int id;
  final String title;
  final String description;
  final String image;
  final String category;
  final double rating;
  bool isFavorite;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.rating,
    this.isFavorite = false,
  });
}

List<ItemModel> sampleItems = [
  ItemModel(
    id: 1,
    title: 'Bali',
    description: 'Pulau Dewata dengan pantai indah, budaya yang kaya, dan pemandangan alam yang menakjubkan. Destinasi wisata favorit di Indonesia.',
    image: '🏝️',
    category: 'Destinasi Wisata',
    rating: 4.8,
    isFavorite: false,
  ),
  ItemModel(
    id: 2,
    title: 'Raja Ampat',
    description: 'Surga bawah laut dengan keanekaragaman hayati laut terkaya di dunia. Cocok untuk diving dan snorkeling.',
    image: '🐠',
    category: 'Destinasi Wisata',
    rating: 4.9,
    isFavorite: false,
  ),
  ItemModel(
    id: 3,
    title: 'Borobudur',
    description: 'Candi Buddha terbesar di dunia yang terletak di Magelang, Jawa Tengah. Warisan budaya UNESCO.',
    image: '🛕',
    category: 'Destinasi Wisata',
    rating: 4.7,
    isFavorite: false,
  ),
  ItemModel(
    id: 4,
    title: 'Bromo',
    description: 'Gunung berapi aktif dengan pemandangan sunrise yang spektakuler. Terletak di Jawa Timur.',
    image: '🌋',
    category: 'Destinasi Wisata',
    rating: 4.6,
    isFavorite: false,
  ),
  ItemModel(
    id: 5,
    title: 'Komodo',
    description: 'Pulau habitat asli komodo, kadal terbesar di dunia. Taman Nasional Komodo adalah situs warisan dunia.',
    image: '🦎',
    category: 'Destinasi Wisata',
    rating: 4.8,
    isFavorite: false,
  ),
  ItemModel(
    id: 6,
    title: 'Danau Toba',
    description: 'Danau vulkanik terbesar di Indonesia yang terletak di Sumatera Utara dengan Pulau Samosir di tengahnya.',
    image: '🏞️',
    category: 'Destinasi Wisata',
    rating: 4.5,
    isFavorite: false,
  ),
];
