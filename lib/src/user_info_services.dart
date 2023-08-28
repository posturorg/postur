import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

Future<bool> isUsernameUnique(String queriedUsername) async {
  queriedUsername = queriedUsername.trim().toLowerCase(); //just in case
  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('Users');
  Query query = collection.where('username', isEqualTo: queriedUsername);

  try {
    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.size > 0) {
      print('Username already exists');
      return false;
    } else {
      print('Username is available');
      return true;
    }
  } catch (error) {
    // Handle error
    print('Error: $error');
    return false;
  }
}

Future<void> setUsername(
  dynamic stateSetter,
  TextEditingController enteredUsernameController,
) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

    //print('clicked!');
    await userDocRef.update({
      'hasUsername': true,
      'username': enteredUsernameController.text.trim().toLowerCase(),
    });
    if (stateSetter != null) {
      stateSetter();
    }
  } else {
    //should sign user out if user doesnt exist...
    FirebaseAuth.instance.signOut();
  }
}

Future<void> setName(
  //need to set full name field here...
  dynamic stateSetter,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);

    //print('clicked!');
    await userDocRef.update({
      'hasName': true,
      'name': {
        'first': firstNameController.text.trim(),
        'last': lastNameController.text.trim(),
      },
    });
    if (stateSetter != null) {
      stateSetter();
    }
  } else {
    //should sign user out if user doesnt exist...
    FirebaseAuth.instance.signOut();
  }
}

Future<Set<String>> extractPhoneNumbers(List<Contact> contacts) async {
  final Set<String> phoneNumberSet = {};

  for (final contact in contacts) {
    if (contact.phones != null) {
      for (final phone in contact.phones!) {
        if (phone.number != null) {
          phoneNumberSet.add(phone.number!);
        }
      }
    }
  }

  return phoneNumberSet;
}

Future<String> getProfilePicUrl(
    String uid, void Function() wasErrorSetter) async {
  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.doc('Users/$uid').get();
    return userDoc.get('profile_pic');
  } catch (e) {
    wasErrorSetter(); // hopefully this works
    print('profilePicture loading error!');
    return '';
  }
}

/* Event Functions */

// Update event invitation list
Future<void> updateEventInvites(
    String uid,
    String? existingEventID,
    String newEventId,
    String eventTitle,
    Set<String> whoToInvite,
    Set<String> tagsToInvite,
    Set<String> thoseInvited,
    Set<String> tagsInvited) async {
  // Calculate Added IDs
  Set<String> addedIds = whoToInvite.difference(thoseInvited);
  Set<String> addedTags = tagsToInvite.difference(tagsInvited);
  // Calculate Removed IDs
  Set<String> removedIds = thoseInvited.difference(whoToInvite);
  Set<String> removedTags = tagsInvited.difference(tagsToInvite);

  //Now, actually interface with the backend to make these changes

  // Set eventId for new or existing events
  String eventId = existingEventID ?? newEventId;

  // Send invitations
  // If no new invites, do nothing
  if (addedIds.isEmpty) {
    print('No new invitations');
  } else {
    // Loop through people to invite
    print('Invites working!');
    for (String userId in addedIds) {
      try {
        print(eventId);
        print(userId);

        // Create user document in Invited subcollection
        DocumentReference userEventInvited = FirebaseFirestore.instance
            .collection('Events')
            .doc(eventId)
            .collection('Invited')
            .doc(userId);

        // Data to be added
        Map<String, dynamic> invitedList = {
          'uid': userId,
          'isAttending': false,
        };

        // Create event document in user's MyEvents subcollection
        DocumentReference userMyEvents = FirebaseFirestore.instance
            .collection('EventMembers')
            .doc(userId)
            .collection('MyEvents')
            .doc(eventId);

        // Data to be added
        Map<String, dynamic> eventMemberDetails = {
          'creator': uid,
          'eventId': eventId,
          'eventTitle': eventTitle,
          'isCreator': false,
          'isAttending': false,
          'indivInvite': true,
        };

        // Add data to documents
        // Create "Invited" doc using "set" function
        await userEventInvited.set(invitedList);
        // Create "MyEvents" doc using "set" function
        await userMyEvents.set(eventMemberDetails);
      } catch (e) {
        print('There was an error sending invitations: $e');
      }
    }
  }

  // Revoke invitations
  // If no new uninvites, do nothing
  if (removedIds.isEmpty) {
    print('No new uninvites');
  } else {
    // Loop through people to uninvite
    print('Uninvites working!');
    for (String userId in removedIds) {
      // Select user document in Invited subcollection
      try {
        DocumentReference userEventInvited = FirebaseFirestore.instance
            .collection('Events')
            .doc(eventId)
            .collection('Invited')
            .doc(userId);

        // Select event document in user's MyEvents subcollection
        DocumentReference userMyEvents = FirebaseFirestore.instance
            .collection('EventMembers')
            .doc(userId)
            .collection('MyEvents')
            .doc(eventId);

        // Add data to documents
        // Create "Invited" doc using "set" function
        await userEventInvited.delete();
        // Create "MyEvents" doc using "set" function
        await userMyEvents.delete();
      } catch (e) {
        print('There was an error revoking invitations: $e');
      }
    }
  }
}

// Cancel event, uninviting all invitees
void cancelEvent(String eventId) async {
  try {
    // Step 1: Delete Invited Users and MyEvents Documents
    final eventRef =
        FirebaseFirestore.instance.collection('Events').doc(eventId);
    final invitedQuery = eventRef.collection('Invited');
    final invitedSnapshot = await invitedQuery.get();

    final batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot invitedDoc in invitedSnapshot.docs) {
      final userId = invitedDoc.id;
      final myEventsRef = FirebaseFirestore.instance
          .collection('EventMembers')
          .doc(userId)
          .collection('MyEvents')
          .doc(eventId);

      batch.delete(
          myEventsRef); // Delete MyEvents document for each invited user
      batch.delete(invitedQuery.doc(
          userId)); // Delete document in the Invited subcollection corresponding to each invited user
    }

    // Step 2: Delete Event Document
    batch.delete(eventRef);

    // Commit the batch delete
    await batch.commit();
  } catch (e) {
    print("Error canceling event: $e");
  }
}

// Leave event
void leaveEvent(String eventId) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Update event doc from "MyEvents"
    FirebaseFirestore.instance
        .collection('EventMembers')
        .doc(uid)
        .collection('MyEvents')
        .doc(eventId)
        .update({'isAttending': false});

    // Update list entry from "Invited"
    FirebaseFirestore.instance
        .collection('Events')
        .doc(eventId)
        .collection('Invited')
        .doc(uid)
        .update({'isAttending': false});
  } catch (e) {
    print("Error canceling event: $e");
  }
}

// Leave event
void rsvpToEvent(String eventId) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Update event doc from "MyEvents"
    FirebaseFirestore.instance
        .collection('EventMembers')
        .doc(uid)
        .collection('MyEvents')
        .doc(eventId)
        .update({'isAttending': true});

    // Update list entry from "Invited"
    FirebaseFirestore.instance
        .collection('Events')
        .doc(eventId)
        .collection('Invited')
        .doc(uid)
        .update({'isAttending': true});
  } catch (e) {
    print("Error canceling event: $e");
  }
}

Future<String> getFullNameFromId(String creator) async {
  try {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').doc(creator).get();
    if (snapshot.exists) {
      final String creatorName =
          '${snapshot['name']['first']} ${snapshot['name']['last']}';
      return creatorName;
    } else {
      print('snapshot does not exist');
      return 'Error getting name...';
    }
  } catch (e) {
    print("Error getting user's full name: $e");
    return 'Error getting name...';
  }
}

//////////////////////////////////////////////////////////////////////

/* Tag Functions */

Future<void> updateTagInvites(
    String uid,
    String? existingTagID,
    String newTagId,
    String tagTitle,
    Set<String> whoToInvite,
    Set<String> thoseInvited) async {
  // Calculate Added IDs
  Set<String> addedIds = whoToInvite.difference(thoseInvited);
  // Calculate Removed IDs
  Set<String> removedIds = thoseInvited.difference(whoToInvite);

  // Set eventId for new or existing events
  String tagId = existingTagID ?? newTagId;

  // Send invitations
  // If no new invites, do nothing
  if (addedIds.isEmpty) {
    print('No new invitations');
  } else {
    // Loop through people to invite
    print('Invites working!');
    for (String userId in addedIds) {
      try {
        print(tagId);
        print(userId);

        // Create user document in Invited subcollection
        DocumentReference userTagInvited = FirebaseFirestore.instance
            .collection('Tags')
            .doc(tagId)
            .collection('Members')
            .doc(userId);

        // Data to be added
        Map<String, dynamic> invitedList = {
          'uid': userId,
          'isMember': false,
        };

        // Create event document in user's MyEvents subcollection
        DocumentReference userMyTags = FirebaseFirestore.instance
            .collection('TagMembers')
            .doc(userId)
            .collection('MyTags')
            .doc(tagId);

        // Data to be added
        Map<String, dynamic> tagMemberDetails = {
          'creator': uid,
          'tagId': tagId,
          'tagTitle': tagTitle,
          'isCreator': false,
          'isMember': false,
        };

        // Add data to documents
        // Create "Invited" doc using "set" function
        await userTagInvited.set(invitedList);
        // Create "MyEvents" doc using "set" function
        await userMyTags.set(tagMemberDetails);
      } catch (e) {
        print('There was an error sending invitations: $e');
      }
    }
  }

  // Revoke invitations
  // If no new uninvites, do nothing
  if (removedIds.isEmpty) {
    print('No new uninvites');
  } else {
    // Loop through people to uninvite
    print('Uninvites working!');
    for (String userId in removedIds) {
      // Select user document in Invited subcollection
      try {
        DocumentReference userTagInvited = FirebaseFirestore.instance
            .collection('Tags')
            .doc(tagId)
            .collection('Members')
            .doc(userId);

        // Select event document in user's Mytags subcollection
        DocumentReference userMyTags = FirebaseFirestore.instance
            .collection('TagMembers')
            .doc(userId)
            .collection('MyTags')
            .doc(tagId);

        // Add data to documents
        // Create "Invited" doc using "set" function
        await userTagInvited.delete();
        // Create "MyEvents" doc using "set" function
        await userMyTags.delete();
      } catch (e) {
        print('There was an error revoking invitations: $e');
      }
    }
  }
}
