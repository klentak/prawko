# Prawko

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)

Prawko is a mobile application written in Swift using the SwiftUI framework. The application allows users to search for driving license exam slots and monitor their availability.

## Features

- Driving License Exam Search: Users can search for available slots for driving license exams in their region. The application fetches data from info-share application and displays the available slots to the user.
- Slot Monitoring: Users can monitor selected slots and receive notifications when these slots become available or are approaching. This helps users to stay informed and not miss the opportunity to book an exam.

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/klentak/prawko.git
   ```

2. Open the `prawko.xcodeproj` project file in Xcode.
3. Install the dependencies by running the following command in the project's root directory:

   ```
   pod install
   ```

4. Build and run the application on the simulator or a connected device.

## Usage

Upon launching the application, the user . After successful login user will be directed to the home screen where they can choose from the available options:

- Exam Slot Search: Users can enter their preferences for the region, exam type, and date. Upon clicking the "Search" button, the application will fetch the available slots for the provided parameters and display them on the screen.
- Monitored Slots: Users can browse the slots they are monitoring. The application will show a list of slots along with their status (available or unavailable). Users can customize notification preferences.
- User account: Users can logout.


## Author

Prawko is created by [klentak](https://github.com/klentak).
