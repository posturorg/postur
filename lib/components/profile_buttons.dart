import 'package:flutter/material.dart';
import '../pages/qr_scan_page.dart';
import '../src/colors.dart';
import 'modals/edit_profile_modal.dart';

class ProfileButtons extends StatelessWidget {

  const ProfileButtons({
    super.key,
  });

  BoxDecoration tagBoxDecoration() {
    return const BoxDecoration(
      border: Border(
          bottom: BorderSide(
        color: backgroundWhite,
        width: 1.0,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScanPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                backgroundColor: absentRed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Scan',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              backgroundColor: const Color.fromARGB(255, 93, 93, 93),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
              ],
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                // context and builder are
                // required properties in this widget
                context: context,
                isScrollControlled: true,
                elevation: 0.0,
                backgroundColor: Colors.white,
                clipBehavior: Clip.antiAlias,
                showDragHandle: true,
                builder: (BuildContext context) {
                  return const EditProfileModal();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
