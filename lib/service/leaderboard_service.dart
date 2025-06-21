// lib/services/leaderboard_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // For debugPrint

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference for user scores
  CollectionReference get _userScoresCollection => _firestore.collection('user_total_scores');

  // Method to add or update a user's total optimized score
  Future<void> addOrUpdateUserScore({
    required String userId,
    required String userName,
    required String imageUrl,
    required int newOptimizedScore,
  }) async {
    // Get a reference to the user's specific document
    DocumentReference userDocRef = _userScoresCollection.doc(userId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(userDocRef);

        int currentTotalScore = 0;
        if (userDoc.exists) {
          // If document exists, get current total score
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          currentTotalScore = data['totalOptimizedScore'] ?? 0;
        }

        // Calculate new total score
        int updatedTotalScore = currentTotalScore + newOptimizedScore;

        // Set/update the document
        transaction.set(
          userDocRef,
          {
            'userId': userId,
            'userName': userName, // Always update with latest name from current session
            'totalOptimizedScore': updatedTotalScore,
            'userImage': imageUrl,
            'lastQuizCompletedAt': FieldValue.serverTimestamp(), // Firestore timestamp
          },
          SetOptions(merge: true), // Use merge to update existing fields or add new ones
        );
      });
      debugPrint('Score for $userName (ID: $userId) updated to Firestore successfully. Added: $newOptimizedScore');
    } catch (e) {
      debugPrint('Error updating score for user $userName: $e');
      rethrow; // Re-throw to be handled by the UI
    }
  }

  // Method to get top scores for the leaderboard
  Future<List<Map<String, dynamic>>> getTopScores({int limit = 20}) async {
    try {
      QuerySnapshot querySnapshot = await _userScoresCollection
          .orderBy('totalOptimizedScore', descending: true) // Order by score, highest first
          .limit(limit) // Limit the number of entries
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      debugPrint('Error fetching top scores: $e');
      return []; // Return empty list on error
    }
  }

  // New method: Get a specific user's rank and score
  Future<Map<String, dynamic>?> getUserRankAndScore(String userId) async {
    try {
      DocumentSnapshot userDoc = await _userScoresCollection.doc(userId).get();

      if (!userDoc.exists) {
        return null; // User not found in leaderboard
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final int userScore = userData['totalOptimizedScore'] ?? 0;

      // Query to count documents with score greater than or equal to user's score
      QuerySnapshot higherScores = await _userScoresCollection
          .where('totalOptimizedScore', isGreaterThanOrEqualTo: userScore)
          .orderBy('totalOptimizedScore', descending: true)
          .get();

      // Find the rank:
      // Iterate to find the *first* document that matches the current user's score.
      // If there are multiple users with the same score, they share the same rank.
      int rank = 1; // Default to 1 if no one is higher
      for (var doc in higherScores.docs) {
        if (doc.id == userId) {
          // Found the user's rank. This handles ties correctly (e.g., 1, 2, 2, 4)
          break;
        }
        rank++;
      }

      return {
        'rank': rank,
        'userId': userId,
        'userName': userData['userName'],
        'totalOptimizedScore': userScore,
        'userImage': userData['userImage'],
      };
    } catch (e) {
      debugPrint('Error getting user rank and score for $userId: $e');
      return null;
    }
  }
}
