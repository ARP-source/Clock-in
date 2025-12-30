import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focustrophy/features/settings/bloc/premium_status_bloc.dart';
import 'package:focustrophy/core/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService _settingsService;
  bool _soundEffects = true;
  bool _vibrations = true;

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsService.init();
    setState(() {
      _soundEffects = _settingsService.soundEffectsEnabled;
      _vibrations = _settingsService.vibrationsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumSection(),
              const SizedBox(height: 24),
              _buildGeneralSettings(),
              const SizedBox(height: 24),
              _buildDataManagement(context),
              const SizedBox(height: 24),
              _buildAboutSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumSection() {
    return BlocBuilder<PremiumStatusBloc, PremiumStatusState>(
      builder: (context, state) {
        final isPremium = state is PremiumStatusLoaded && state.isPremium;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    const Text(
                      'Premium',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!isPremium) ...[
                  const Text(
                    'Remove ads and unlock Marathon Mode (Ultradian)',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PremiumStatusBloc>().add(PurchasePremium());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Upgrade to Premium',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.read<PremiumStatusBloc>().add(RestorePurchases());
                    },
                    child: const Text('Restore Purchases'),
                  ),
                ] else ...[
                  const Text(
                    'Thank you for supporting FocusTrophy!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Ad-free experience'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Marathon Mode unlocked'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Sound Effects'),
              subtitle: const Text('Play sounds for button clicks and timer events'),
              value: _soundEffects,
              onChanged: (value) async {
                await _settingsService.setSoundEffects(value);
                setState(() {
                  _soundEffects = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              subtitle: const Text('Vibrate when timer completes and break starts'),
              value: _vibrations,
              onChanged: (value) async {
                await _settingsService.setVibrations(value);
                setState(() {
                  _vibrations = value;
                });
              },
            ),
            ListTile(
              title: const Text('Break Reminder'),
              subtitle: const Text('Notify when break time ends'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show break reminder settings
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataManagement(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Export Data'),
              subtitle: const Text('Export your session data'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showComingSoonDialog(context, 'Export Data');
              },
            ),
            ListTile(
              title: const Text('Clear All Data'),
              subtitle: const Text('Delete all sessions and subjects'),
              trailing: const Icon(Icons.chevron_right),
              textColor: Colors.red,
              onTap: () {
                _showClearDataDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showComingSoonDialog(context, 'Version Info');
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showComingSoonDialog(context, 'Privacy Policy');
              },
            ),
            ListTile(
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showComingSoonDialog(context, 'Terms of Service');
              },
            ),
            ListTile(
              title: const Text('Contact Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showComingSoonDialog(context, 'Contact Support');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(feature),
          content: const Text('This feature is coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear All Data?'),
          content: const Text(
            'This will permanently delete all your sessions and subjects. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear all data
                // In a real app, this would be handled by a dedicated bloc
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared successfully'),
                  ),
                );
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}