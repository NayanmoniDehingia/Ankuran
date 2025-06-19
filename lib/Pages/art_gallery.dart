import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projects/Widgets/exit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArtGallery extends StatefulWidget {
  const ArtGallery({super.key});

  @override
  State<ArtGallery> createState() => _ArtGalleryState();
}

class _ArtGalleryState extends State<ArtGallery> {
  late Future<List<File>> _artworksFuture;

  @override
  void initState() {
    super.initState();
    _artworksFuture = _loadArtworks();
  }

  Future<List<File>> _loadArtworks() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    final images = files.whereType<File>().where(
          (file) => file.path.endsWith('.png') && file.path.contains('artwork_'),
    ).toList();

    // Sort by newest first (descending)
    images.sort((a, b) => b.path.compareTo(a.path));

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E7E1),
      body: Stack(
        children: [
          // Exit button
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 6.5,
            child: const ExitButton(),
          ),

          // Gallery title
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                 AppLocalizations.of(context)!.galleryText,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          ),

          // Gallery content
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 70, right: 20),
            child: FutureBuilder<List<File>>(
              future: _artworksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("❌ Error loading gallery"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("🖼 No artworks found"));
                }

                final images = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
