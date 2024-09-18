//
//  SceneDelegate.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

/*
 Hello Debarshee,
 We have a preliminary screening round where you have to submit a coding challenge. For any reason that you may not be able to do so please let us know.
 Below is the problem statement, This exercise    should take from 3 to 4 hours to complete.  Please upload your coding challenge in Github or Gitlab and reply to this email after completion. Once you get through in Coding challenge, I will review with the team and possibly schedule other Technical Rounds and Behavioral Round of Interviews..

 Coding Challenge: Weather
 Below are the details needed to construct a weather based app where users can look up weather for a city.

 Public API
 Create a free account at openweathermap.org. Just takes a few minutes. Full documentation for the service below is on their site, be sure to take a few minutes to understand it.

 https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={API key}
 Built-in geocoding
 Please use Geocoder API if you need automatic convert city names and zip-codes to geo coordinates and the other way around.
 Please note that API requests by city name, zip-codes and city id have been deprecated. Although they are still available for use, bug fixing and updates are no longer available for this functionality.
 Built-in API request by city name
 You can call by city name or city name, state code and country code. Please note that searching by states available only for the USA locations.
 API call
 https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
 https://api.openweathermap.org/data/2.5/weather?q={city name},{country code}&appid={API key}
 https://api.openweathermap.org/data/2.5/weather?q={city name},{state code},{country code}&appid={API key}

 You will also need icons from here:
 http://openweathermap.org/weather-conditions

 Requirements
 These requirements are rather high-level and vague. If there are details I have omitted, it is because I will be happy with any of a wide variety of solutions. Don't worry about finding "the" solution.
 Create a browser or native-app-based application to serve as a basic weather app.
 Search Screen
 Allow customers to enter a US city
 Call the openweathermap.org API and display the information you think a user would be interested in seeing. Be sure to has the app download and display a weather icon.
 Have image cache if needed
 Auto-load the last city searched upon app launch.
 Ask the User for location access, If the User gives permission to access the location, then retrieve weather data by default
 In order to prevent you from running down rabbit holes that are less important to us, try to prioritize the following:
 What is Important
 Proper function – requirements met.
 Well-constructed, easy-to-follow, commented code (especially comment hacks or workarounds made in the interest of expediency (i.e. // given more time I would prefer to wrap this in a blah blah blah pattern blah blah )).
 Proper separation of concerns and best-practice coding patterns.
 Defensive code that graciously handles unexpected edge cases.
 What is Less Important
 UI design – generally, design is handled by a dedicated team in our group.
 Demonstrating technologies or techniques you are not already familiar with (for example, if you aren't comfortable building a single-page app, please don't feel you need to learn how for this).
 iOS:
 For applications that include CocoaPods with their project code, having the Pods included in the code commits as the source is recommended. (Even though it goes against the CocoaPod's general rules).
 Be sure to use safe area insets
 Using Sizeclass wisely for landscape and portrait
 Make sure to use UIKit, we would love to see a combination of both UIKit and SwiftUI if you desire.

 get the coordinator patten
 Must need to be followed MVVM
 Dependency Injection must be used
 Must need to handle any error scenarios
 SwiftUI – Which is mandatory
 Test cases - Mandatory
 used protocols where is needed

 */

