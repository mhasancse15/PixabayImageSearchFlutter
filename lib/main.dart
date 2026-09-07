import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the Pixabay API key from `.env` (see `.env.example`).
  await dotenv.load(fileName: '.env');

  // Lightweight local storage, ready if the app grows features like
  // recent-search history or favourites.
  await GetStorage.init();

  runApp(const App());
}
