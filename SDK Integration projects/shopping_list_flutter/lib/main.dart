
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const nativeChannel =
    MethodChannel('com.example.shoppinglist/native');

void main() {
  runApp(const ShoppingListApp());
}

class ShoppingItem {
  final int id;
  final String name;
  final int quantity;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
  });

  factory ShoppingItem.fromMap(Map<dynamic, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as int,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
    );
  }
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() =>
      _ShoppingListScreenState();
}

class _ShoppingListScreenState
    extends State<ShoppingListScreen> {

  List<ShoppingItem> items = [];
  bool isLoading = true;

  final nameController = TextEditingController();
  final quantityController =
      TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    try {
      final result =
          await nativeChannel.invokeMethod<List<dynamic>>(
        'getItems',
      );

      final loadedItems = (result ?? [])
          .map(
            (item) => ShoppingItem.fromMap(
              Map<dynamic, dynamic>.from(item as Map),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        items = loadedItems;
        isLoading = false;
      });
    } on PlatformException catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not load items: ${error.message}',
          ),
        ),
      );
    }
  }

  Future<void> _saveItem({
    ShoppingItem? item,
  }) async {
    nameController.text = item?.name ?? '';
    quantityController.text =
        (item?.quantity ?? 1).toString();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            item == null ? 'Add Item' : 'Edit Item',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final quantity = int.tryParse(
                  quantityController.text.trim(),
                );

                if (name.isEmpty ||
                    quantity == null ||
                    quantity <= 0) {
                  ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Enter a name and positive quantity.',
                    ),
                  ),
                );
                  return;
                }

                try {
                  if (item == null) {
                    await nativeChannel.invokeMethod(
                      'addItem',
                      {
                        'name': name,
                        'quantity': quantity,
                      },
                    );
                  } else {
                    await nativeChannel.invokeMethod(
                      'editItem',
                      {
                        'id': item.id,
                        'name': name,
                        'quantity': quantity,
                      },
                    );
                  }

                  if (!mounted) return;

                  Navigator.pop(dialogContext);
                  await _loadItems();
                } on PlatformException catch (error) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      error.message ?? 'Operation failed',
                    ),
                  ),
                );
                }
              },
              child: Text(
                item == null ? 'Add' : 'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(ShoppingItem item) async {
    try {
      await nativeChannel.invokeMethod<bool>(
        'deleteItem',
        {'id': item.id},
      );

      await _loadItems();
    } on PlatformException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'Could not delete item',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : items.isEmpty
              ? const Center(
                  child: Text(
                    'No items yet. Tap + to add one.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                          'Quantity: ${item.quantity}',
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                              ),
                              onPressed: () =>
                                  _saveItem(item: item),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  _deleteItem(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _saveItem(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}
