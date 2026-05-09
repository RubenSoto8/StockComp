import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/component.dart';
import '../database/db_helper.dart';
import '../widgets/inventory_card.dart';
import '../widgets/add_edit_sheet.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Map<String, List<Component>> _grouped = {};
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    _loadComponents();
  }

  Future<void> _loadComponents() async {
    final components = await DBHelper.instance.getComponents();
    final Map<String, List<Component>> grouped = {};
    for (final c in components) {
      grouped.putIfAbsent(c.category, () => []).add(c);
    }
    setState(() => _grouped = grouped);
  }

  void _openEditSheet(Component component) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditSheet(
        component: component,
        onSave: _loadComponents,
      ),
    );
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditSheet(onSave: _loadComponents),
    );
  }

  Future<void> _increment(Component component) async {
    await DBHelper.instance.updateQuantity(
      component.id!,
      component.quantity + 1,
    );
    _loadComponents();
  }

  Future<void> _decrement(Component component) async {
    if (component.quantity <= 0) return;
    await DBHelper.instance.updateQuantity(
      component.id!,
      component.quantity - 1,
    );
    _loadComponents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D1F),
        elevation: 0,
        title: Text(
          'Categories',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _grouped.isEmpty
          ? Center(
              child: Text(
                'No components yet\nadd your first one!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white38,
                  fontSize: 16,
                ),
              ),
            )
          : ListView(
              children: _grouped.entries.map((entry) {
                final category = entry.key;
                final components = entry.value;
                final isExpanded = _expanded.contains(category);
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expanded.remove(category);
                          } else {
                            _expanded.add(category);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                category,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B4D8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${components.length}',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      ...components.map((component) => InventoryCard(
                            component: component,
                            onIncrement: () => _increment(component),
                            onDecrement: () => _decrement(component),
                            onLongPress: () => _openEditSheet(component),
                          )),
                  ],
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: const Color(0xFF00B4D8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}