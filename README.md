<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/github_username/repo_name">
    <img src="assets/images/logo5.png" alt="Logo" width="150" height="150">
  </a>

  <h3 align="center">Flutter Manga Scraper</h3>

  <p align="center">
    A flutter mobile application for scraping and downloading manga from 
    <a href="https://www.mangatown.com/hot/">Manga town</a>
    <br/>
    <br/>
    <a href="https://github.com/laitooo/flutter_manga_scraper/issues">Report a Bug</a>
  </p>
</p>



## Features:
- Reading most popular and latest releases mangas.
- Two languages available (Ar, En).
- Track your manga reading and add manga to your favourites.
- Download manga and read it later offline.
- Mock repositories can be used for testing.
- Search for any manga you want.
- Vertical and horizontal reading modes are available.
- Manga categorized by genres.

## TODO:
- Implement advance search (by genres, type, status).
- Make sure big images is working well
- Make sure reader is working good for landscape.
- Add retry download when a download fails.
- Multi-chapters download screen.

## Packages used:
- [Bloc](https://pub.dev/packages/flutter_bloc) used for state managements.
- [Flutter background services](https://pub.dev/packages/flutter_background_service) used to download manga on a native background service.
- [Hive](https://pub.dev/packages/hive) used to store history and favourites.
- [Moor](https://pub.dev/packages/moor) used to store download data in background service.
- [Dio](https://pub.dev/packages/dio) used to download images.
- [Photo view](https://pub.dev/packages/photo_view) used to display manga images.
