import 'package:flutter/material.dart';
import 'package:pick_my_dish/Services/image_cache_service.dart';

class ImageUtils {
  // For profile image widget
  static Widget buildCachedProfileImage(String imagePath, double radius) {
    return FutureBuilder<ImageProvider>(
      future: _getCachedProfileImage(imagePath),
      builder: (context, snapshot) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: snapshot.hasData 
              ? snapshot.data 
              : AssetImage('assets/login/noPicture.png'),
        );
      },
    );
  }

  // For getting cached image provider
  static Future<ImageProvider> _getCachedProfileImage(String imagePath) async {
    if (imagePath.startsWith('uploads/') || imagePath.contains('profile-')) {
      final serverUrl = 'http://38.242.246.126:3000/$imagePath';
      final cachedFile = await ImageCacheService.getImage(serverUrl);
      
      if (cachedFile != null && cachedFile.existsSync()) {
        return FileImage(cachedFile);
      }
      return NetworkImage(serverUrl);
    }
    return AssetImage(imagePath);
  }

  // For NetworkImage widget with caching
  static Widget cachedNetworkImage(String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return FutureBuilder<ImageProvider>(
      future: _getCachedImage(url),
      builder: (context, snapshot) {
        return Image(
          image: snapshot.hasData 
              ? snapshot.data! 
              : AssetImage('assets/login/noPicture.png'),
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }

  static Future<ImageProvider> _getCachedImage(String url) async {
    if (!url.startsWith('http')) return AssetImage(url);
    
    final cachedFile = await ImageCacheService.getImage(url);
    if (cachedFile != null && cachedFile.existsSync()) {
      return FileImage(cachedFile);
    }
    return NetworkImage(url);
  }
}