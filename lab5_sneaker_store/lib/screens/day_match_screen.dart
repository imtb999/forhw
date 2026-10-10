import 'package:flutter/material.dart';

import '../services/day_match.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';

class DayMatchScreen extends StatefulWidget {
  const DayMatchScreen({super.key});

  @override
  State<DayMatchScreen> createState() => _DayMatchScreenState();
}

class _DayMatchScreenState extends State<DayMatchScreen> {
  String activity = 'Campus';
  double budget = 60000;

  @override
  Widget build(BuildContext context) {
    final match = findDayMatch(activity, budget.round());
    return Scaffold(
      appBar: AppBar(title: const Text('Your day. Your pair.')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'What is the plan?',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pick your day and budget. Your match updates instantly.',
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Campus', 'Walk', 'Workout'].map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: activity == option,
                        onSelected: (_) => setState(() => activity = option),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Budget: ${budget.round()} ₸',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    min: 20000,
                    max: 80000,
                    divisions: 12,
                    value: budget,
                    label: '${budget.round()} ₸',
                    semanticFormatterCallback: (value) =>
                        '${value.round()} tenge',
                    onChanged: (value) => setState(() => budget = value),
                  ),
                  const SizedBox(height: 16),
                  if (match == null)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No match within this budget. Try a higher budget or a different plan.',
                        ),
                      ),
                    )
                  else ...[
                    Text(
                      'WHY THIS PAIR',
                      style: TextStyle(
                        letterSpacing: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tagged for ${activity.toLowerCase()} in our demo collection. '
                      'Highest-rated match within your budget (${match.rating}/5). '
                      'You have ${budget.round() - match.price} ₸ left.',
                    ),
                    const SizedBox(height: 16),
                    ProductCard(
                      product: match,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ProductScreen(product: match),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Demo recommendations use sample tags, prices and ratings. Photos are illustrative.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
