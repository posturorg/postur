// import 'package:cloud_firestore/cloud_firestore.dart';

// Stream<List<Map<String, dynamic>>> searchUsers(String searchTerm) {
//   var initialLetter = searchTerm[0];

//   Stream<QuerySnapshot> usersSnapshotStream = FirebaseFirestore.instance
//       .collection('Users')
//       .where('username', isGreaterThanOrEqualTo: searchTerm)
//       .where('username', isLessThan: searchTerm + 'z')
//       .orderBy('username')
//       .limit(40)
//       .snapshots();

//   return usersSnapshotStream.map((querySnapshot) {
//     List<Map<String, dynamic>> searchResults = [];

//     querySnapshot.docs.forEach((userDoc) {
//       Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//       int similarity = calculateSimilarity(searchTerm, userData['username']);
//       searchResults.add({
//         'userId': userDoc.id,
//         'username': userData['username'],
//         'similarity': similarity,
//       });
//     });

//     // Sort the results by similarity
//     searchResults.sort((a, b) => b['similarity'].compareTo(a['similarity']));

//     return searchResults;
//   });
// }

// int calculateSimilarity(String searchTerm, String username) {
//   // Calculate the similarity score using a string similarity metric
//   // This is where you'd implement the logic to calculate similarity.
//   // For example, Levenshtein distance or Jaccard similarity.
//   // Return an integer representing the similarity level.
// }
