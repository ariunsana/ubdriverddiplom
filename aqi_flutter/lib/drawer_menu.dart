import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String phoneNumber;
  final String code;

  const AppDrawer({
    Key? key,
    required this.phoneNumber,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFF2D1B69),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                ),
                SizedBox(height: 12),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'КОД : $code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.copy,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Миний аяллууд',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Тохиргоо',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.credit_card,
                  title: 'Хэтэвч',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.access_time,
                  title: 'Урамшуулал',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.flag_outlined,
                  title: 'Санал, гомдол',
                  onTap: () {},
                ),
                Divider(),
                _buildMenuItem(
                  icon: Icons.more_horiz,
                  title: 'Бусад',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLanguageButton('Монгол', true),
                _buildLanguageButton('English', false),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLanguageButton(String language, bool isSelected) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.white : Colors.grey[200],
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(language),
        ),
      ),
    );
  }
} 