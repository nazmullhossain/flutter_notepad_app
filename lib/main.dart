import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_app/model/error_model.dart';
import 'package:google_doc_app/pages/home_pages.dart';
import 'package:google_doc_app/pages/login_page.dart';
import 'package:google_doc_app/repository/auth_repository.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData()async{
errorModel=await ref.read(authRepositoryProvider).getUserData();
if(errorModel!=null && errorModel!.data !=null){
  ref.read(userProvider.notifier).update((state) => errorModel!.data);
}
  }
  @override
  Widget build(BuildContext context) {
    final user=ref.watch(userProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user!=null?HomePage(): LoginPage(),
    );
  }
}
