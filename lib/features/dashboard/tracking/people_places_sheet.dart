library people_places_sheet;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suraksha/core/constants/app_constants.dart';
import 'package:suraksha/core/constants/copy_constants.dart';
import 'package:suraksha/features/dashboard/dashboard_provider.dart';
import 'package:suraksha/features/dashboard/tracking/widgets/people_list_tile.dart';
import 'package:suraksha/features/dashboard/tracking/widgets/places_list_tile.dart';
import 'package:suraksha/theme/suraksha_colors.dart';
import 'package:suraksha/theme/suraksha_spacing.dart';
import 'package:suraksha/theme/suraksha_typography.dart';

class PeoplePlacesSheet extends ConsumerStatefulWidget {
  const PeoplePlacesSheet({super.key});

  @override
  ConsumerState<PeoplePlacesSheet> createState() => _PeoplePlacesSheetState();
}

class _PeoplePlacesSheetState extends ConsumerState<PeoplePlacesSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final index = _tabController.index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(dashboardProvider.notifier).setSheetTab(index);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final family = ref.watch(familyMembersProvider);
    final familyUi = ref.watch(familyListUiStateProvider);
    final places = ref.watch(dashboardProvider).places;

    return DraggableScrollableSheet(
      initialChildSize: AppConstants.sheetInitialSize,
      minChildSize: AppConstants.sheetMinSize,
      maxChildSize: AppConstants.sheetMaxSize,
      snap: true,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: dashboardSheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(S.radiusXl)),
        ),
        child: Column(
          children: [
            const SizedBox(height: S.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: surakshaMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: surakshaForeground,
              indicatorWeight: 2,
              labelColor: surakshaForeground,
              unselectedLabelColor: surakshaMuted,
              labelStyle: SurakshaTypography.dashTitle.copyWith(fontSize: 15),
              tabs: const [
                Tab(text: CopyConstants.peopleTab),
                Tab(text: CopyConstants.placesTab),
              ],
            ),
            Expanded(
              child: RawScrollbar(
                controller: scrollController,
                thumbVisibility: true,
                thickness: 6,
                thumbColor: surakshaBorder,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _PeopleList(
                      scrollController: scrollController,
                      contacts: family,
                      uiState: familyUi,
                      onAdd: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(CopyConstants.addPeopleSnackbar),
                          ),
                        );
                      },
                    ),
                    _PlacesList(
                      scrollController: scrollController,
                      places: places,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeopleList extends StatelessWidget {
  const _PeopleList({
    required this.scrollController,
    required this.contacts,
    required this.uiState,
    required this.onAdd,
  });

  final ScrollController scrollController;
  final List contacts;
  final FamilyListUiState uiState;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(S.md),
        children: [
          if (uiState == FamilyListUiState.loading)
            const Padding(
              padding: EdgeInsets.all(S.lg),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (uiState == FamilyListUiState.error)
            Padding(
              padding: const EdgeInsets.all(S.md),
              child: Text(
                'Unable to load family list',
                style: SurakshaTypography.dashSubtitle,
                textAlign: TextAlign.center,
              ),
            )
          else if (uiState == FamilyListUiState.empty)
            Padding(
              padding: const EdgeInsets.all(S.md),
              child: Text(
                'No family members linked yet.',
                style: SurakshaTypography.dashSubtitle,
                textAlign: TextAlign.center,
              ),
            )
          else
            ...contacts.map((c) => PeopleListTile(contact: c)),
          const SizedBox(height: S.md),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, color: surakshaForeground),
            label: const Text(CopyConstants.addPeople),
            style: OutlinedButton.styleFrom(
              foregroundColor: surakshaForeground,
              side: const BorderSide(color: dashboardBorder),
              padding: const EdgeInsets.symmetric(vertical: S.md),
            ),
          ),
        ],
      );
}

class _PlacesList extends StatelessWidget {
  const _PlacesList({
    required this.scrollController,
    required this.places,
  });

  final ScrollController scrollController;
  final List places;

  @override
  Widget build(BuildContext context) => ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(S.md),
        children: places.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(S.lg),
                  child: Text(
                    'No places yet. Add one when you are ready.',
                    style: SurakshaTypography.dashSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            : places.map((p) => PlacesListTile(place: p)).toList(),
      );
}
