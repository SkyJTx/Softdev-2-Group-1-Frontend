import 'package:flutter/material.dart';
import 'package:ruam_mitt/RuamMitr/Component/theme.dart';
import 'package:ruam_mitt/TuachuayDekhor/Component/search_box.dart';
import 'package:ruam_mitt/global_const.dart';
import 'package:ruam_mitt/global_var.dart';
// import 'package:ruam_mitt/RuamMitr/Component/home_v2/central_v2.dart';

class NavbarTuachuayDekhor extends StatelessWidget {
  const NavbarTuachuayDekhor({
    super.key,
    this.username,
    this.avatarUrl,
  });
  final String? username;
  final String? avatarUrl;

  Widget getAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white.withOpacity(0.5),
      backgroundImage: NetworkImage(profileData['imgPath']),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeProvider themeProvider = ThemesPortal.getCurrent(context);
    CustomThemes theme = ThemesPortal.appThemeFromContext(context, "TuachuayDekhor")!;
    Map<String, Color> customColors = theme.customColors;
    const double navbarHeight = 100;
    const double paddingSize = 30;

    return Container(
      padding: const EdgeInsets.all(paddingSize * 0.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            customColors["background"]!,
            customColors["background"]!.withOpacity(0),
          ],
        ),
      ),
      height: navbarHeight,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                if (ModalRoute.of(context)!.settings.name == tuachuayDekhorPageRoute["home"]!) {
                  return;
                }
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  tuachuayDekhorPageRoute["home"]!,
                  (route) => !route.settings.name!.contains("TuachuayDekhor"),
                );
              },
              child: Image(
                image: AssetImage(
                  "assets/images/Logo/TuachuayDekhor_${themeProvider.isDarkMode("TuachuayDekhor") ? "Dark" : "Light"}.png",
                ),
              ),
            ),
          ),
          const Flexible(
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: TuachuaySearchBox(),
            ),
          ),
          RawMaterialButton(
            shape: const CircleBorder(),
            onPressed: () {
              showMenu(
                context: context,
                color: customColors["container"]!,
                surfaceTintColor: customColors["container"],
                position: RelativeRect.fromLTRB(
                  size.width,
                  navbarHeight + paddingSize * 0.25,
                  0,
                  0,
                ),
                items: [
                  if (profileData['role'] == "Admin")
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            color: customColors["onContainer"]!,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Admin",
                            style: TextStyle(
                              color: customColors["onContainer"]!,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, tuachuayDekhorPageRoute["admin"]!);
                      },
                    ),
                  if (profileData['role'] == "User")
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: customColors["onContainer"]!,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(
                              color: customColors["onContainer"]!,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, tuachuayDekhorPageRoute["profile"]!);
                      },
                    ),
                  if (profileData['role'] == "User")
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.report,
                            color: Color.fromRGBO(217, 192, 41, 1),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Report",
                            style: TextStyle(
                              color: Color.fromRGBO(217, 192, 41, 1),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, tuachuayDekhorPageRoute["reportapp"]!);
                      },
                    ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "RuamMitr",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        ruamMitrPageRoute["home"]!,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              );
            },
            child: getAvatar(context),
          ),
        ],
      ),
    );
  }
}
