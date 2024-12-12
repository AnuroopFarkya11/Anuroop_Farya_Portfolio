import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/core/utils/utils.dart';
import 'package:my_portfolio/models/project.dart';
import 'package:my_portfolio/provider/super.dart';
import 'package:my_portfolio/provider/theme.dart';

class WorkSection extends ConsumerWidget {
  final List<ProjectModel> projects;

  const WorkSection({
    Key? key,
    required this.projects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuperUser = ref.watch(isSuperUserProvider); // Watch the provider

    return Container(
      child: ScreenHelper(
        desktop: _buildUi(context, isSuperUser),
        tablet: _buildUi(context, isSuperUser),
        mobile: _buildUi(context, isSuperUser),
      ),
    );
  }

  Widget _buildUi(BuildContext context, bool isSuperUser) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Center(
        child: Wrap(
          children: [
            ...projects.map((e) => Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: _buildProject(context, e, isSuperUser),
            )),
            if (isSuperUser) // Add button visible only to super users
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: _buildAddProjectCard(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProject(BuildContext context, ProjectModel projectModel, bool isSuperUser) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: 400,
          child: Consumer(builder: (context, ref, _) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ref.watch(themeProvider).isDarkMode
                    ? const Color.fromARGB(75, 12, 12, 7)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      if (projectModel.appPhotos != null)
                        Image.network(
                          projectModel.appPhotos!,
                          width: constraints.maxWidth > 720.0 ? null : 350.0,
                          height: 250,
                        ),
                      const SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
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
                              style: GoogleFonts.josefinSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                                color: kCaptionColor,
                              ),
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
                                        backgroundColor:
                                        MaterialStatePropertyAll(
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isSuperUser)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showProjectDialog(context, projectModel: projectModel);
                        },
                      ),
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildAddProjectCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showProjectDialog(context);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: 400,
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return  Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ref.watch(themeProvider).isDarkMode
                        ? const Color.fromARGB(75, 12, 12, 7)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),

                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Add Project",
                        style: GoogleFonts.josefinSans(
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },

            ),
          );
        },
      ),
    );
  }

  void _showProjectDialog(BuildContext context, {ProjectModel? projectModel}) {
    // Create TextEditingController for each field
    final TextEditingController projectController = TextEditingController(text: projectModel?.project ?? '');
    final TextEditingController titleController = TextEditingController(text: projectModel?.title ?? '');
    final TextEditingController descriptionController = TextEditingController(text: projectModel?.description ?? '');
    final TextEditingController projectLinkController = TextEditingController(text: projectModel?.projectLink ?? '');
    final TextEditingController buttonTextController = TextEditingController(text: projectModel?.buttonText ?? '');
    final TextEditingController appPhotosController = TextEditingController(text: projectModel?.appPhotos ?? '');
    final TextEditingController techUsedController = TextEditingController(text: projectModel?.techUsed.map((e)=>e.name).join(', ') ?? '');

    // Photo selection variable
    String? photoUrl;

    // Show dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(projectModel == null ? "Add New Project" : "Edit Project"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Project name input
                TextField(
                  controller: projectController,
                  decoration: const InputDecoration(labelText: 'Project Name'),
                ),
                const SizedBox(height: 10),
                // Title input
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                // Description input
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                // Project link input
                TextField(
                  controller: projectLinkController,
                  decoration: const InputDecoration(labelText: 'Project Link (URL)'),
                ),
                const SizedBox(height: 10),
                // Button text input
                TextField(
                  controller: buttonTextController,
                  decoration: const InputDecoration(labelText: 'Button Text'),
                ),
                const SizedBox(height: 10),

                // Modern photo upload box
                GestureDetector(
                  onTap: () async {
                    // Open file picker to select a photo
                    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                    if (result != null) {
                      // If a file is picked, get the path of the file
                      photoUrl = result.files.single.path;
                      // Update the controller with the selected file path (or upload URL)
                      appPhotosController.text = photoUrl ?? '';
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_camera, size: 40, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'Add Photo',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Drag & Drop or Browse',
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Technologies used input
                TextField(
                  controller: techUsedController,
                  decoration: const InputDecoration(labelText: 'Technologies Used (comma separated)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Gather the data from controllers and validate
                final project = projectController.text;
                final title = titleController.text;
                final description = descriptionController.text;
                final projectLink = projectLinkController.text;
                final buttonText = buttonTextController.text;
                final appPhotos = appPhotosController.text;
                final techUsed = techUsedController.text.split(',').map((e) => e.trim()).toList();

                if (project.isEmpty || title.isEmpty || description.isEmpty || projectLink.isEmpty) {
                  // Basic validation to ensure required fields are filled
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all required fields")),
                  );
                  return;
                }

                // Logic for adding or editing the project
                if (projectModel == null) {
                  // Add new project logic
                  final newProject = {
                    "project": project,
                    "title": title,
                    "description": description,
                    "projectLink": projectLink,
                    "appPhotos": appPhotos,
                    "buttonText": buttonText,
                    "techUsed": techUsed,
                  };
                  ProjectModel.fromJson(newProject);
                  // Handle saving the new project (e.g., save to a database or list)
                  print("Adding Project: $newProject");
                } else {
                  // Edit existing project logic
                  final updatedProject = projectModel.copyWith(
                    project: project,
                    title: title,
                    description: description,
                    projectLink: projectLink,
                    appPhotos: appPhotos,
                    buttonText: buttonText,
                    techUsed: techUsed,
                  );
                  // Handle saving the updated project (e.g., update in a database or list)
                  print("Updating Project: $updatedProject");
                }

                Navigator.pop(context);
              },
              child: Text(projectModel == null ? "Add" : "Save"),
            ),
          ],
        );
      },
    );
  }


}
