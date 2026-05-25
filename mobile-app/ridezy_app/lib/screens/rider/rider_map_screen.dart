// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/map_style.dart';
import '../../core/constants/typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../services/socket_service.dart';

class RiderMapScreen extends StatefulWidget {
  const RiderMapScreen({super.key});

  @override
  State<RiderMapScreen> createState() => _RiderMapScreenState();
}

class _RiderMapScreenState extends State<RiderMapScreen> {
  GoogleMapController? _mapController;
  LatLng _driverLocation = const LatLng(28.4595, 77.0266);
  bool _aiSafe = true;

  @override
  void initState() {
    super.initState();
    SocketService.connect();
    SocketService.socket.on('vehicle_update', (data) {
      if (!mounted) return;
      setState(() {
        _driverLocation = LatLng(data['lat'], data['lng']);
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_driverLocation),
      );
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dark-styled map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _driverLocation,
              zoom: 15,
            ),
            onMapCreated: (c) {
              _mapController = c;
              c.setMapStyle(kDarkMapStyle);
            },
            markers: {
              Marker(
                markerId: const MarkerId('driver'),
                position: _driverLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet,
                ),
              ),
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderRadius: 20,
                  glowColor: AppColors.glowCyan,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: AppColors.textPrimary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text('Live Tracking', style: AppTypography.cardHeading(size: 17)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.glowGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.glowGreen.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.glowGreen,
                              ),
                            )
                                .animate(onPlay: (c) => c.repeat())
                                .fadeOut(duration: 700.ms)
                                .then()
                                .fadeIn(duration: 700.ms),
                            const SizedBox(width: 5),
                            Text('Live',
                                style: AppTypography.label(
                                    size: 11, color: AppColors.glowGreen)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom AI status panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GlassCard(
                  glowColor: _aiSafe ? AppColors.glowGreen : AppColors.error,
                  glowIntensity: 0.2,
                  gradient: LinearGradient(
                    colors: [
                      (_aiSafe ? AppColors.glowGreen : AppColors.error)
                          .withOpacity(0.12),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _aiSafe
                                ? Icons.shield_rounded
                                : Icons.warning_rounded,
                            color: _aiSafe
                                ? AppColors.glowGreen
                                : AppColors.error,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AI Driving Status',
                                  style: AppTypography.label(size: 12)),
                              Text(
                                _aiSafe
                                    ? 'Safe Driving Detected'
                                    : 'Anomaly Detected',
                                style: AppTypography.cardHeading(
                                  size: 16,
                                  color: _aiSafe
                                      ? AppColors.glowGreen
                                      : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text('96/100',
                              style: AppTypography.dataDisplay(
                                  size: 24,
                                  color: AppColors.glowGreen)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _statusChip(Icons.route, '4.2 km left'),
                          const SizedBox(width: 8),
                          _statusChip(Icons.access_time, '8 min ETA'),
                          const SizedBox(width: 8),
                          _statusChip(Icons.currency_rupee, '₹340'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(text, style: AppTypography.metadata(size: 11)),
        ],
      ),
    );
  }
}
