import 'package:flutter/material.dart';

void main() {
  runApp(const SmartCartApp());
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartCart',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF7F5FC),
      ),
      home: const HomePage(),
    );
  }
}

class ShoppingItem {
  String name;
  String category;
  bool checked;

  ShoppingItem({
    required this.name,
    required this.category,
    this.checked = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<ShoppingItem> items = [
    ShoppingItem(name: 'Milk', category: 'Dairy'),
    ShoppingItem(name: 'Bread', category: 'Bakery'),
    ShoppingItem(name: 'Apples', category: 'Fruits'),
    ShoppingItem(name: 'Eggs', category: 'Dairy'),
    ShoppingItem(name: 'Tomatoes', category: 'Vegetables'),
  ];

  void addItem() {
    final controller = TextEditingController();
    String category = 'Groceries';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Shopping Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Item name',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: const [
                      'Groceries',
                      'Dairy',
                      'Fruits',
                      'Vegetables',
                      'Bakery',
                      'Household',
                    ].map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => category = value);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        items.add(
                          ShoppingItem(
                            name: controller.text.trim(),
                            category: category,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteItem(int index) {
    setState(() => items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final checkedCount = items.where((item) => item.checked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shopping_cart_rounded),
            SizedBox(width: 10),
            Text(
              'SmartCart',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              child: Text('C'),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildHome(checkedCount),
          buildCategories(),
          buildProfile(),
        ],
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: addItem,
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt_rounded),
            label: 'My List',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category_rounded),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildHome(int checkedCount) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C4DFF), Color(0xFF5E35B1)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good shopping!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'What do you need today?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Keep your list simple and smart',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: statCard(
                'Total Items',
                '${items.length}',
                Icons.shopping_cart_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: statCard(
                'Completed',
                '$checkedCount',
                Icons.check_circle_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Shopping List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  for (final item in items) {
                    item.checked = true;
                  }
                });
              },
              child: const Text('Complete all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Text('Your shopping list is empty'),
            ),
          ),
        ...items.asMap().entries.map(
          (entry) => itemCard(entry.key, entry.value),
        ),
      ],
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Color(0x14000000),
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemCard(int index, ShoppingItem item) {
    return Dismissible(
      key: ValueKey('${item.name}-$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => deleteItem(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          leading: Checkbox(
            value: item.checked,
            onChanged: (value) {
              setState(() => item.checked = value ?? false);
            },
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration:
                  item.checked ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(item.category),
          trailing: Icon(
            Icons.drag_indicator_rounded,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget buildCategories() {
    final categories = [
      ['Groceries', Icons.local_grocery_store_outlined],
      ['Dairy', Icons.egg_outlined],
      ['Fruits', Icons.apple_outlined],
      ['Vegetables', Icons.eco_outlined],
      ['Bakery', Icons.bakery_dining_outlined],
      ['Household', Icons.home_outlined],
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Organize your shopping items',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 22),
        ...categories.map(
          (category) => Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(category[1] as IconData),
              ),
              title: Text(
                category[0] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 48,
          child: Text(
            'C',
            style: TextStyle(fontSize: 38),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'SmartCart User',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 30),
        Card(
          elevation: 0,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Account'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
