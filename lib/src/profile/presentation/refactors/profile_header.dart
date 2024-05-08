import 'package:clean_arch_bloc_2/core/common/app/providers/user_provider.dart';
import 'package:clean_arch_bloc_2/core/extensions/context_extension.dart';
import 'package:clean_arch_bloc_2/core/res/colours.dart';
import 'package:clean_arch_bloc_2/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // see as mentioned on the signUp screen we are storing
    // userData locally using provider controller, cause we
    // are using that userData here in the profile screen,
    // so we can directly call the provider controller's
    // getter to get the userData, and if some changes occur
    // in userData, we will update the userData locally too,
    // so as this page is connected with that, this page will be
    // updated too even though not connected with bloc so bloc's changes
    // won't reflect here. that's where provider comes in handy.

    // so if using bloc for fetching data, and using that data elsewhere,
    // then we are using provider to store that data locally to reflect that
    // change in a different screen to which is connected to provider but not
    // with bloc.

    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image = user?.profilePic == null || user!.profilePic!.isEmpty
            ? null
            : user.profilePic;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: image != null
                  ? NetworkImage(image)
                  : const AssetImage(MediaRes.user) as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? 'No User',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),

            // this : ...[] is just like a Column widget taking
            // children as arguments. shorter form.
            // could have also used a Column widget.
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * .15,
                ),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colours.neutralTextColour,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
