import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const SubscriptionManagerApp());
}

class SubscriptionManagerApp extends StatelessWidget {
  const SubscriptionManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscription Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primaryColor: const Color(0xFF6366F1),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFFEC4899),
          surface: Colors.white,
          background: Color(0xFFF8F9FA),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const SubscriptionHomePage(),
    );
  }
}

class SubscriptionHomePage extends StatefulWidget {
  const SubscriptionHomePage({super.key});

  @override
  State<SubscriptionHomePage> createState() => _SubscriptionHomePageState();
}

class _SubscriptionHomePageState extends State<SubscriptionHomePage> {
  final List<Subscription> _subscriptions = [
    Subscription(
      name: 'Netflix',
      category: 'Entertainment',
      amount: 15.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.now().add(const Duration(days: 5)),
      color: const Color(0xFFE50914),
      icon: Icons.movie,
    ),
    Subscription(
      name: 'Spotify',
      category: 'Music',
      amount: 9.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.now().add(const Duration(days: 12)),
      color: const Color(0xFF1DB954),
      icon: Icons.music_note,
    ),
    Subscription(
      name: 'Adobe Creative Cloud',
      category: 'Software',
      amount: 54.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.now().add(const Duration(days: 20)),
      color: const Color(0xFFFF0000),
      icon: Icons.design_services,
    ),
  ];

  String _selectedFilter = 'All';
  bool _showAddDialog = false;

  double get totalMonthlySpending {
    return _subscriptions.fold(0.0, (sum, sub) {
      if (sub.billingCycle == BillingCycle.monthly) {
        return sum + sub.amount;
      } else if (sub.billingCycle == BillingCycle.yearly) {
        return sum + (sub.amount / 12);
      }
      return sum;
    });
  }

  double get totalYearlySpending {
    return _subscriptions.fold(0.0, (sum, sub) {
      if (sub.billingCycle == BillingCycle.monthly) {
        return sum + (sub.amount * 12);
      } else if (sub.billingCycle == BillingCycle.yearly) {
        return sum + sub.amount;
      }
      return sum;
    });
  }

  List<Subscription> get filteredSubscriptions {
    if (_selectedFilter == 'All') return _subscriptions;
    return _subscriptions.where((sub) => sub.category == _selectedFilter).toList();
  }

  List<String> get categories {
    final cats = _subscriptions.map((s) => s.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  void _addSubscription(Subscription subscription) {
    setState(() {
      _subscriptions.add(subscription);
      _showAddDialog = false;
    });
  }

  void _deleteSubscription(int index) {
    setState(() {
      _subscriptions.removeAt(index);
    });
  }

  void _editSubscription(int index, Subscription updatedSubscription) {
    setState(() {
      _subscriptions[index] = updatedSubscription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Subscriptions',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Color(0xFF6B7280)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Color(0xFF6B7280)),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Cards
                      _buildStatsSection(),
                      const SizedBox(height: 32),

                      // Filter Chips
                      _buildFilterSection(),
                      const SizedBox(height: 24),

                      // Subscriptions Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Your Subscriptions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            '${filteredSubscriptions.length} active',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Subscriptions List
                      _buildSubscriptionsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Add Button
          Positioned(
            right: 24,
            bottom: 24,
            child: FloatingActionButton.extended(
              onPressed: () {
                _showAddSubscriptionDialog();
              },
              backgroundColor: const Color(0xFF6366F1),
              icon: const Icon(Icons.add),
              label: const Text('Add Subscription'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildStatCard(
              'Monthly Spending',
              '\$${totalMonthlySpending.toStringAsFixed(2)}',
              Icons.calendar_today,
              const Color(0xFF6366F1),
              isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth,
            ),
            _buildStatCard(
              'Yearly Spending',
              '\$${totalYearlySpending.toStringAsFixed(2)}',
              Icons.date_range,
              const Color(0xFFEC4899),
              isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth,
            ),
            _buildStatCard(
              'Active Subscriptions',
              '${_subscriptions.length}',
              Icons.apps,
              const Color(0xFF10B981),
              isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedFilter == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF6366F1).withOpacity(0.1),
              checkmarkColor: const Color(0xFF6366F1),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubscriptionsList() {
    if (filteredSubscriptions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              Icon(Icons.subscriptions_outlined, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'No subscriptions yet',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first subscription to get started',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filteredSubscriptions.asMap().entries.map((entry) {
        final index = _subscriptions.indexOf(entry.value);
        final subscription = entry.value;
        return _buildSubscriptionCard(subscription, index);
      }).toList(),
    );
  }

  Widget _buildSubscriptionCard(Subscription subscription, int index) {
    final daysUntilBilling = subscription.nextBillingDate.difference(DateTime.now()).inDays;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showSubscriptionDetails(subscription, index);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: subscription.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    subscription.icon,
                    color: subscription.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subscription.category,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: daysUntilBilling <= 7
                                  ? const Color(0xFFFEF3C7)
                                  : const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Due in $daysUntilBilling days',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: daysUntilBilling <= 7
                                    ? const Color(0xFFD97706)
                                    : const Color(0xFF059669),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${subscription.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscription.billingCycle == BillingCycle.monthly ? '/month' : '/year',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AddSubscriptionDialog(
        onAdd: _addSubscription,
      ),
    );
  }

  void _showSubscriptionDetails(Subscription subscription, int index) {
    showDialog(
      context: context,
      builder: (context) => SubscriptionDetailsDialog(
        subscription: subscription,
        onDelete: () {
          Navigator.pop(context);
          _deleteSubscription(index);
        },
        onEdit: (updated) {
          Navigator.pop(context);
          _editSubscription(index, updated);
        },
      ),
    );
  }
}

// Models
enum BillingCycle { monthly, yearly }

class Subscription {
  final String name;
  final String category;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final Color color;
  final IconData icon;
  final String? notes;

  Subscription({
    required this.name,
    required this.category,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.color,
    required this.icon,
    this.notes,
  });

  Subscription copyWith({
    String? name,
    String? category,
    double? amount,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    Color? color,
    IconData? icon,
    String? notes,
  }) {
    return Subscription(
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      notes: notes ?? this.notes,
    );
  }
}

// Add Subscription Dialog
class AddSubscriptionDialog extends StatefulWidget {
  final Function(Subscription) onAdd;

  const AddSubscriptionDialog({super.key, required this.onAdd});

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  BillingCycle _billingCycle = BillingCycle.monthly;
  DateTime _nextBillingDate = DateTime.now().add(const Duration(days: 30));
  Color _selectedColor = const Color(0xFF6366F1);
  IconData _selectedIcon = Icons.subscriptions;

  final List<Color> _colors = [
    const Color(0xFF6366F1),
    const Color(0xFFEC4899),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
    const Color(0xFF06B6D4),
    const Color(0xFF84CC16),
  ];

  final List<IconData> _icons = [
    Icons.subscriptions,
    Icons.movie,
    Icons.music_note,
    Icons.games,
    Icons.fitness_center,
    Icons.school,
    Icons.design_services,
    Icons.cloud,
    Icons.newspaper,
    Icons.shopping_bag,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Subscription',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Service Name',
                          hintText: 'e.g., Netflix',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category
                      TextFormField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          hintText: 'e.g., Entertainment',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Amount
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          hintText: '0.00',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Billing Cycle
                      const Text(
                        'Billing Cycle',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCycleOption(BillingCycle.monthly, 'Monthly'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildCycleOption(BillingCycle.yearly, 'Yearly'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Next Billing Date
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Next Billing Date'),
                        subtitle: Text(DateFormat('MMM dd, yyyy').format(_nextBillingDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _nextBillingDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _nextBillingDate = date;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Color Picker
                      const Text(
                        'Color',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _colors.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Icon Picker
                      const Text(
                        'Icon',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _icons.map((icon) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIcon = icon;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _selectedIcon == icon
                                    ? _selectedColor.withOpacity(0.2)
                                    : Colors.grey[200],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedIcon == icon
                                      ? _selectedColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                icon,
                                color: _selectedIcon == icon
                                    ? _selectedColor
                                    : Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notes (optional)',
                          hintText: 'Add any notes...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Subscription'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCycleOption(BillingCycle cycle, String label) {
    final isSelected = _billingCycle == cycle;
    return GestureDetector(
      onTap: () {
        setState(() {
          _billingCycle = cycle;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF6B7280),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _handleAdd() {
    if (_formKey.currentState!.validate()) {
      final subscription = Subscription(
        name: _nameController.text,
        category: _categoryController.text,
        amount: double.parse(_amountController.text),
        billingCycle: _billingCycle,
        nextBillingDate: _nextBillingDate,
        color: _selectedColor,
        icon: _selectedIcon,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      widget.onAdd(subscription);
      Navigator.pop(context);
    }
  }
}

// Subscription Details Dialog
class SubscriptionDetailsDialog extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onDelete;
  final Function(Subscription) onEdit;

  const SubscriptionDetailsDialog({
    super.key,
    required this.subscription,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: subscription.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    subscription.icon,
                    color: subscription.color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subscription.category,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            _buildDetailRow(
              'Amount',
              '\$${subscription.amount.toStringAsFixed(2)} / ${subscription.billingCycle == BillingCycle.monthly ? "month" : "year"}',
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'Next Billing',
              DateFormat('MMM dd, yyyy').format(subscription.nextBillingDate),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'Days Until Billing',
              '${subscription.nextBillingDate.difference(DateTime.now()).inDays} days',
            ),
            if (subscription.notes != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subscription.notes!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Delete', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // For simplicity, we'll just show the add dialog in edit mode
                      // In a real app, you'd have a separate edit dialog
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}