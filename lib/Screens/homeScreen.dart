// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/weatherProvider.dart';
import '../theme/colors.dart';
import '../theme/textStyle.dart';
import '../widgets/WeatherInfoHeader.dart';
import '../widgets/mainWeatherDetail.dart';
import '../widgets/mainWeatherInfo.dart';
import '../widgets/sevenDayForecast.dart';
import '../widgets/twentyFourHourForecast.dart';

import 'requestError.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FloatingSearchBarController fsc = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    requestWeather();
  }

  Future<void> requestWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');

    if (lastCity != null && lastCity.isNotEmpty) {
      await Provider.of<WeatherProvider>(context, listen: false)
          .searchWeather(lastCity, context); // search using last saved city
    } else {
      await Provider.of<WeatherProvider>(context, listen: false)
          .getWeatherData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProv, _) {
          // if (!weatherProv.isLoading && !weatherProv.isLocationserviceEnabled)
          //   return LocationServiceErrorDisplay();

          // if (!weatherProv.isLoading &&
          //     weatherProv.locationPermission != LocationPermission.always &&
          //     weatherProv.locationPermission != LocationPermission.whileInUse) {
          //   return LocationPermissionErrorDisplay();
          // }

          if (weatherProv.isRequestError) return RequestErrorDisplay();

          // if (weatherProv.isSearchError) return SearchErrorDisplay(fsc: fsc);

          try {
            return Container(
              decoration: BoxDecoration(
                gradient: Theme.of(context).brightness == Brightness.dark
                    ? appBackgroundGradientDark
                    : appBackgroundGradient,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -120,
                    right: -80,
                    child: _AccentOrb(
                      size: 260,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.35),
                    ),
                  ),
                  Positioned(
                    bottom: -160,
                    left: -120,
                    child: _AccentOrb(
                      size: 320,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.15),
                    ),
                  ),
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16.0).copyWith(
                      top: kToolbarHeight +
                          MediaQuery.viewPaddingOf(context).top +
                          28.0,
                    ),
                    children: [
                      WeatherInfoHeader(),
                      const SizedBox(height: 18.0),
                      MainWeatherInfo(),
                      const SizedBox(height: 18.0),
                      MainWeatherDetail(),
                      const SizedBox(height: 24.0),
                      TwentyFourHourForecast(),
                      const SizedBox(height: 18.0),
                      SevenDayForecast(),
                      const SizedBox(height: 12.0),
                    ],
                  ),
                  CustomSearchBar(fsc: fsc),
                ],
              ),
            );
          } catch (e, stack) {
            print("Error in HomeScreen build: $e");
            print(stack);
            return const Center(
              child: Text('Unexpected error occurred. Check console.'),
            );
          }
        },
      ),
    );
  }
}

class CustomSearchBar extends StatefulWidget {
  final FloatingSearchBarController fsc;
  const CustomSearchBar({
    Key? key,
    required this.fsc,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  List<String> _citiesSuggestion = [
    'Lahore',
    'Faisalabad',
    'Karachi',
    'Islamabad',
    'Peshawar',
    'Rawalpindi',
  ];

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: widget.fsc,
      hint: 'Search city',
      clearQueryOnClose: false,
      scrollPadding: const EdgeInsets.only(top: 16.0, bottom: 56.0),
      transitionDuration: const Duration(milliseconds: 400),
      borderRadius: BorderRadius.circular(24.0),
      transitionCurve: Curves.easeInOut,
      accentColor: Theme.of(context).colorScheme.primary,
      hintStyle: regularText(context),
      queryStyle: regularText(context),
      physics: const BouncingScrollPhysics(),
      elevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      backdropColor: Colors.transparent,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {},
      onSubmitted: (query) async {
        widget.fsc.close();
        await Provider.of<WeatherProvider>(context, listen: false)
            .searchWeather(query, context);
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: PhosphorIcon(
            PhosphorIconsBold.magnifyingGlass,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FloatingSearchBarAction.icon(
          showIfClosed: false,
          showIfOpened: true,
          icon: PhosphorIcon(
            PhosphorIconsBold.x,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () {
            if (widget.fsc.query.isEmpty) {
              widget.fsc.close();
            } else {
              widget.fsc.clear();
            }
          },
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 6.0,
            shadowColor: Colors.black.withOpacity(0.08),
            child: ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _citiesSuggestion.length,
              itemBuilder: (context, index) {
                String data = _citiesSuggestion[index];
                return InkWell(
                  onTap: () async {
                    widget.fsc.query = data;
                    widget.fsc.close();
                    await Provider.of<WeatherProvider>(context, listen: false)
                        .searchWeather(data, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    child: Row(
                      children: [
                        PhosphorIcon(PhosphorIconsFill.mapPin),
                        const SizedBox(width: 22.0),
                        Text(data, style: mediumText(context)),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                thickness: 1.0,
                height: 0.0,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AccentOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _AccentOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}
