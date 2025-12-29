import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/database_service.dart';
import '../models/order.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Order> _orders;

  @override
  void initState() {
    super.initState();
    _orders = DatabaseService.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '👤',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pelanggan Setia',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'pelanggan@tokoswya.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Pengaturan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, _) {
                            return ListTile(
                              leading: const Icon(Icons.dark_mode_outlined),
                              title: const Text('Mode Gelap'),
                              trailing: Switch(
                                value: themeProvider.isDarkMode,
                                onChanged: (_) {
                                  themeProvider.toggleTheme();
                                },
                              ),
                            );
                          },
                        ),
                        Divider(color: Colors.grey[300]),
                        const ListTile(
                          leading: Icon(Icons.language),
                          title: Text('Bahasa'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        Divider(color: Colors.grey[300]),
                        const ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text('Tentang Aplikasi'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Riwayat Pesanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Pesanan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (_orders.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Belum ada pesanan',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pesanan #${order.id}',
                                      style: Theme.of(context)
                                          .textTheme.bodyMedium
                                          ?.copyWith(
                                              fontWeight:
                                                  FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: order.status == 'completed'
                                            ? Colors.green
                                            : Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        order.status.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${order.items.length} item',
                                  style: Theme.of(context)
                                      .textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Total: Rp ${order.totalPrice.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme.bodyMedium
                                      ?.copyWith(
                                          fontWeight:
                                              FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}