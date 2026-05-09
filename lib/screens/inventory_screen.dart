import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/component.dart';
import '../database/db_helper.dart';
import '../widgets/inventory_card.dart';
import '../widgets/add_edit_sheet.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Component> _components = [];
  List<Component> _filtered = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComponents();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadComponents() async {
    final components = await DBHelper.instance.getComponents();
    setState(() {
      _components = components;
      _filtered = components;
    });
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _components
          .where((c) => c.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditSheet(onSave: _loadComponents),
    );
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
          'StockComp',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.nunito(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search components...',
                hintStyle: GoogleFonts.nunito(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
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
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final component = _filtered[index];
                      return InventoryCard(
                        component: component,
                        onIncrement: () => _increment(component),
                        onDecrement: () => _decrement(component),
                        onLongPress: () => _openEditSheet(component),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: const Color(0xFF00B4D8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}