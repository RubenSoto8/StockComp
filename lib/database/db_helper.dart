import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/component.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  DBHelper._init();

  static const String _key = 'components';
  static int _nextId = 1;

  Future<List<Component>> getComponents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    final components = jsonList
        .map((json) => Component.fromMap(jsonDecode(json)))
        .toList();
    if (components.isNotEmpty) {
      _nextId = components.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    components.sort((a, b) => a.name.compareTo(b.name));
    return components;
  }

  Future<void> _saveAll(List<Component> components) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = components.map((c) => jsonEncode(c.toMap())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  Future<Component> insertComponent(Component component) async {
    final components = await getComponents();
    final newComponent = component.copyWith(id: _nextId++);
    components.add(newComponent);
    await _saveAll(components);
    return newComponent;
  }

  Future<void> updateComponent(Component component) async {
    final components = await getComponents();
    final index = components.indexWhere((c) => c.id == component.id);
    if (index != -1) {
      components[index] = component;
      await _saveAll(components);
    }
  }

  Future<void> deleteComponent(int id) async {
    final components = await getComponents();
    components.removeWhere((c) => c.id == id);
    await _saveAll(components);
  }

  Future<void> updateQuantity(int id, int quantity) async {
    final components = await getComponents();
    final index = components.indexWhere((c) => c.id == id);
    if (index != -1) {
      components[index] = components[index].copyWith(quantity: quantity);
      await _saveAll(components);
    }
  }
}