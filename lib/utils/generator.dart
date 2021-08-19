import 'dart:math';

final generator = Generator();

class Generator {
  final _random = Random();
  final _names = [
    "Dr. stone",
    "One piece",
    "Detective Conan",
    "Fairy Tail 100 Years Quest",
    "One punch Man"
  ];
  final _slugs = [
    "dr-stone",
    "one-piece-",
    "DetektiveConane",
    "fairy-tail-100-years-quest",
    "0ne_punch_man"
  ];
  final _authors = [
    "Oda Eiichiro",
    "Shimabukuro Mitsutoshi",
    "Ohba Tsugumi",
    "Inagaki Riichiro",
    "Toriyama Akira"
  ];
  final _covers = [
    "https://onma.me/uploads/manga/dr-stone/cover/cover_250x350.jpg",
    "https://onma.me/uploads/manga/one-piece-/cover/cover_250x350.jpg",
    "https://onma.me/uploads/manga/DetektiveConane/cover/cover_250x350.jpg",
    "https://onma.me/uploads/manga/fairy-tail-100-years-quest/cover/cover_250x350.jpg",
    "https://onma.me/uploads/manga/0ne_punch_man/cover/cover_250x350.jpg"
  ];

  final _coverAssets = [
    "assets/images/cover1.jpg",
    "assets/images/cover2.jpg",
    "assets/images/cover3.jpg",
    "assets/images/cover4.jpg",
    "assets/images/cover5.jpg"
  ];

  final _mangaAssets = [
    "assets/images/image1.jpg",
    "assets/images/image2.jpg",
    "assets/images/image3.jpg",
    "assets/images/image4.jpg",
    "assets/images/image5.jpg"
  ];

  String mangaName() {
    return _names[_random.nextInt(_names.length)];
  }

  String mangaRate() {
    return (_random.nextDouble() * 5).toString();
  }

  String mangaSlug() {
    return _slugs[_random.nextInt(_slugs.length)];
  }

  String mangaAuthor() {
    return _authors[_random.nextInt(_authors.length)];
  }

  String mangaCover() {
    return _covers[_random.nextInt(_covers.length)];
  }

  String mangaCoverAsset() {
    return _coverAssets[_random.nextInt(_coverAssets.length)];
  }

  String mangaAsset() {
    return _mangaAssets[_random.nextInt(_mangaAssets.length)];
  }

  String imageExtension() {
    return generateBool() ? 'jpg' : 'png';
  }

  bool generateBool() {
    return _random.nextBool();
  }

  int generateNumber(int number) {
    return _random.nextInt(number) + 1;
  }
}
