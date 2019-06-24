# agronom

A argonom online features application

## Getting Started

Agronom app is a Flutter application.
Uses simplified pattern with providers, setState and classical build widgets and functions with the help
of good packages.

 --- Install ---
 
 To check, run application, install Android Studio and Flutter, Dart plugins in IDE
 Also install Flutter by downloading it and placing for example C:\flutter
 
 --- Build --- 
 First go to Android Studio, select the project, open pubsec.yml and click link packages get
 
 or in command line  ->  flutter doctor (to check if something missing), flutter packages get
 
 --- Run application ---
 Before run application you need to create and run AVD emulator in Android, open Android Studio, Android Virtual Device Manager
   and download Pie (API 27) and create device with Google play feature (run icon)  
   
 Run by using command line -> flutter run
 
 Best viewed in Android, Pie Android OS API 27, possible to run in iOS, but not yet tested in that os.
 
 --- Plot and contents --- 
 The application consists: 
    env.dart - small environment global file that contains global variables
    main.dart - starting pointing of application
   	widgets / - widgets, utility containers that helps pages to render, parse info
	   connectivity.dart - utility container for connectivity package to check if Internet connection on
	providers / - connection http client handlers and parsers
	models / - application models 
	pages / - real pages of application that are directed with flutter routing 
	  messages.dart - list of messages
	  message_create.dart - form that sends message
	  
	So logic currently: 
       main.dart loads pages, 
	     you can select page -> messages -> list of messages or one message 
		     select page -> message create -> form with text input and button
			 
	 Internet on / off scenarios: 
          Messages ->  if Internet on it will load message from webhooks url and save (internally) received message 
                       If Internet off it will load saved message from Shared prefs	(like cookies in browser)	 
					   If Internet turns on it will resend request to get message 
					   
		  Messages ->  if Internet on will send request (post) to save message in webhooks, saves internally message 
                       If Internet off it will load saved message from Shared prefs 
					   If Internet turns on will resend saved message
					   			   
	  Hope you can check the app 
	   and enjoy the app and if some questions do ask.
	   
   