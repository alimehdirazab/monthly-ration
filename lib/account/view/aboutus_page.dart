part of 'view.dart';

class AboutusPage extends StatelessWidget {
  const AboutusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutUsView();
  }
}

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            GroceryColorTheme().primary, // Yellow color for app bar
        elevation: 0,

        title: Text(
          'About Us',
          style: GroceryTextTheme().bodyText.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App logo or illustration
            // CircleAvatar(
            //   radius: 50,
            //   backgroundImage: AssetImage('assets/images/app_logo.png'), // optional
            // ),
            // const SizedBox(height: 20),

            // App name
            const Text(
              "Monthly Ration",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Tagline
            const Text(
              "Empowering your digital life.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // About description
            const Text(
              "We are a passionate team committed to delivering high-quality digital experiences. "
              "Our app is designed to simplify your tasks, enhance productivity, and provide secure services.",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Our Mission
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Our Mission",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "To build user-centric digital solutions that empower people and businesses through technology.",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            // Contact Info
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Contact Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.email),
              title: Text("support@example.com"),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text("+91 123 4567890"),
            ),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Ghaziabad, India"),
            ),

            const SizedBox(height: 40),
            const Text(
              "© 2025 MyApp. All rights reserved.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
