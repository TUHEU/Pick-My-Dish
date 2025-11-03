import 'package:flutter/material.dart';

void main() {
  runApp(const IngredientApp());
}

class IngredientApp extends StatelessWidget {
  const IngredientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ingredient Selector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const IngredientPage(),
    );
  }
}

class IngredientPage extends StatefulWidget {
  const IngredientPage({super.key});

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _availableIngredients = [
    'Tomatoes',
    'Onions',
    'Garlic',
    'Salt',
    'Pepper',
    'Olive Oil',
    'Chicken',
    'Rice',
  ];

  final List<String> _selectedIngredients = [];

  void _addIngredient(String ingredient) {
    if (ingredient.trim().isEmpty) return;
    setState(() {
      if (!_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.add(ingredient);
      }
    });
    _controller.clear();
  }

  void _clearAll() {
    setState(() => _selectedIngredients.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Selector'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Manual input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter ingredient manually',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addIngredient(_controller.text),
                  child: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Dropdown list
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select from list',
                border: OutlineInputBorder(),
              ),
              items: _availableIngredients.map((ingredient) {
                return DropdownMenuItem(
                  value: ingredient,
                  child: Text(ingredient),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) _addIngredient(value);
              },
            ),

            const SizedBox(height: 20),

            // Selected ingredients
            const Text(
              'Selected Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: _selectedIngredients.isEmpty
                  ? const Center(child: Text('No ingredients added yet.'))
                  : ListView.builder(
                      itemCount: _selectedIngredients.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_selectedIngredients[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _selectedIngredients.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Clear button
            if (_selectedIngredients.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
