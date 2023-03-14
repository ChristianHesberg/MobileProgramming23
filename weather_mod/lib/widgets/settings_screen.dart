import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:weather/models/app_state.dart';

import '../models/geocode.dart';
import '../repositories/geocode_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _typeAheadController = TextEditingController();
  bool useLocationService = false;
  GeoCode? location;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            onPressed: () => _onSave(state),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Use location service'),
              _buildLocationServiceSwitch(),
            ]),
            if (!useLocationService) _buildLocationField(context),
            if (location != null) _buildLocationCard(textTheme),
          ],
        ),
      ),
    );
  }

  _onSave(AppState state) {
    if (!useLocationService && location == null) return;
    if (useLocationService) {
      state.clearLocation();
    } else if (location != null) {
      state.setLocation(location!);
    }
    Navigator.of(context).pop();
  }

  Switch _buildLocationServiceSwitch() {
    return Switch(
      thumbIcon: thumbIcon,
      value: useLocationService,
      onChanged: (value) => setState(() {
        useLocationService = value;
        if (value) location = null;
      }),
    );
  }

  TypeAheadField<GeoCode> _buildLocationField(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final repo = Provider.of<GeoCodeRepository>(context);
    return TypeAheadField(
      textFieldConfiguration: const TextFieldConfiguration(
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Enter a place',
        ),
      ),
      onSuggestionSelected: (suggestion) => setState(() {
        _typeAheadController.text = suggestion.name;
        location = suggestion;
      }),
      itemBuilder: (context, itemData) => ListTile(
        leading: CircleAvatar(child: Text(itemData.countryCode)),
        title: Text(itemData.name),
        subtitle: Text('${itemData.latitude}, ${itemData.longitude}'),
      ),
      suggestionsCallback: (pattern) => repo.getGeoCodes(pattern),
    );
  }

  Card _buildLocationCard(TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          CircleAvatar(child: Text(location!.countryCode)),
          Text(location!.name, style: textTheme.headlineLarge),
          Text('(${location!.latitude}, ${location!.longitude})',
              style: textTheme.bodyMedium),
        ]),
      ),
    );
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
}
