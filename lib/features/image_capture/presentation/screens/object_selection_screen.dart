import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_projecet/core/constants/app_constants.dart';
import 'package:vision_projecet/core/utils/navigation_helper.dart';
import 'package:vision_projecet/core/widgets/grid_item_widget.dart';
import 'package:vision_projecet/features/image_capture/presentation/providers/object_selection_provider.dart';
import 'package:vision_projecet/features/object_detection/presentation/providers/object_detection_provicer.dart';
import 'package:vision_projecet/features/object_detection/presentation/screens/detection_screen.dart';

class ObjectSelectionScreen extends StatelessWidget {
  static const String route = '/image-select-screen';

  const ObjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Object Selection')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Select an Object',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<ObjectSelectionProvider>(
              builder: (context, objectSelectionProvider, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: AppConstants.selectableItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    String item = AppConstants.selectableItems[index];
                    return GridItem(
                      label: item,
                      isSelected: objectSelectionProvider.selectedObject == item,
                      onTap: () {
                        objectSelectionProvider.selectObject(item);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<ObjectSelectionProvider>(
              builder: (context, objectSelectionProvider, child) {
                return SizedBox(
                  width: 180,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: objectSelectionProvider.selectedObject == null
                        ? null
                        : () {
                            Provider.of<ObjectDetectionProvider>(context, listen: false)
                                .setSelectedObject(objectSelectionProvider.selectedObject!);

                            objectSelectionProvider.resetSelection();
                            NavigationHelper.navigateTo(context, const DetectionScreen());
                        },
                    child: const Text('Get Started', style: TextStyle(fontSize: 20)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
