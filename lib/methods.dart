import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';


Future<User> createAccount(String _email, String _password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User user = (await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password))
        .user;
    if (user != null) {
      print("account Successfully created");

      return user;
    } else {
      print("failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User> login(String _email, String _password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User user = (await _auth.signInWithEmailAndPassword(
            email: _email, password: _password))
        .user;
    if (user != null) {
      print("login Successfully");
      return user;
    } else {
      print("failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logout() async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut();
  } catch (e) {
    print(e);
  }
}

Future<void> updateUserDat({String userName, String name, String path}) async {
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  if (userName.isNotEmpty) {
    user.doc(currentUser.uid).update({"Username": userName});
  }
  if (name.isNotEmpty) {
    user.doc(currentUser.uid).update({"Name": userName});
  }

  return;
}

Future<void> addUsername(String userName, String email,
    {String imgName}) async {
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  User currentUser = FirebaseAuth.instance.currentUser;
  user
      .doc(currentUser.uid)
      .set({"Username": userName, "Name": "", "Email": email});
  print("Username Successfully updated");
  return;
}

Future selectImg() async {
  final ImagePicker _picker = ImagePicker();

  final image = await _picker.pickImage(source: ImageSource.gallery);
  // html.File image = await ImagePickerWeb.getImage(outputType: ImageType.file);
  // Directory appDocDir;
  // if (kIsWeb) {
  //   appDocDir = Directory('web\mineAsserts');
  // } else {
  //   appDocDir = await getApplicationDocumentsDirectory();
  // }
//  String filePath = '${appDocDir.absolute}/uploaded.jpg';
  // print(filePath);

  // print(image.path);
  if (image == null) return;
  uploadFile(image.path, image.name);
}

Future<void> uploadFile(String path, String name) async {
  File _file = File(path);
  print(path);
  User currentUser = FirebaseAuth.instance.currentUser;
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  try {
    await _storage
        .ref('UsersData/${currentUser.email}/Posts/${name}')
        .putFile(_file);
  } on firebase_storage.FirebaseException catch (e) {
    print("Error $e");
  }
  print("Image uploaded successfully in profile");
  try {
    await _storage.ref('AllData/${name}').putFile(_file);
  } on firebase_storage.FirebaseException catch (e) {
    print("Error $e");
  }
  print("Image uploaded successfully in AllData");
}

// class FirevaseApi {
//   static Future<List<String>> _getDownloadLinks(
//           List<firebase_storage.Reference> refs) =>
//       Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
//   static Future<List<File>> listAll(String path) async {
//     final ref = firebase_storage.FirebaseStorage.instance.ref(path);
//     final result = await ref.listAll();
//     final urls = await _getDownloadLinks(result.items);
//     return urls
//         .asMap()
//         .map((index, url) {
//           final ref = result.items[index];
//           final name = ref.name;
//           final file =
//         })
//         .values
//         .toList();
//   }
// }

Future<List<String>> downloadFile() async {
  List<String> urls;
  Future<void> _getUrl(firebase_storage.ListResult result) async {
    for (int i = 0; i < result.items.length; i++) {
      String u = await result.items[i].getDownloadURL();
      print(u);
    }
  }

  firebase_storage.ListResult result =
      await firebase_storage.FirebaseStorage.instance.ref('AllData').listAll();
  _getUrl(result);
  // result.items.forEach((firebase_storage.Reference refs) {
  //   String m =  await refs.getDownloadURL();
  // });
  return urls;
}

Future<String> getImageUrl(String path) async {
  String url = await firebase_storage.FirebaseStorage.instance
      .ref(path)
      .getDownloadURL();
  return url;
}

Future<String> uploadImg(File imageFile) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  final _ref = firebase_storage.FirebaseStorage.instance.ref(
      'UsersData/${currentUser.email}/Profile/${DateTime.now().microsecondsSinceEpoch}');
  firebase_storage.UploadTask task;
  try {
    task = _ref.putFile(imageFile);
  } on firebase_storage.FirebaseException catch (e) {
    print("Error here $e");
  }
  var url = await (await task).ref.getDownloadURL();
  print("Image uploaded Successfully");
  return url;
}

Future<bool> addUserData(String username, String fname, String lname,
    String bio, String profileUrl) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  bool what = true;
  try {
    user.doc(currentUser.uid).set({
      'uid': currentUser.uid,
      'email': currentUser.email,
      'displayName': username,
      'profileUrl': profileUrl,
      'firstName': fname,
      'lastName': lname,
      'bio': bio,
      'followers': '0',
      'following': '0',
      'postNo': '0',
    });
  } catch (e) {
    print("error here $e");
    what = false;
  }
  print('User data successfully uploaded');
  return what;
}

Future<void> addUserPost(
    String location, String caption, String postUrl) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  // CollectionReference user = FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(currentUser.uid);
  Map<String, dynamic> user = await getUserData();
  CollectionReference userPost = FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUser.uid)
      .collection("posts");
  try {
    userPost.doc('${DateTime.now().microsecondsSinceEpoch}').set({
      'uid': currentUser.uid,
      'email': currentUser.email,
      'displayName': user['displayName'],
      'profileUrl': user['profileUrl'],
      'firstName': user['firstName'],
      'lastName': user['lastName'],
      'likes': '0',
      'location': location,
      'caption': caption,
      'postUrl': postUrl,
      'time': FieldValue.serverTimestamp()
    });
  } catch (e) {
    print("error here $e");
  }
  print('Post data successfully uploaded');
  CollectionReference Posts = FirebaseFirestore.instance.collection('Posts');

  try {
    Posts.doc('${DateTime.now().microsecondsSinceEpoch}').set({
      'uid': currentUser.uid,
      'email': currentUser.email,
      'displayName': user['displayName'],
      'profileUrl': user['profileUrl'],
      'firstName': user['firstName'],
      'lastName': user['lastName'],
      'likes': '0',
      'location': location,
      'caption': caption,
      'postUrl': postUrl,
      'time': FieldValue.serverTimestamp()
    });
  } catch (e) {
    print("error here $e");
  }
  print('Data in All Posts updated');
}

Future<void> updateUserData({String data, String choice}) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference user = FirebaseFirestore.instance.collection('Users');
  try {
    switch (choice) {
      case '1':
        user.doc(currentUser.uid).update({'displayName': data});
        return;
      case '2':
        user.doc(currentUser.uid).update({'firstName': data});
        return;
      case '3':
        user.doc(currentUser.uid).update({'lastName': data});
        return;
      case '4':
        user.doc(currentUser.uid).update({'bio': data});
        return;
      case '5':
        user.doc(currentUser.uid).update({'profileUrl': data});
        return;
    }
  } catch (e) {
    print("error here $e");
  }
  print('User data successfully updated');
}

Future<Map<String, dynamic>> getUserData() async {
  Map<String, dynamic> data;
  User currentUser = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUser.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>;
    }
  });
  return data;
}

Future<Map<String, dynamic>> getUserDataDynamic(String id) async {
  Map<String, dynamic> data;
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(id)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>;
    }
  });
  return data;
}

Future<void> addUserFollowers(String id) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  // CollectionReference user = FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(currentUser.uid);
  Map<String, dynamic> user = await getUserData();
  CollectionReference userPost = FirebaseFirestore.instance
      .collection('Users')
      .doc(id)
      .collection("followers");
  try {
    userPost.doc(currentUser.uid).set({
      'uid': currentUser.uid,
      'email': currentUser.email,
      'displayName': user['displayName'],
      'profileUrl': user['profileUrl'],
      'firstName': user['firstName'],
      'lastName': user['lastName'],
    });
  } catch (e) {
    print("error here $e");
  }
  print("in Dynamic User Profile, current follower updated ");
}

Future<void> addCurrentUserFollowings(String id) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  // CollectionReference user = FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(currentUser.uid);
  Map<String, dynamic> user = await getUserDataDynamic(id);
  CollectionReference userPost = FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUser.uid)
      .collection("following");
  try {
    userPost.doc(id).set({
      'uid': id,
      'email': user['email'],
      'displayName': user['displayName'],
      'profileUrl': user['profileUrl'],
      'firstName': user['firstName'],
      'lastName': user['lastName'],
    });
  } catch (e) {
    print("error here $e");
  }
  print("in current User Profile, followings updated ");
}

Future<bool> isCurrentUserFollower(String id) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  final doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(id)
      .collection("followers")
      .doc(currentUser.uid)
      .get();
  print(doc.exists);
  return (doc.exists);
}

Future<void> removeUserFollower(String id) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  try {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection("followers")
        .doc(currentUser.uid)
        .delete();
  } catch (e) {
    print(e);
  }
  print("in Dynamic User Profile, current follower removed");
}

Future<void> removeCurrentUserFollowings(String id) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  try {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .collection("following")
        .doc(id)
        .delete();
  } catch (e) {
    print(e);
  }
  print("in current User Profile, followings removed ");
}

Future<void> updateDynamicUserFollowersNum(String id, int no) async {
  CollectionReference user =
      await FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic> sameUser = await getUserDataDynamic(id);
  try {
    user.doc(id).update(
        {'followers': (int.parse(sameUser['followers']) + no).toString()});
  } catch (e) {
    print(e);
  }
  print(" followers update of dynamic user");
}

Future<void> updateCurrentUserFollowingNum(String id, int no) async {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference user =
      await FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic> sameUser = await getUserData();
  try {
    user.doc(currentUser.uid).update(
        {'following': (int.parse(sameUser['following']) + no).toString()});
  } catch (e) {
    print(e);
  }
  print(" followings update of current User");
}

Future<void> updateCurrentUserPostNum() async {
  User currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference user =
      await FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic> sameUser = await getUserData();
  try {
    user
        .doc(currentUser.uid)
        .update({'postNo': (int.parse(sameUser['postNo']) + 1).toString()});
  } catch (e) {
    print(e);
  }
  print("Post update of current User");
}

Future<Map<String, dynamic>> getUserPostData(String id) async {
  Map<String, dynamic> data;
  await FirebaseFirestore.instance
      .collection('Posts')
      .doc(id)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>;
    }
  });
  return data;
}

Future<void> updatePostLikeNum(String id, int cnt) async {
  CollectionReference userPost =
      await FirebaseFirestore.instance.collection('Posts');
  Map<String, dynamic> samePost = await getUserPostData(id);
  try {
    userPost
        .doc(id)
        .update({'likes': (int.parse(samePost['likes']) + cnt).toString()});
  } catch (e) {
    print(e);
  }
  print("likes update of current $id Post");
}
