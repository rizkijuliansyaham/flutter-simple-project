import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_project/feature/home/view_model/user_provider.dart';


class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('List Users (${userProvider.users.length})'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading && provider.users.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: provider.users.length,
                      itemBuilder: (context, index) {
                        final user = provider.users[index];
                        return Row(
                          children: [
                            CircleAvatar(foregroundImage: NetworkImage(user.avatar!), radius: 30,),
                            Expanded(
                              child: ListTile(
                                title: Text(user.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                subtitle: Text(user.email!),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              if (userProvider.isLoading && userProvider.page != 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      userProvider.resetData();
                    },
                    child: Text('Reset Data'),
                  ),
                  SizedBox(width: 16,),
                  ElevatedButton(
                    onPressed: () {
                      userProvider.fetchUsers();
                    },
                    child: Text('Load More'),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
