import 'dart:io';
import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  static final DefaultCacheManager cacheManager = DefaultCacheManager();
  static const String cacheKey = 'pickMyDishCache';

  // Cache image from URL
  static Future<File?> cacheNetworkImage(String imageUrl) async {
    try {
      if (!imageUrl.startsWith('http')) {
        return null;
      }

      final file = await cacheManager.getSingleFile(imageUrl, key: cacheKey);
      return file;
    } catch (e) {
      print('❌ Cache error: $e');
      return null;
    }
  }

  // Get cached image file or download if not cached
  static Future<File?> getImage(String imageUrl) async {
    try {
      return await cacheManager.getSingleFile(imageUrl, key: cacheKey);
    } catch (e) {
      print('❌ Get cached image error: $e');
      return null;
    }
  }

  // Clear all cached images
  static Future<void> clearCache() async {
    await cacheManager.emptyCache();
  }

  // Get cache info
  static Future<Map<String, dynamic>> getCacheInfo() async {
    final directory = await getTemporaryDirectory();
    final cacheDir = Directory(p.join(directory.path, cacheKey));
    
    if (!cacheDir.existsSync()) {
      return {'size': 0, 'fileCount': 0};
    }

    int totalSize = 0;
    int fileCount = 0;
    
    final files = cacheDir.listSync();
    for (var file in files) {
      if (file is File) {
        totalSize += await file.length();
        fileCount++;
      }
    }

    return {
      'size': totalSize,
      'sizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      'fileCount': fileCount
    };
  }
}