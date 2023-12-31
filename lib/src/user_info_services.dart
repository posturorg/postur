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

  // Remove current user's Id from lists 
  // (so you don't accidentally uninvite yourself)
  try {
    addedIds.remove(uid);
    removedIds.remove(uid);
  } catch (e) {
    // pass
  }

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

  // Send invitations to tags
  if (addedTags.isEmpty) {
    print("No new tags");
  } else {
    for (String tagId in addedTags) {
      try {
        FirebaseFirestore.instance
          .collection('Events')
          .doc(eventId)
          .collection('InvitedTags')
          .doc(tagId)
          .set({
            'tagId': tagId
          });
      } catch (e) {
        print('There was an error inviting tags: $e');
      }
    }
  }

  // Uninvite to tags
  if (removedTags.isEmpty) {
    print("No tags to remove");
  } else {
    for (String tagId in removedTags) {
      try {
        FirebaseFirestore.instance
          .collection('Events')
          .doc(eventId)
          .collection('InvitedTags')
          .doc(tagId)
          .delete();
      } catch (e) {
        print('There was an error uninviting tags: $e');
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
      try {
        final userId = invitedDoc.id;
        final myEventsRef = FirebaseFirestore.instance
            .collection('EventMembers')
            .doc(userId)
            .collection('MyEvents')
            .doc(eventId);

        batch.delete(
            myEventsRef); // Delete MyEvents document for each invited user
        batch.delete(invitedQuery.doc(userId));
      } catch (e) {
        print("Error uninviting members: $e");
      } // Delete document in the Invited subcollection corresponding to each invited user
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
    print("Error leaving event: $e");
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
    print("Error RSVP'ing to event: $e");
  }
}

// Update each user's record of their event titles
void updateMyEventTitle(
    String? eventId, String eventTitle, Set<String> whoToInvite) async {
  for (String invitedId in whoToInvite) {
    // Loop through invited guests and update eventTitle
    try {
      await FirebaseFirestore.instance
          .collection('EventMembers')
          .doc(invitedId)
          .collection('MyEvents')
          .doc(eventId)
          .update({'eventTitle': eventTitle});
    } catch (e) {
      print("Error updating eventTitle in MyEvents: $e");
    }
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

// Disband tag, uninviting all invitees
void disbandTag(String tagId) async {
  try {
    // Step 1: Delete Invited Users and MyEvents Documents
    final tagRef = FirebaseFirestore.instance.collection('Tags').doc(tagId);
    final invitedQuery = tagRef.collection('Members');
    final invitedSnapshot = await invitedQuery.get();

    final batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot invitedDoc in invitedSnapshot.docs) {
      try {
        final userId = invitedDoc.id;
        final myTagsRef = FirebaseFirestore.instance
            .collection('TagMembers')
            .doc(userId)
            .collection('MyTags')
            .doc(tagId);

        batch.delete(myTagsRef); // Delete MyTags document for each invited user
        batch.delete(invitedQuery.doc(userId));
      } catch (e) {
        // Delete document in the Members subcollection corresponding to each invited user
        print("Error uninviting members: $e");
      }
    }

    // Step 2: Delete Tag Document
    batch.delete(tagRef);

    // Commit the batch delete
    await batch.commit();
  } catch (e) {
    print("Error disbanding tag: $e");
  }
}

// Leave event
void leaveTag(String tagId) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Update tag doc from "MyTags"
    FirebaseFirestore.instance
        .collection('TagMembers')
        .doc(uid)
        .collection('MyTags')
        .doc(tagId)
        .update({'isMember': false});

    // Update list entry from "Members"
    FirebaseFirestore.instance
        .collection('Tags')
        .doc(tagId)
        .collection('Members')
        .doc(uid)
        .update({'isMember': false});
  } catch (e) {
    print("Error leaving tag: $e");
  }
}

// Leave event
void joinTag(String tagId) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Update event doc from "MyEvents"
    FirebaseFirestore.instance
        .collection('TagMembers')
        .doc(uid)
        .collection('MyTags')
        .doc(tagId)
        .update({'isMember': true});

    // Update list entry from "Invited"
    FirebaseFirestore.instance
        .collection('Tags')
        .doc(tagId)
        .collection('Members')
        .doc(uid)
        .update({'isMember': true});
  } catch (e) {
    print("Error joining tag: $e");
  }
}

// Update each user's record of their event titles
void updateMyTagTitle(
    String? tagId, String tagTitle, Set<String> whoToInvite) async {
  for (String invitedId in whoToInvite) {
    // Loop through invited guests and update eventTitle
    try {
      await FirebaseFirestore.instance
          .collection('TagMembers')
          .doc(invitedId)
          .collection('MyTags')
          .doc(tagId)
          .update({'tagTitle': tagTitle});
    } catch (e) {
      print("Error updating tagTitle in MyTags: $e");
    }
  }
}
