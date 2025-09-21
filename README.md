🎓 EKOS - Kırıkkale University Economics Society Mobile Application
<div align="center"> <img src="assets/images/ekoslogo.png" alt="EKOS Logo" width="200"/> <br> <strong>Modern Flutter mobile application for Kırıkkale University Economics Society</strong> </div>
📱 About the Project
EKOS is a comprehensive mobile application developed with Flutter for Kırıkkale University Economics Society. The app offers extensive features including community events, current economic news, course material sharing, and social media integration.

🎥 Project Introduction Video
<div align="center"> <a href="https://www.youtube.com/watch?v=3jnqW75B0Bk" target="_blank"> <img src="https://img.youtube.com/vi/3jnqW75B0Bk/maxresdefault.jpg" alt="EKOS Project Introduction Video" width="600"/> </a> <br> <strong>📺 <a href="https://www.youtube.com/watch?v=3jnqW75B0Bk">EKOS Mobile App and Website Introduction Video</a></strong> <br> <em>Detailed project introduction, features, and usage guide</em> </div>
Version: 6.8.9
Developer: Arif Özdemir
Platform: Android (iOS support available)
Language: Dart/Flutter
Database: Firebase Firestore
Minimum SDK: Android API 34 (Android 13)
Target SDK: Android API 36 (Android 16)

✨ Features
📚 Education & Academic
Course Material Sharing System: Share course materials among members

My Course Materials: Personal course material management

Event Calendar: Track academic and social events

Upcoming Events: Notifications for future events

📰 News & Communication
Community News: Latest community announcements

Social Media Integration: Access to community social media accounts

Feedback System: Share opinions about the app and community

Poll System: Collect member opinions

💰 Economy & Finance
Current Economy: Latest economic developments

Live Market: Real-time financial data

Economic Analysis: Expert opinions and analysis

👥 Community Management
Member Registration System: New member applications

Member Profiles: Community member information

Admin Panel: Special panel for community administrators

Sponsors: Community sponsors and collaborations

🔔 Notifications & Security
Push Notifications: Instant notifications for important announcements

Account Security: Secure login and account management

Offline Mode: Some features available without internet connection

Auto Update: Check for app updates

🛠️ Technologies
Frontend
Flutter 3.6.1+ - Cross-platform mobile app development

Dart 3.6.1+ - Programming language

Material Design 3 - Modern UI/UX design

Backend & Database
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

in_app_update - In-app updates

flutter_local_notifications - Local notifications

http - HTTP requests

intl - Internationalization and date formats

share_plus - Content sharing

📂 Project Structure & Dart Files Functionality
🏠 Main Files
main.dart - Application Entry Point
Function: Main entry point and initialization

Features:

Firebase initialization and configuration

User authentication system

Splash screen and loading screens

App update checking

Push notification configuration

Background tasks with Workmanager

Home page grid menu system

Account blocking control

firebase_service.dart - Firebase Operations
Function: Firebase Firestore database operations

Features:

Add/retrieve feedback

Tournament application management

Database CRUD operations

Error management

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

Course material management

current_economy.dart - Current Economic News
Function: Fetch economic news from Anadolu Agency RSS feed

Features:

RSS feed reading and parsing

News filtering system

Dark/light mode

News reporting system

Sharing feature

Legal warning system

Automatic news updates

live_market.dart - Live Market Tracking
Function: Real-time tracking of crypto and stock prices

Features:

CoinGecko API integration

Turkish stock simulation

Favorite adding system

Price charts (Syncfusion Charts)

Comparison feature

Search and filtering

Candlestick charts

ders_notlari1.dart - Course Material Sharing System
Function: Course material sharing among students

Features:

Faculty/department/course filtering

PDF file sharing

Like/dislike system

Favorite adding

Download counter

Legal warnings and terms of use

Anonymous user system

etkinlik_takvimi2.dart - Event Calendar
Function: List community events

Features:

Firebase Firestore integration

Date sorting

Visually supported event cards

Gradient background design

Responsive design

yaklasan_etkinlikler.dart - Upcoming Events
Function: Show future events and set alarms

Features:

Remaining time calculation

Alarm setting system (for Samsung and other brands)

Intent system integration with clock app

Real-time updates

social_media_page.dart - Social Media
Function: Redirect to community social media accounts

Features:

Instagram and Twitter integration

External links with URL launcher

Responsive card design

feedback.dart - Feedback System
Function: Collect user feedback

Features:

Anonymous feedback

Firebase Firestore storage

Optional email address

Form validation

poll.dart - Poll System
Function: Create and manage community polls

Features:

Multiple choice questions

Open-ended questions

Firebase Firestore storage

Anonymous poll system

sponsors_page.dart - Sponsors
Function: Sponsorship information and contact

Features:

Email integration

Sponsorship application system

Contact form

account_settings_page.dart - Account Settings
Function: User account management

Features:

Password change

Account deletion/deactivation

Notification settings (quiet hours)

Logout

User profile information

🔧 Service Files
notification_service.dart - Notification Service
Function: Push notification management and event reminders

Features:

Flutter Local Notifications

Event-based automatic notifications

7 days, 1 day, 1 hour before reminders

Notification history management

Debug and test functions

services/local_storage_service.dart - Local Storage
Function: Local data management with SharedPreferences

Features:

User session information

App settings

Cache management

🔐 Admin Modules
admin_yaklasan_etkinlikler.dart - Event Management (Admin)
Function: Add/edit upcoming events for administrators

Features:

Event title, detail and date management

Add image URL

Event deletion and updates

Firebase Firestore integration

Date and time picker

admin_survey_page.dart - Poll Results Management
Function: View and analyze poll results

Features:

App evaluation statistics

Custom bar chart system

Categorize user feedback

Community, app and event feedback

Real-time data updates

cleaner_admin_page.dart - Cleaning Management
Function: Database cleaning and maintenance operations

Topluluk_Haberleri_Yönetici.dart - News Management
Function: Add/edit community news

BlackList.dart - Blacklist Management
Function: User blocking system

puanlama_sayfasi.dart - AI Scoring
Function: Student performance evaluation system

📊 Data Models & Helper Files
ders_notlari1_new.dart - Advanced Course Material System
Function: Next-gen course material sharing system

Features:

Comprehensive legal warning system

User consent mechanism

Favorite adding system

Like/dislike system

Download counter

Anonymous user support

Advanced search and filtering

DersNotlariAdmin1.dart - Course Materials Admin Panel
Function: Course material management for administrators

Features:

Add/edit/delete notes

Search and filtering

Visually supported note cards

Semester and exam type management

DersNotlarimPage.dart - Personal Course Materials
Function: Users manage personal course materials

Features:

Add/delete courses

Midterm and final photos

Local storage system

Visual management

uye_kayit_bilgileri.dart - Member Registration Info Management
Function: View and manage registered member information

Features:

User search and filtering system

Pagination support

User account status management (active/disabled)

Password visibility control

Data export (CSV format)

Detailed user profile viewing

Sorting and filtering options

oylama.dart - Voting System
Function: Create and manage community votes

Features:

Multiple choice voting

One vote per user

Real-time results viewing

Vote deletion authority

Vote tracking with SharedPreferences

Cerezler.dart - Website Session Tracking
Function: Analyze website session data

Features:

IP address tracking

Session duration analysis

User consent status

Exit tracking

Unique visitor count

BasvuruSorgulama.dart - Application Management System
Function: Manage trip and event applications

Features:

Application search and filtering

Payment status tracking

Application deletion (double confirmation system)

Real-time application count

Detailed application information

adminFeedBack.dart - Feedback Management
Function: Manage user feedback

Features:

Firebase integration

Feedback listing

Refresh feature

Gradient background design

community_news2_page.dart - Community News Display
Function: Show community news to users

Features:

Date-sorted news listing

Visually supported news

Gradient background

Real-time news updates

uyekayıt.dart / uye_kayit.dart - Member Registration
Function: New member registration operations

member_profiles_account.dart - Member Profiles
Function: Member profile information management

website_applications_page.dart - Web Applications
Function: Manage website applications

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

bash
# Check if Flutter is installed
flutter doctor
Clone the project:

bash
git clone [repository-url]
cd ket
Install dependencies:

bash
flutter pub get
Firebase configuration:

Add android/app/google-services.json file

Configure your project in Firebase Console

Run the app:

bash
flutter run
📋 Configuration
Firebase Setup
Create new project in Firebase Console

Add Android app (com.example.ekos)

Place google-services.json in android/app/ folder

Enable Firebase Authentication, Firestore, Cloud Messaging and Realtime Database

Configure security rules

Required Permissions (Android)
xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
App Configuration
Check dependencies in pubspec.yaml

Place Firebase configuration files

Configure Android signing certificates

Set up notification channels

🔧 Development Environment
Debug Mode
bash
flutter run --debug
Release Mode
bash
flutter build apk --release
Profile Mode (Performance Analysis)
bash
flutter run --profile
📱 Application Architecture
Folder Structure
text
lib/
├── services/           # Service layer
│   ├── local_storage_service.dart
│   └── notification_service.dart
├── admin/             # Admin panel
├── pages/             # Main pages
├── widgets/           # Reusable components
└── main.dart          # Application entry point
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

User data encryption

Secure API key storage

Legal warnings and terms of use

📊 Performance Optimization
Database Optimization
Firestore indexing

Pagination

Real-time listeners

Cache management

UI/UX Optimization
Lazy loading

Image optimization

Responsive design

Dark/light mode support

🧪 Testing
Unit Tests
bash
flutter test
Widget Tests
bash
flutter test test/widget_test.dart
Integration Tests
bash
flutter drive --target=test_driver/app.dart
📈 Analytics & Monitoring
Firebase Analytics
User behavior analysis

Screen view statistics

Event tracking

Crash reports

Performance Monitoring
Firebase Performance Monitoring

Network request analysis

App startup times

Memory usage

🚀 Deployment
Google Play Store
App signing

APK/AAB generation

Store listing

Version management

Firebase App Distribution
Add test users

Beta version distribution

Collect feedback

🔄 Update System
Automatic Updates
In-app update API

Mandatory update checking

User notification

Update status tracking

📞 Support & Contact
Developer Contact
Email: arifkerem71@gmail.com

Community: Kırıkkale University Economics Society

Bug Reporting
Use GitHub Issues

Add detailed bug description

Share screenshots

Specify device and version information

📄 License
This project is licensed under the MIT License. See the LICENSE file for details.

🙏 Contributors
Arif Özdemir - Main Developer

Kırıkkale University Economics Society - Project Sponsor

📝 Version History
v6.8.9 (Current)
Advanced course material sharing system

Admin panel improvements

Notification system updates

Performance optimizations

AI assistant added

v5.x.x
Basic features

Firebase integration

User interface improvements

🤖 EKOS AI Assistant
<div align="center"> <img src="assets/images/ketyapayzeka.png" alt="EKOS AI Assistant" width="120"/> <br> <strong>Smart community assistant powered by Google Gemini AI</strong> </div>
🧠 AI Features
💬 Smart Chat System
Google Gemini 1.5 Flash model integration

Turkish language support with natural conversation

EKOS knowledge base with customized responses

Contextual understanding and intelligent answer generation

Firebase database integration - AI can access collection data

🎤 Multiple Communication Channels
Voice message sending and recording

Speech-to-Text for asking questions by voice

Text-to-Speech for reading responses aloud

Visual analysis for sending and describing photos

📚 Comprehensive Knowledge Base
500+ community information with detailed explanations

Event and organization information

Course materials system guidance

Membership and account management support

Troubleshooting and technical support

🎨 Modern User Interface
Dark/Light mode support

Message copying and deletion features

Timestamp with message history

Frequently asked questions quick access

Usage limits with fair resource management

⚡ Performance & Security
10 daily messages limit for resource optimization

10 messages in 5 minutes spam protection

Chat history local storage

API security and error management

🚀 EKOS AI Usage Scenarios
📋 Community Information
text
"What is EKOS?"
"How can I become a member?"
"Are events free?"
"What are the contact details?"
📖 Academic Support
text
"How to share course materials?"
"How to get a certificate?"
"Are there internship opportunities?"
🔧 Technical Support
text
"App not working"
"Not receiving notifications"
"I forgot my password"
📊 Visual Analysis
Economy chart explanations

Course material content analysis

Event poster evaluation

Financial table interpretation

🎯 AI Assistant Advantages
24/7 Accessibility: Always active support

Instant Responses: Fast and accurate information

Personalized: Personalized greeting with username

Multilingual: Turkish-focused natural language processing

Learnable: Continuously developing knowledge base

🔮 Future Plans
Short Term
Expand iOS support

Offline mode improvements

More language support

Advanced analytics

Long Term
Web application development (Website will probably remain the same for a while longer)

AI integration ✅ COMPLETED

Expand social features

Microservices architecture

📱 Application Screenshots
<div align="center"> <img src="https://r.resimlink.com/0BKyUzkbDhF.jpg" width="200"/> <img src="https://r.resimlink.com/mdVa90Y5_kc.jpg" width="200"/> <img src="https://r.resimlink.com/g0Dn6Hj7NR.jpg" width="200"/> <img src="https://r.resimlink.com/rZ5HXtwTLyi.jpg" width="200"/> </div><div align="center"> <img src="https://r.resimlink.com/6lVfg.jpg" width="200"/> <img src="https://r.resimlink.com/O_Fg0hs1.jpg" width="200"/> <img src="https://r.resimlink.com/tsz-JqXNA.jpg" width="200"/> <img src="https://r.resimlink.com/IFEgL.jpg" width="200"/> </div><div align="center"> <img src="https://r.resimlink.com/JL7fY61ykD3.jpg" width="200"/> <img src="https://r.resimlink.com/oxU_JkX7prD.jpg" width="200"/> <img src="https://r.resimlink.com/_zPQaNC.jpg" width="200"/> <img src="https://r.resimlink.com/E9PVRF.jpg" width="200"/> </div><div align="center"> <img src="https://r.resimlink.com/3md5lyQ6MFYL.jpg" width="200"/> <img src="https://r.resimlink.com/H72bxAdM.jpg" width="200"/> <img src="https://r.resimlink.com/_JiWaSqXU.jpg" width="200"/> <img src="https://r.resimlink.com/h7dALa4jn8mq.jpg" width="200"/> </div><div align="center"> <img src="https://r.resimlink.com/rik1c3NL-O.jpg" width="200"/> <img src="https://r.resimlink.com/EVcydXAKSlg.jpg" width="200"/> <img src="https://r.resimlink.com/X4j8V03mwNR.jpg" width="200"/> <img src="https://r.resimlink.com/GOwZu.jpg" width="200"/> </div>
🎬 Media & Resources
📺 Video Content
Project Introduction Video - Comprehensive introduction to EKOS mobile app and website

Feature Demos - Demonstrations of app's core features

Installation Guide - Step-by-step installation and configuration

📚 Documentation
API Documentation - Firebase and external API integrations

Developer Guide - Code structure and development standards

User Guide - Application usage guide

Note: This README file is continuously updated. Follow the repository for the most current information.

<div align="center"> <strong>Stay one step ahead in the economy world with EKOS! 📈</strong> <br><br> <img src="https://img.shields.io/badge/Flutter-3.6.1+-blue?logo=flutter" alt="Flutter"> <img src="https://img.shields.io/badge/Dart-3.6.1+-blue?logo=dart" alt="Dart"> <img src="https://img.shields.io/badge/Firebase-Latest-orange?logo=firebase" alt="Firebase"> <img src="https://img.shields.io/badge/Version-6.8.9-green" alt="Version"> <br> <a href="https://www.youtube.com/watch?v=3jnqW75B0Bk"> <img src="https://img.shields.io/badge/YouTube-Introduction_Video-red?logo=youtube" alt="YouTube Video"> </a> </div>
