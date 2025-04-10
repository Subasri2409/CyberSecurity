import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManageIncidents extends StatefulWidget {
  const ManageIncidents({super.key});

  @override
  _ManageIncidentsState createState() => _ManageIncidentsState();
}

class _ManageIncidentsState extends State<ManageIncidents> {
  final ImagePicker _picker = ImagePicker();

  // Dummy list of cybercrime incidents with images
  List<Map<String, dynamic>> incidents = [
    {
      "incident_type": "Phishing Attack",
      "description": "User received an email pretending to be from their bank asking for login details.",
      "status": "Pending",
      "reported_by": "Alice Johnson",
      "timestamp": "2024-05-10 10:30 AM",
      "image": "/phishing.png", // Default image
      "selected_image": null, // Uploaded image
    },
    {
      "incident_type": "Ransomware Attack",
      "description": "A company's data was encrypted, and the attacker demanded a ransom payment.",
      "status": "Under Review",
      "reported_by": "John Doe",
      "timestamp": "2024-05-09 09:15 PM",
      "image": "/ransomeware.png",
      "selected_image": null,
    },
    {
      "incident_type": "Identity Theft",
      "description": "Personal information was stolen and used for fraudulent activities.",
      "status": "Resolved",
      "reported_by": "Emma Thomas",
      "timestamp": "2024-05-08 02:45 PM",
      "image": "/identitytheft.png",
      "selected_image": null,
    }
  ];

  // FUNCTION TO PICK IMAGE FROM GALLERY OR CAMERA
  // Future<void> _pickImage(int index) async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Change to ImageSource.camera for camera
  //   if (pickedFile != null) {
  //     setState(() {
  //       incidents[index]["selected_image"] = File(pickedFile.path); // Store uploaded image
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Incidents"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: incidents.length,
          itemBuilder: (context, index) {
            final incident = incidents[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // INCIDENT IMAGE (DEFAULT OR SELECTED)
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: _buildIncidentImage(incident), // Function to handle images
                  ),

                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // INCIDENT TYPE ICON
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: _getStatusColor(incident["status"]!),
                          child: Icon(
                            _getIncidentIcon(incident["incident_type"]!),
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 15),

                        // INCIDENT DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                incident["incident_type"]!,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 5),
                              Text(incident["description"]!, style: TextStyle(color: Colors.grey[700])),
                              SizedBox(height: 5),
                              Text("📝 Reported by: ${incident["reported_by"]}", style: TextStyle(fontSize: 14)),
                              Text("📅 ${incident["timestamp"]}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SELECT IMAGE BUTTON
                  // Padding(
                  //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  //   child: ElevatedButton.icon(
                  //     onPressed: () => _pickImage(index),
                  //     icon: Icon(Icons.image),
                  //     label: Text("Select Image"),
                  //     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  //   ),
                  // ),

                  // STATUS DROPDOWN
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
                    child: DropdownButton<String>(
                      value: incident["status"],
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      onChanged: (newStatus) {
                        setState(() {
                          incidents[index]["status"] = newStatus!;
                        });
                      },
                      items: ["Pending", "Under Review", "Resolved"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: _getStatusColor(value))),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // FUNCTION TO DISPLAY DEFAULT OR SELECTED IMAGE
  Widget _buildIncidentImage(Map<String, dynamic> incident) {
    if (incident["selected_image"] != null) {
      return Image.file(
        incident["selected_image"],
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        incident["image"]!,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 180,
            color: Colors.grey[300],
            child: Center(child: Text("Image Not Available", style: TextStyle(color: Colors.black54))),
          );
        },
      );
    }
  }

  // FUNCTION TO GET STATUS COLOR
  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Under Review":
        return Colors.blue;
      case "Resolved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // FUNCTION TO GET INCIDENT ICONS
  IconData _getIncidentIcon(String incidentType) {
    switch (incidentType) {
      case "Phishing Attack":
        return Icons.email;
      case "Ransomware Attack":
        return Icons.lock;
      case "Identity Theft":
        return Icons.person;
      case "Social Engineering":
        return Icons.group;
      case "DDoS Attack":
        return Icons.wifi;
      default:
        return Icons.warning;
    }
  }
}
