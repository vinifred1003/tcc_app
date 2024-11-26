import 'package:flutter/material.dart';

class CenterButtons extends StatelessWidget {
  void Function() selectedScanQRCode;
  CenterButtons({super.key, required this.selectedScanQRCode});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.02;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.02;
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: ElevatedButton(
                  onPressed: selectedScanQRCode,
                  child: Text(
                    "Chegada",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).textTheme.labelLarge?.color,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(130, 70),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Saída",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).textTheme.labelLarge?.color,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(130, 70),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Advertência",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).textTheme.labelLarge?.color,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(125, 70),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Ficha",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).textTheme.labelLarge?.color,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(125, 70),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
