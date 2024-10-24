import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatPage extends StatefulWidget {
  final String userName;

  const ChatPage({Key? key, required this.userName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  bool _hasMessages = false; // Track if there are any messages

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required.')),
      );
    }
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.mic, color: Colors.blue[900]),
                onPressed: () {
                  // Handle audio recording permission and action
                },
              ),
              IconButton(
                icon: Icon(Icons.location_on, color: Colors.blue[900]),
                onPressed: () async {
                  await Permission.location.request();
                },
              ),
              IconButton(
                icon: Icon(Icons.photo_library, color: Colors.blue[900]),
                onPressed: () {
                  // Handle gallery access permission and action
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialog for changing chat status
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Current Chat status open'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Change status action
                  },
                  child: Text('Change to blocked'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900], // Button color
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    minimumSize: Size(100, 40), // Smaller button size
                  ),
                ),
              ),
              SizedBox(height: 8), // Small space between the buttons
              SizedBox(
                width: double.infinity, // Ensure buttons take full width
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // OK button action
                  },
                  child: Text('OK'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0), // Larger button size
                    side: BorderSide(color: Colors.pink, width: 2),
                    primary: Colors.pink, // Text color before hover
                    backgroundColor: Colors.white, // White background by default
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).copyWith(
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white; // Text color on hover
                      }
                      return Colors.pink;
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.pink; // Background color on hover
                      }
                      return Colors.white;
                    }),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Ensure buttons take full width
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0), // Larger button size
                    side: BorderSide(color: Colors.pink, width: 2),
                    primary: Colors.pink, // Text color before hover
                    backgroundColor: Colors.white, // White background by default
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).copyWith(
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white; // Text color on hover
                      }
                      return Colors.pink;
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.pink; // Background color on hover
                      }
                      return Colors.white;
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow to white
        ),
        title: Text(
          'Chat with ${widget.userName}',
          style: TextStyle(color: Colors.white), // White text color for title
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white), // Settings icon
            onPressed: _showSettingsDialog, // Show dialog on click
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _hasMessages
                ? ListView(
              children: [
                // Chat messages will go here
              ],
            )
                : Center(
              child: Text(
                'Talk with ${widget.userName}',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                      prefixIcon: IconButton(
                        icon: Icon(Icons.add, color: Colors.blue[900]), // Plus icon for attachments inside the input
                        onPressed: () {
                          _showAttachmentOptions(context);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _hasMessages = text.isNotEmpty;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue[900]), // Send icon
                  onPressed: () {
                    // Handle send message action
                    setState(() {
                      _hasMessages = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
