import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticketing_system/frontend/modules/text_fields.dart';
import 'package:ticketing_system/frontend/modules/skeletons.dart';
import 'package:ticketing_system/frontend/strings/account_hints.dart';
import 'package:ticketing_system/models/app.dart';
import 'package:ticketing_system/models/user.dart';

class UserProfilePage extends StatefulWidget {
  final ValueNotifier<User?> user;
  final Future<SharedPreferences> sharedPrefs;
  final VoidCallback onLogout;

  const UserProfilePage({
    super.key,
    required this.user,
    required this.sharedPrefs,
    required this.onLogout,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Image? profileImage;
  User? user;
  bool imageLoading = true;

  @override
  void initState() {
    user = widget.user.value;

    if (user != null && user!.pictureUrl != null) {
      profileImage = Image.network(
        user!.pictureUrl.toString(),
        key: Key("${user!.username} - Profile Image"),
        fit: BoxFit.cover,
      );

      profileImage!.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (image, synchronousCall) {
            if (mounted) {
              setState(() {
                imageLoading = false;
              });
            }
          },
        ),
      );
    }

    widget.user.addListener(() {
      if (mounted) {
        setState(() {
          user = widget.user.value;
          profileImage = Image.network(
            user!.pictureUrl.toString(),
            key: Key("${user!.username} - Profile Image"),
            fit: BoxFit.cover,
          );
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar.medium(
            title: const Text("Account Details"),
            actions: [
              IconButton(
                onPressed: () {
                  widget.sharedPrefs.then(
                    (prefs) => prefs.remove(AppSharedPrefKeys.userData),
                  );
                  widget.onLogout();
                },
                icon: const Icon(Icons.logout),
              )
            ],
          ),
        ),
      ],
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: user != null
                      ? generateFullProfile(
                          user!,
                          profileImage,
                          imageLoading,
                        )
                      : generateFullProfileSkeleton(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Column generateFullProfile(User user, Image? profileImage, bool imageLoading) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Skeletonizer(
            enabled: imageLoading,
            child: Container(
              width: 75,
              height: 75,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Skeleton.replace(
                width: 80,
                height: 80,
                child: user.pictureUrl != null
                    ? profileImage!
                    : const ColoredBox(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                Text(
                  "(${user.username})",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  UserType.displayText(user.type),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      DescriptionTextField(
        name: "Name",
        controller: TextEditingController(text: user.name),
        description: AccountDetailsHints.name.text(user),
      ),
      DescriptionTextField(
        name: "Username",
        controller: TextEditingController(text: user.username),
        description: "This will be while logging in.",
      ),
      DescriptionTextField(
        name: "Email",
        controller: TextEditingController(
          text: user.email,
        ),
        description: AccountDetailsHints.email.text(user),
      ),
      DescriptionTextField(
        name: "Address",
        controller: TextEditingController(
          text: user.address,
        ),
        description: AccountDetailsHints.address.text(user),
        multiline: true,
      ),
    ],
  );
}
