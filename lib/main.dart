import 'package:flutter/material.dart';
import 'package:flutter_abexa/auth/login.dart';
import 'package:flutter_abexa/auth/register.dart';
import '../assets/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_abexa/services/auth_service.dart';
import 'package:flutter_abexa/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


enum MarkerType { housing, work }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(MultiProvider(
    providers: [Provider<AuthService>(create: (_) => AuthService())],
    child: MaterialApp(
        title: 'ABEXA APP',
        initialRoute: '/auth',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const MyHomePage(),
          '/auth': (context) => const Wrapper(),
          '/register': (context) =>
              const Register(title: "S'enregistrer - " + appName),
          '/login': (context) =>
              const Login(title: "Se connecter - " + appName),
        }),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const MapScreen();
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, this.title = "ABEXA APP"}) : super(key: key);

  final String title;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(43.61259453721549, 1.428904740452907), zoom: 11);
  // LatLng _initialcameraposition = const LatLng(20.5937, 78.9629);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final TextEditingController _titleElement = TextEditingController(text: "");
  List<Marker> allMarkers = [];
  // int _page = 0;
  late GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Center(
            child: Text(widget.title),
          ),
          backgroundColor: const Color(mainColor),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 50,
          items: const <Widget>[
            Icon(Icons.map_outlined, color: Colors.white),
            Icon(Icons.favorite_outline, color: Colors.white)
          ],
          color: const Color(mainColor),
          buttonBackgroundColor: const Color(mainColor),
          backgroundColor: const Color(0xFFE5E6E6),
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 250),
          // onTap: (index) {
          //   setState(() {
          //     _page = index;
          //   });
          // },
          // letIndexChange: (index) => true,
        ),
        drawer: Drawer(
          child: ListView(
            children: const <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Utilisateur"),
                accountEmail: Text("xxx@outlook.com"),
                decoration: BoxDecoration(color: Color(mainColor))
                // currentAccountPicture: CircleAvatar(
                //   child: Image.asset('assets/images/logo_fcm.png'),
                //   backgroundColor: Color(0xff0950b5),
                // ),
              ),
            ],
          ),
        ),
        body: GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          markers: allMarkers.map((e) => e).toSet(),
          onMapCreated: _onMapCreated,
          onLongPress: (pos) => _addMarker(pos, context),
          myLocationButtonEnabled: true,
        ));
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    final position = await _determinePosition();

    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 15),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _addMarker(LatLng pos, BuildContext context) {
    // MarkerType? currentMarkerType = MarkerType.housing;
    bool isHousingMode = false;

    showModalBottomSheet<void>(
        backgroundColor: const Color(mainColor),
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter myState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                  height: 290,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              autofocus: true,
                              cursorColor: const Color(buttonColor),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: 'Titre',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color(buttonColor)))),
                              controller: _titleElement,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un titre';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            Column(
                              children: <Widget>[
                                const Text(
                                    "Veuillez sélectionner un type de marqueur :",
                                    style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text("Logement",
                                        style: TextStyle(color: Colors.white)),
                                    Switch(
                                      value: isHousingMode,
                                      onChanged: (value) {
                                        myState(() {
                                          isHousingMode = value;
                                        });
                                      },
                                      activeColor:
                                          const Color(buttonColor),
                                      activeTrackColor: Colors.white,
                                    ),
                                    const Text("Lieu de travail",
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () =>
                                    _addElement(pos, context, isHousingMode),
                                child: const Text("Ajouter un lieu"),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(buttonColor)),
                                ))
                          ],
                        )),
                  )),
            );
          });
        });
  }

  void _addElement(LatLng pos, BuildContext context, bool isHousingMode) {
    Marker newMarker = Marker(
      markerId: MarkerId(const Uuid().v4().toString()),
      position: pos,
      infoWindow: InfoWindow(title: _titleElement.text),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          isHousingMode ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen),
      // onTap: _manageTapMarker(context),
    );

    setState(() {
      _titleElement.text = "";

      allMarkers.add(newMarker);
    });
    Navigator.pop(context);
  }

  _manageTapMarker(BuildContext context) {
    return showModalBottomSheet<void>(
        backgroundColor: const Color(mainColor),
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const SizedBox(
                height: 290,
                child: Center(child: Text("salut")),
              ));
        });
  }
}
