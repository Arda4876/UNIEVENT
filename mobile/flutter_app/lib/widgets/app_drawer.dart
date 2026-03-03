import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              final user = authProvider.currentUser;
              return UserAccountsDrawerHeader(
                accountName: Text(
                  user?.username ?? 'Konuk Kullanıcı',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(user?.email ?? 'guest@unievent.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color(0xFF6366F1),
                  child: Text(
                    (user?.username ?? 'G')[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Ana Sayfa',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.school,
                  title: 'Üniversiteler',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/universities');
                  },
                ),
                Divider(height: 24, indent: 16, endIndent: 16),
                _buildDrawerItem(
                  context,
                  icon: Icons.info,
                  title: 'Hakkında',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people,
                  title: 'Geliştiriciler',
                  onTap: () {
                    Navigator.pop(context);
                    _showDevelopersDialog(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.contact_mail,
                  title: 'İletişim',
                  onTap: () {
                    Navigator.pop(context);
                    _showContactDialog(context);
                  },
                ),
              ],
            ),
          ),
          Divider(),
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      authProvider.logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Çıkış Yap',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF6366F1)),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hakkında'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'UniEvent AI v1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'UniEvent AI, üniversite etkinliklerini keşfetmek ve yönetmek için tasarlanmış bir mobil uygulamadır.',
                style: TextStyle(height: 1.6),
              ),
              SizedBox(height: 16),
              Text(
                'Özellikler:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Üniversite etkinliklerini keşfet\n'
                  '• Bilet satın al\n'
                  '• Etkinlikleri kataloğunda kaydet\n'
                  '• Gelişmiş arama ve filtreleme'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void _showDevelopersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Geliştirici Ekibi'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDeveloperCard(
                name: 'Ahmet Yılmaz',
                role: 'Lead Developer',
                email: 'ahmet.yilmaz@unievent.com',
              ),
              SizedBox(height: 16),
              _buildDeveloperCard(
                name: 'Fatma Demir',
                role: 'UI/UX Designer',
                email: 'fatma.demir@unievent.com',
              ),
              SizedBox(height: 16),
              _buildDeveloperCard(
                name: 'Mehmet Kaya',
                role: 'Backend Developer',
                email: 'mehmet.kaya@unievent.com',
              ),
              SizedBox(height: 16),
              _buildDeveloperCard(
                name: 'Ayşe Türk',
                role: 'AI/ML Specialist',
                email: 'ayse.turk@unievent.com',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String name,
    required String role,
    required String email,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF6366F1).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(fontSize: 12, color: Color(0xFF6366F1)),
          ),
          SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('İletişim Bilgileri'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContactItem(
                icon: Icons.email,
                label: 'E-posta',
                value: 'info@unievent.com.tr',
              ),
              SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.phone,
                label: 'Telefon',
                value: '+90 (212) 555-1234',
              ),
              SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.location_on,
                label: 'Adres',
                value: 'İstanbul, Türkiye',
              ),
              SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.language,
                label: 'Web Sitesi',
                value: 'www.unievent.com.tr',
              ),
              SizedBox(height: 24),
              Text(
                'Sosyal Medya',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(Icons.facebook, 'Facebook'),
                  _buildSocialButton(Icons.camera_alt, 'Instagram'),
                  _buildSocialButton(Icons.chat, 'Twitter'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF6366F1), size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF6366F1).withOpacity(0.1),
          ),
          child: Icon(icon, color: Color(0xFF6366F1), size: 20),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
