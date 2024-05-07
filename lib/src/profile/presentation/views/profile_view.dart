import 'package:clean_arch_bloc_2/core/common/widgets/gradient_background.dart';
import 'package:clean_arch_bloc_2/core/res/media_res.dart';
import 'package:clean_arch_bloc_2/src/profile/presentation/refactors/profile_header.dart';
import 'package:clean_arch_bloc_2/src/profile/presentation/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const ProfileAppBar(),
      body: GradientBackground(
        image: MediaRes.profileGradientBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [
            ProfileHeader(),
          ],
        ),
      ),
    );
  }
}
