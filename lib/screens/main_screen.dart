import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'UserProvider .dart';

class DatingListScreen extends StatefulWidget {
  const DatingListScreen({Key? key}) : super(key: key);

  @override
  State<DatingListScreen> createState() => _DatingListScreenState();
}

class _DatingListScreenState extends State<DatingListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersProvider>().loadUsers();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UsersProvider>().loadUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Dating List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              hintText: 'Search',
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: _buildUserList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Consumer<UsersProvider>(
      builder: (context, usersProvider, child) {
        if (usersProvider.users.isEmpty && usersProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (usersProvider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${usersProvider.error}'),
                ElevatedButton(
                  onPressed: () {
                    usersProvider.resetState();
                    usersProvider.loadUsers();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: usersProvider.users.length,
          itemBuilder: (context, index) {
            if (index == usersProvider.users.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return _DateCard(user: usersProvider.users[index]);
          },
        );
      },
    );
  }
}

class _DateCard extends StatelessWidget {
  final User user;

  const _DateCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: Color(0xFF6C63FF)),
                const SizedBox(width: 8),
                Text(
                  'Dinner',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.picture),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name} - ${user.age}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${user.distance} km from you',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Date',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: 100,
                ),
                const Icon(Icons.location_on, size: 16),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Location',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 4),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Sun, Jul 17 2024',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(width: 55),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                              child: Text(
                                user.location,
                                style: TextStyle(fontSize: 14, color: Colors.black),
                                maxLines: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        )                      ],
                    ),
                    Text(
                      '08:00 PM',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(width: 55),
              ],
            )        
          ],
        ),
      ),
    );
  }
}
