import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProfileDisplay extends StatelessWidget {
  final String name;
  final String classOrInstitution;
  final String? jobPosition;
  final Response? photoResponse;

  const ProfileDisplay({
    super.key,
    required this.name,
    required this.classOrInstitution,
    this.jobPosition,
    this.photoResponse,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth * 0.8, // Limit width to 80% of screen width
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 150,
              height: 150,
              color: Colors.white10, // Added background to ensure visibility
              child: photoResponse != null && photoResponse!.statusCode == 200
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: MemoryImage(photoResponse!.bodyBytes),
                    )
                  : const Opacity(
                      opacity: 0.85,
                      child: Image(
                        image: AssetImage('assets/images/foto_perfil.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16), // Added spacing
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8), // Added spacing
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    jobPosition ?? "Educando",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    " - ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    classOrInstitution,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
