🎓 EKOS - Kırıkkale University Economics Community Mobile Application
<div align="center">
<img src="assets/images/ekoslogo.png" alt="EKOS Logo" width="200"/>
<br>
<strong>My flutter mobile application developed for Kırıkkale University Economics Community</strong>
</div>

📱 About the Project
KET (Kku Economics Community) is a modern mobile application developed with Flutter for the Kırıkkale University Economics Community. The application offers comprehensive features such as community events, up-to-date economics news, lecture notes sharing, and social media integration.

🎥 Project Promotion Video
<div align="center">
<a href="https://www.youtube.com/watch?v=3jnqW75B0Bk" target="_blank">
<img src="https://img.youtube.com/vi/3jnqW75B0Bk/maxresdefault.jpg" alt="KET Project Promotion Video" width="600"/>
</a>
<br>
<strong>📺 <a href="https://www.youtube.com/watch?v=3jnqW75B0Bk">KET Mobile Application and Website Promotion Video</a></strong>
<br>
<em>Detailed project introduction, features, and usage guide</em>
</div>

Version: 6.8.9
Developer: Arif Özdemir
Platform: Android (iOS support available)
Language: Dart/Flutter
Database: Firebase Firestore
Minimum SDK: Android API 34 (Android 13)
Target SDK: Android API 36 (Android 16)

✨ Features
📚 Education and Academics
Lecture Note Sharing System: Sharing of lecture notes among members

My Lecture Notes: Personal lecture notes management

Event Calendar: Tracking academic and social events

Upcoming Events: Notifications for future events

📰 News and Communication
Community News: Latest community announcements

Social Media Integration: Access to community social media accounts

Feedback System: Providing feedback about the application and community

Survey System: Collecting member opinions

💰 Economy and Finance
Current Economy: Latest economic developments

Live Market: Real-time financial data

Economic Analyses: Expert opinions and analyses

👥 Community Management
Member Registration System: New member applications

Member Profiles: Community member information

Admin Panel: Special panel for community administrators

Sponsors: Community sponsors and collaborations

🔔 Notifications and Security
Push Notifications: Instant notifications for important announcements

Account Security: Secure login and account management

Offline Mode: Some features without internet connection

Automatic Update: Checking for application updates

🛠️ Technologies
Frontend
Flutter 3.6.1+ - Cross-platform mobile application development

Dart 3.6.1+ - Programming language

Material Design 3 - Modern UI/UX design

Backend and Database
Firebase Core - Backend infrastructure

Cloud Firestore - NoSQL database

Firebase Authentication - User authentication

Firebase Messaging - Push notifications

Firebase Database - Real-time database

Key Packages
shared_preferences - Local data storage

permission_handler - System permissions management

url_launcher - External links

image_picker - Image selection and upload

syncfusion_flutter_charts - Charts and graphs

workmanager - Background tasks

in_app_update - In-app update

flutter_local_notifications - Local notifications

http - HTTP requests

intl - Internationalization and date formats

share_plus - Content sharing

📂 Project Structure and Dart File Functions
🏠 Main Files
main.dart - Application Entry Point
Function: The main entry point of the application and initialization processes

Features:

Firebase initialization and configuration

User authentication system

Splash screen and loading screens

Application update check

Push notification configuration

Background tasks with Workmanager

Main page grid menu system

Account blocking check

firebase_service.dart - Firebase Operations
Function: Firebase Firestore database operations

Features:

Adding/retrieving feedback

Tournament application management

Database CRUD operations

Error handling

🎯 Feature Modules
admin_panel_page.dart - Admin Panel
Function: Admin login and management tools

Features:

Secure admin login (username: kkuekonomi71)

Event management

Community news management

Voting system management

Student database

Blacklist management

AI scoring system

Lecture notes management

current_economy.dart - Current Economy News
Function: Retrieving economy news from Anadolu Agency RSS feed

Features:

RSS feed reading and parsing

News filtering system

Dark/light mode

News reporting system

Sharing feature

Legal disclaimer system

Automatic news update

live_market.dart - Live Market Tracking
Function: Real-time tracking of cryptocurrency and stock prices

Features:

CoinGecko API integration

Turkish stock simulation

Favorites system

Price charts (Syncfusion Charts)

Comparison feature

Search and filtering

Candlestick charts

ders_notlari1.dart - Lecture Notes Sharing System
Function: Sharing lecture notes among students

Features:

Faculty/department/course filtering

PDF file sharing

Like/dislike system

Add to favorites

Download counter

Legal disclaimer and terms of use

Anonymous user system

etkinlik_takvimi2.dart - Event Calendar
Function: Listing community events

Features:

Firebase Firestore integration

Date-based sorting

Event cards with visual support

Gradient background design

Responsive design

yaklasan_etkinlikler.dart - Upcoming Events
Function: Showing future events and setting alarms

Features:

Remaining time calculation

Alarm setting system (for Samsung and other brands)

Integration with clock application via Intent system

Real-time update

social_media_page.dart - Social Media
Function: Redirecting to community social media accounts

Features:

Instagram and Twitter integration

External links with URL launcher

Responsive card design

feedback.dart - Feedback System
Function: Collecting user feedback

Features:

Anonymous feedback

Firebase Firestore recording

Email address (optional)

Form validation

poll.dart - Survey System
Function: Creating and managing community surveys

Features:

Multiple-choice questions

Open-ended questions

Firebase Firestore recording

Anonymous survey system

sponsors_page.dart - Sponsors
Function: Sponsorship information and contact

Features:

Email integration

Sponsorship application system

Contact form

account_settings_page.dart - Account Settings
Function: User account management

Features:

Change password

Delete/deactivate account

Notification settings (quiet hours)

Log out

User profile information

🔧 Service Files
notification_service.dart - Notification Service
Function: Push notification management and event reminders

Features:

Flutter Local Notifications

Event-based automatic notifications

Reminders 7 days, 1 day, 1 hour in advance

Notification history management

Debug and test functions

services/local_storage_service.dart - Local Storage
Function: Local data management with SharedPreferences

Features:

User session information

Application settings

Cache management

🔐 Admin Modules
admin_yaklasan_etkinlikler.dart - Event Management (Admin)
Function: Adding/editing upcoming events for administrators

Features:

Event title, detail, and date management

Adding image URL

Deleting and updating events

Firebase Firestore integration

Date and time picker

admin_survey_page.dart - Survey Results Management
Function: Viewing and analyzing survey results

Features:

Application evaluation statistics

Custom bar chart system

Categorizing user feedback

Community, application, and event feedback

Real-time data update

cleaner_admin_page.dart - Cleanup Management
Function: Database cleanup and maintenance operations

Topluluk_Haberleri_Yönetici.dart - News Management
Function: Adding/editing community news

BlackList.dart - Blacklist Management
Function: User blocking system

puanlama_sayfasi.dart - AI Scoring Page
Function: Student performance evaluation system

📊 Data Models and Helper Files
ders_notlari1_new.dart - Advanced Lecture Notes System
Function: Next-generation lecture notes sharing system

Features:

Comprehensive legal disclaimer system

User approval mechanism

Favorites system

Like/dislike system

Download counter

Anonymous user support

Advanced search and filtering

DersNotlariAdmin1.dart - Lecture Notes Admin Panel
Function: Lecture notes management for administrators

Features:

Add/edit/delete notes

Search and filter

Note cards with visual support

Semester and exam type management

DersNotlarimPage.dart - My Personal Lecture Notes
Function: Users managing their personal lecture notes

Features:

Add/delete course

Midterm and final photos

Local storage system

Image management

uye_kayit_bilgileri.dart - Member Registration Info Management
Function: Viewing and managing registered members' information

Features:

User search and filtering system

Pagination support

User account status management (active/blocked)

Password visibility control

Data export (in CSV format)

Detailed user profile viewing

Sorting and filtering options

oylama.dart - Voting System
Function: Creating and managing community votes

Features:

Multiple-choice voting

Single vote per user

Real-time results display

Voting deletion authority

Vote tracking with SharedPreferences

Cerezler.dart - Site Session Tracking
Function: Analyzing website session data

Features:

IP address tracking

Session duration analysis

User consent status

Logout tracking

Unique visitor count

BasvuruSorgulama.dart - Application Management System
Function: Managing trip and event applications

Features:

Application search and filtering

Payment status tracking

Application deletion (double confirmation system)

Real-time application count

Detailed application information

adminFeedBack.dart - Feedback Management
Function: Managing user feedback

Features:

Firebase integration

Feedback listing

Refresh feature

Gradient background design

community_news2_page.dart - Community News Display
Function: Displaying community news to users

Features:

Date-sorted news listing

News with visual support

Gradient background

Real-time news update

uyekayıt.dart / uye_kayit.dart - Member Registration
Function: New member registration processes

member_profiles_account.dart - Member Profiles
Function: Member profile information management

website_applications_page.dart - Web Applications
Function: Managing website applications

🚀 Installation
Requirements
Flutter SDK 3.6.1 or higher

Dart SDK 3.6.1 or higher

Android Studio / VS Code

Java 17 (for Android development)

Gradle 8.12

Firebase account and project configuration

Android SDK (API Level 21 or higher)

Step-by-Step Installation
Install Flutter:

# Check if Flutter is installed
flutter doctor

Clone the project:

git clone [repository-url]
cd ket

Install dependencies:

flutter pub get

Firebase configuration:

Add the android/app/google-services.json file

Configure your project in the Firebase Console

Run the application:

flutter run

📋 Configuration
Firebase Setup
Create a new project in the Firebase Console

Add an Android app (com.example.ekos)

Place the google-services.json file in the android/app/ folder

Enable Firebase Authentication, Firestore, Cloud Messaging, and Realtime Database

Configure security rules

Required Permissions (Android)
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

Application Configuration
Check dependencies in the pubspec.yaml file

Place Firebase configuration files

Configure Android signing certificates

Set up notification channels

🔧 Development Environment
Debug Mode
flutter run --debug

Release Mode
flutter build apk --release

Profile Mode (Performance Analysis)
flutter run --profile

📱 Application Architecture
Folder Structure
lib/
├── services/           # Service layer
│   ├── local_storage_service.dart
│   └── notification_service.dart
├── admin/              # Admin panel
├── pages/              # Main pages
├── widgets/            # Reusable components
└── main.dart           # Application entry point

Data Flow
Firebase Firestore: Main database

SharedPreferences: Local settings

Firebase Auth: User authentication

Firebase Messaging: Push notifications

🔐 Security Features
User Authentication
Firebase Authentication integration

Anonymous login support

Account blocking system

Secure password management

Data Security
Firestore security rules

Encryption of user data

Secure storage of API keys

Legal disclaimer and terms of use

📊 Performance Optimization
Database Optimization
Firestore indexing

Pagination

Real-time listeners

Cache management

UI/UX Optimization
Lazy loading

Visual optimization

Responsive design

Dark/light mode support

🧪 Testing
Unit Tests
flutter test

Widget Tests
flutter test test/widget_test.dart

Integration Tests
flutter drive --target=test_driver/app.dart

📈 Analytics and Monitoring
Firebase Analytics
User behavior analysis

Screen view statistics

Event tracking

Crash reports

Performance Monitoring
Firebase Performance Monitoring

Network request analysis

Application startup times

Memory usage

🚀 Deployment
Google Play Store
Application signing

APK/AAB creation

Store listing

Version management

Firebase App Distribution
Adding test users

Beta version distribution

Collecting feedback

🔄 Update System
Automatic Update
In-app update API

Mandatory update check

User notification

Update status tracking

📞 Support and Contact
Developer Contact
Email: arifkerem71@gmail.com

Community: Kırıkkale University Economics Community

Bug Reporting
Use GitHub Issues

Add a detailed bug description

Share screenshots

Specify device and version information

📄 License
This project is licensed under the MIT license. See the LICENSE file for details.

🙏 Contributors
Arif Özdemir - Main Developer

Kırıkkale University Economics Community - Project Sponsor

📝 Version History
v6.8.9 (Current)
Advanced lecture notes sharing system

Admin panel improvements

Notification system updates

Performance optimizations

AI Ket added

v5.x.x
Basic features

Firebase integration

User interface improvements

🤖 KET AI Assistant
<div align="center">
<img src="assets/images/ketyapayzeka.png" alt="KET AI Assistant" width="120"/>
<br>
<strong>Smart community assistant powered by Google Gemini AI</strong>
</div>

🧠 AI Features
💬 Smart Chat System
Google Gemini 1.5 Flash model integration

Natural conversation with Turkish language support

Customized answers with KET knowledge base

Contextual understanding and smart answer generation

Firebase database integration allows AI to access data from collections

🎤 Multiple Communication Channels
Sending and recording voice messages

Asking questions with Speech-to-Text

Reading answers aloud with Text-to-Speech

Sending and explaining photos with Visual analysis

📚 Comprehensive Knowledge Base
500+ community information with detailed explanations

Event and organization information

Lecture notes system guidance

Membership and account management support

Troubleshooting and technical support

🎨 Modern User Interface
Dark/Light mode support

Message copying and deletion features

Message history with timestamps

Quick access to frequently asked questions

Fair resource management with usage limits

⚡ Performance and Security
Resource optimization with a daily 10 message limit

Spam protection with 10 messages in 5 minutes

Chat history local storage

API security and error handling

🚀 KET AI Usage Scenarios
📋 Community Information
"What is KET?"
"How can I become a member?"
"Are events free?"
"What are the contact details?"

📖 Academic Support
"How are lecture notes shared?"
"How can I get a certificate?"
"Are there internship opportunities?"

🔧 Technical Support
"The app is not working"
"I am not receiving notifications"
"I forgot my password"

📊 Visual Analysis
Explaining economic graphs

Analyzing lecture note content

Evaluating event posters

Interpreting financial statements

🎯 AI Assistant Advantages
24/7 Availability: Always active support

Instant Response: Fast and accurate information

Personalized: Special greeting with the user's name

Multi-lingual: Natural language processing focused on Turkish

Learnable: A continuously evolving knowledge base

🔮 Future Plans
Near Term
Expanding iOS support

Offline mode improvements

More language support

Advanced analytics

Long Term
Web application development (The website will likely remain the same for a while)

AI integration ✅ COMPLETED

Expanding social features

Microservice architecture

📱 Application Screenshots
<div align="center">
<img src="https://r.resimlink.com/0BKyUzkbDhF.jpg" width="200"/>
<img src="https://r.resimlink.com/mdVa90Y5_kc.jpg" width="200"/>
<img src="https://r.resimlink.com/g0Dn6Hj7NR.jpg" width="200"/>
<img src="https://r.resimlink.com/rZ5HXtwTLyi.jpg" width="200"/>
</div>

<div align="center">
<img src="https://r.resimlink.com/6lVfg.jpg" width="200"/>
<img src="https://r.resimlink.com/O_Fg0hs1.jpg" width="200"/>
<img src="https://r.resimlink.com/tsz-JqXNA.jpg" width="200"/>
<img src="https://r.resimlink.com/IFEgL.jpg" width="200"/>
</div>

<div align="center">
<img src="https://r.resimlink.com/JL7fY61ykD3.jpg" width="200"/>
<img src="https://r.resimlink.com/oxU_JkX7prD.jpg" width="200"/>
<img src="https://r.resimlink.com/_zPQaNC.jpg" width="200"/>
<img src="https://r.resimlink.com/E9PVRF.jpg" width="200"/>
</div>

<div align="center">
<img src="https://r.resimlink.com/3md5lyQ6MFYL.jpg" width="200"/>
<img src="https://r.resimlink.com/H72bxAdM.jpg" width="200"/>
<img src="https://r.resimlink.com/_JiWaSqXU.jpg" width="200"/>
<img src="https://r.resimlink.com/h7dALa4jn8mq.jpg" width="200"/>
</div>

<div align="center">
<img src="https://r.resimlink.com/rik1c3NL-O.jpg" width="200"/>
<img src="https://r.resimlink.com/EVcydXAKSlg.jpg" width="200"/>
<img src="https://r.resimlink.com/X4j8V03mwNR.jpg" width="200"/>
<img src="https://r.resimlink.com/GOwZu.jpg" width="200"/>
</div>

🎬 Media and Resources
📺 Video Content
Project Promotion Video - Comprehensive introduction to the KET mobile application and website

Feature Demos - Demonstration of the application's core features

Installation Guide - Step-by-step installation and configuration

📚 Documentation
API Documentation - Firebase and external API integrations

Developer Guide - Code structure and development standards

User Manual - Application usage guide

Note: This README file is continuously updated. Follow the repository for the latest information.

<div align="center">
<strong>Stay one step ahead in the world of economics with KET! 📈</strong>
<br><br>
<img src="https://img.shields.io/badge/Flutter-3.6.1+-blue?logo=flutter" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-3.6.1+-blue?logo=dart" alt="Dart">
<img src="https://img.shields.io/badge/Firebase-Latest-orange?logo=firebase" alt="Firebase">
<img src="https://img.shields.io/badge/Version-6.8.9-green" alt="Version">
<br>
<a href="https://www.youtube.com/watch?v=3jnqW75B0Bk">
<img src="https://www.google.com/search?q=https://img.shields.io/badge/YouTube-Promotion_Video-red%3Flogo%3Dyoutube" alt="YouTube Video">
</a>
</div>
