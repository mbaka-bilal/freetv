import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: Icon(Icons.arrow_back,color: Colors.white,),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontFamily: "Rajdhani",
                  fontSize: 32,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, bottom: 20),
                            child: Text("Sign in with",style: TextStyle(
                                fontSize: 15
                            ),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white10),
                                child: const Center(child: FaIcon(FontAwesomeIcons.google)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white10),
                                child: const Center(child: FaIcon(FontAwesomeIcons.apple)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: [
                          Text(
                            "Create an account",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                label: const Text("User name",style: TextStyle(color: Colors.white24),),
                                prefixIcon: const Icon(Icons.person_outlined,color: Colors.white24,),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                label: const Text("Email",style: TextStyle(color: Colors.white24),),
                                prefixIcon: const Icon(Icons.email_outlined,color: Colors.white24,),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(

                                label: const Text("Password",style: TextStyle(
                                    color: Colors.white24
                                ),),

                                prefixIcon: const Icon(Icons.person,color: Colors.white24,),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(

                                label: const Text("Confirm Password",style: TextStyle(
                                    color: Colors.white24
                                ),),

                                prefixIcon: const Icon(Icons.people,color: Colors.white24,),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(),
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: null,
                                child: Text(
                                  "Sign Up",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20)))),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Already have an account?",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              InkWell(
                                child: Text(
                                  "Sign In",
                                  style:
                                  TextStyle(color: Colors.blue, fontSize: 15),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
