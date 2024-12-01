import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/core/utils/utils.dart';
import 'package:my_portfolio/models/project.dart';
import 'package:my_portfolio/provider/theme.dart';

class ProjectSection extends StatelessWidget {
  final List<ProjectModel> projects;
  const ProjectSection({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: projects
              .map((e) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: _buildProject(width, e)))
              .toList(),
        ),
      ),
    );
  }

  Center _buildProject(double width, ProjectModel projectModel) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: width,
            child: Consumer(builder: (context, ref, _) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: ref.watch(themeProvider).isDarkMode
                        ? const Color.fromARGB(75, 12, 12, 7)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: Flex(
                  direction: ScreenHelper.isMobile(context)
                      ? Axis.vertical
                      : Axis.horizontal,
                  children: [
                    if (projectModel.appPhotos != null)
                      SizedBox(
                        width: ScreenHelper.isMobile(context)
                            ? width * 0.9
                            : width * 0.46,
                        child: Image.network(
                          projectModel.appPhotos!,
                          width: constraints.maxWidth > 720.0 ? null : 350.0,
                          height: 250,
                          headers: {'Cookie':'_gh_sess=foKLntgfZF1%2F6xRw4fPPTnToZS7whJOBSDZD3mIBz28TatQSrzc5JwAMG2SPBoFXn4KSU6hhJqK%2FewdJKVrDyKgEviIyCpSdjdKkCJ5BdiUk2BU%2F9jFkRKt23d6NEYDCoLlG1om28K8bS6nmOdjE4vDtSG0xRurK8vLi0eeION%2BPZW%2FHRZcKhv%2FCSVqjz7R4fqqNEpeZr2p4EzxOmwudhJDrtmmaldJ0EVgoQn0mBed3%2FaFB4RDspIKANpntk%2FJ9VDc7SqzI3DrsXbrx0QF7BQ%3D%3D--tfjJ8QKPPpHgPJKu--Cmy%2BSFLHTQPXi1apzT8q%2Bg%3D%3D; _octo=GH1.1.317663603.1732595661; logged_in=no'},

                        ),
                      ),

                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: ScreenHelper.isMobile(context)
                          ? width * 0.9
                          : width * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            projectModel.project,
                            style: GoogleFonts.josefinSans(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            projectModel.title,
                            style: GoogleFonts.josefinSans(
                              fontWeight: FontWeight.w900,
                              height: 1.3,
                              fontSize: 28.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            projectModel.description,
                            style: const TextStyle(
                              color: kCaptionColor,
                              height: 1.5,
                              fontSize: 15.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          projectModel.techUsed.isEmpty
                              ? Container()
                              : Text(
                                  "Technologies Used",
                                  style: GoogleFonts.josefinSans(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16.0,
                                  ),
                                ),
                          Wrap(
                            children: projectModel.techUsed
                                .map((e) => Container(
                                      margin: const EdgeInsets.all(10),
                                      width: 25,
                                      color:
                                          e.logo == AppConstants.razorPayImage
                                              ? Colors.white
                                              : null,
                                      height: 25,
                                      child: Image.asset(e.logo),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                        kPrimaryColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (projectModel.internalLink) {
                                        context
                                            .goNamed(projectModel.projectLink);
                                      } else {
                                        Utilty.openUrl(
                                            projectModel.projectLink);
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        (projectModel.buttonText ??
                                                "Explore MORE")
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                    // Expanded(
                    //   flex: constraints.maxWidth > 720.0 ? 1 : 0,
                    //   child: ,
                    // )
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
