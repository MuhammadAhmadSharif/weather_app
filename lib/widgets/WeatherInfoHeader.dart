import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/provider/weatherProvider.dart';
import 'package:flutter_weather/theme/textStyle.dart';
import 'package:flutter_weather/widgets/customShimmer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeatherInfoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProv, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            weatherProv.isLoading || weatherProv.weather == null
                ? Expanded(
                    child: CustomShimmer(
                      height: 48.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                            child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: '${weatherProv.weather?.city ?? ''}, ',
                            style: semiboldText(context),
                            children: [
                              TextSpan(
                                text: Country.tryParse(
                                            weatherProv.weather?.countryCode ??
                                                '92')
                                        ?.name ??
                                    '',
                                style: regularText(context)
                                    .copyWith(fontSize: 18.0),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 4.0),
                        FittedBox(
                          child: Text(
                            DateFormat('EEE, MMM d • h:mm a')
                                .format(DateTime.now()),
                            style: regularText(context)
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
            const SizedBox(width: 8.0),
            _UnitToggle(
              isCelsius: weatherProv.isCelsius,
              isLoading: weatherProv.isLoading,
              onToggle: () => weatherProv.switchTempUnit(),
            ),
          ],
        );
      },
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final bool isCelsius;
  final bool isLoading;
  final VoidCallback onToggle;
  const _UnitToggle({
    required this.isCelsius,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onToggle,
      child: Container(
        height: 40,
        width: 120,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment:
                  isCelsius ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 54,
                decoration: BoxDecoration(
                  color: isLoading
                      ? Theme.of(context).dividerColor
                      : Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 54,
                  child: Center(
                    child: Text(
                      '°C',
                      style: semiboldText(context).copyWith(
                        fontSize: 14,
                        color: isCelsius ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 54,
                  child: Center(
                    child: Text(
                      '°F',
                      style: semiboldText(context).copyWith(
                        fontSize: 14,
                        color: isCelsius ? Colors.grey.shade600 : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
