import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anosh/models/project.dart';

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>((ref) {
  return ProjectsNotifier();
});

class ProjectsNotifier extends StateNotifier<List<Project>> {
  ProjectsNotifier() : super(mockProjects) {
    // We delay the Firebase check to ensure main() initialization is complete
    Future.microtask(() => _listenToFirestore());
  }

  void _listenToFirestore() {
    // SAFETY CHECK: Ensure Firebase is actually initialized before calling Firestore
    if (Firebase.apps.isEmpty) {
      // ignore: avoid_print
      print('Firebase not initialized. Staying in Mock Mode.');
      return;
    }

    try {
      FirebaseFirestore.instance
          .collection('projects')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        final firestoreProjects = snapshot.docs
            .map((doc) => Project.fromMap(doc.data(), doc.id))
            .toList();
        
        // Combine Firestore data with Mock data (Mock data acts as fallback)
        state = [...firestoreProjects, ...mockProjects.where((m) => !firestoreProjects.any((f) => f.title == m.title))];
      }, onError: (e) {
        // ignore: avoid_print
        print('Firestore snapshot error: $e');
      });
    } catch (e) {
      // ignore: avoid_print
      print('Firestore initialization error caught: $e');
    }
  }

  Future<void> addProject(Project project) async {
    if (Firebase.apps.isEmpty) {
      state = [project, ...state];
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('projects').add(project.toMap());
    } catch (e) {
      // ignore: avoid_print
      print('Firestore add error: $e');
      state = [project, ...state];
    }
  }

  Future<void> deleteProject(String id) async {
    if (Firebase.apps.isEmpty) {
      state = state.where((p) => p.id != id).toList();
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('projects').doc(id).delete();
    } catch (e) {
      // ignore: avoid_print
      print('Firestore delete error: $e');
      state = state.where((p) => p.id != id).toList();
    }
  }
}

final projectRepositoryProvider = Provider((ref) => ProjectRepository(ref));

class ProjectRepository {
  final Ref ref;
  ProjectRepository(this.ref);

  Future<void> addProject(Project project) async {
    await ref.read(projectsProvider.notifier).addProject(project);
  }
}
