## Jack Notification

This package is notification for flutter projects. So, you will need to set up notification
configuration.

### Firebase Cloud Messaging (FCM)

-   First, run below command to setup firebase options

    ```shell
    flutterfire configure
    ```

    It will automatically set-up firebase configuration for your project.

Then, setup firebase configuration including listen incoming or opening message by using `jack_notification` package.

-   Initialize the notification service

    ```dart
    final notification = JackLocalNotificationApi();
    final jackNotification = JackNotification(options: DefaultFirebaseOptions.currentPlatform,);

    await jackNotification.init();
    ```

-   Listen the relavent token

    ```dart
    jackNotification.getTokenStream.listen((value) {
      debugPrint(
            "----------------------token ${value.$1}-------notification service ${value.$2}---------------");
    });
    ```

#### Method - 1 (Instant Notification)

`Instant Notification` means notification ui will be shown by relevant notification service of firebase or huawei. When you use notification message, it works in iOS and if you use data message, it won't work in both.

-   Listen notification incoming in active state,

    ```dart
    jackNotification.onMessageListen((message) {
        debugPrint(
            "----------------------onmessage listen $message----------------------");
      });
    ```

-   Listen notification opening in active state,

    ```dart
    jackNotification.onMessageOpened((message) {
      debugPrint(
          "----------------------onmessage opened $message----------------------");
    });
    ```

-   Get showed notification info in terminated state,

    ```dart
    final initialNoti = await jackNotification.getInitialNotification();
    if (initialNoti !=null){
      // ... process with initial noti
    }
    ```

#### Method - 2 (Local Notification with data message)

To show local notification, you should use data message, otherwise notification will show two times in iOS.

-   Listen notification incoming in active state,

    ```dart
    jackNotification.onMessageListen((message) {
      notification.showNotification(title: message.title,body: message.body);
    });
    ```

-   Listen notification opening in active state,

    ```dart
    notification.listenOpenedNotifications((value) {
      debugPrint(
          "------------opened local notification----------${value.payload}----------------------");
    });
    ```

-   Get showed notification info in terminated state,

    ```dart
    notification.listenTerminatedNotifications((value) {
      debugPrint(
          "----------------------terminated local notification-------${value.didNotificationLaunchApp}---------------");
    });
    ```

#### Listen notification in background / terminated state

    ```dart
    /// This function must be top of the `main` function
    @pragma("vm:entry-point")
    Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      debugPrint(
        "........--------------message is------------${message.data}----------------------------......",
      );
    }

    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      runApp(const MyApp());
    }
    ```

### Huawei Cloud Messaging (HCM)

-   Add Maven repositories for Huawei Mobile Services to the `[project]\android\build.gradle`

    ```gradle
    repositories {
       google()
       mavenCentral()
       maven { url 'https://developer.huawei.com/repo/' } // Add this line
    }

    dependencies {
       classpath 'com.android.tools.build:gradle:3.6.0'
       classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
       classpath 'com.huawei.agconnect:agcp:1.8.0.300' // Add this line
    }

    allprojects {
       repositories {
           google()
           mavenCentral()
           maven { url 'https://developer.huawei.com/repo/' } // Add this line
       }
    }
    ```

-   Set release signing and passwords in the same build configuration file to
    the `[project]\android\app\build.gradle`

    ```gradle

     /*
       * <Other configurations>
     */
     plugins {
       id "com.android.application"
       id "kotlin-android"
       id "dev.flutter.flutter-gradle-plugin"
       id "com.huawei.agconnect"   // Add this line after above configurations
     }

     android {
      /*
       * <Other configurations>
      */
        compileSdkVersion 34     // Change this line
        defaultConfig {
          minSdkVersion 23       // Change this line
        }
        signingConfigs {         // Add these lines (signing configs)
          release {
            storeFile file('<keystore_file>')
            storePassword '<keystore_password>'
            keyAlias '<key_alias>'
            keyPassword '<key_password>'
          }
        }
        buildTypes {
          debug {
            signingConfig signingConfigs.release
          }
          release {               // Add these lines
            signingConfig signingConfigs.release
          }
        }
      }
    ```
