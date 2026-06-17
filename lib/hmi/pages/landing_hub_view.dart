import 'package:flutter/material.dart';

class LandingHubView extends StatelessWidget {
  final Function(int) onNavigate;
  const LandingHubView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'title': 'Donate', 'image': 'Assets/img/donate.png', 'icon': 'favorite', 'index': 2},
      {'title': 'Volunteer', 'image': 'Assets/img/stongerTogether.png', 'icon': 'groups', 'index': 3},
      {'title': 'Membership', 'image': 'Assets/img/vicinumShield_TranspBG.png', 'icon': 'shield', 'index': 4},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool useHorizontalLayout = width >= 650 || (height < 500 && width > height);

        if (!useHorizontalLayout) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items.map((item) => _buildCardItem(item, 130)).toList(),
            ),
          );
        }

        double targetAssetHeight = height < 400 ? 90 : 150;
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items.map((item) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _buildCardItem(item, targetAssetHeight),
                  ),
                )).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardItem(Map<String, dynamic> item, double assetSize) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(item['index']),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: assetSize,
              width: assetSize,
              alignment: Alignment.center,
              child: Image.asset(
                item['image']!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  item['icon'] == 'favorite' ? Icons.favorite_border : item['icon'] == 'groups' ? Icons.lightbulb_outline : Icons.shield_outlined,
                  size: assetSize * 0.6,
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(item['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
          ],
        ),
      ),
    );
  }
}

