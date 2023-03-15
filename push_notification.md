# Easy push notifications

Use [ntfy](https://unifiedpush.org/users/distributors/ntfy/) to send notifications.
And [unifiedpush](https://unifiedpush.org/developers/flutter/) to receive from within your app.


1. [Download F-Droid](https://f-droid.org/F-Droid.apk)
2. Locate `adb` binary (likely in `platform-tools` folder within Android SDK
3. Run `adb install ~/Downloads/F-Droid.apk` to install
4. Open F-Droid on your device and search for and install ntfy
5. Open nfty on device and allow notifications
6. Download [unifiedpush example project](https://github.com/UnifiedPush/flutter-connector/tree/main/example)
7. Run the project in your emulator.
8. Tab "Register" (in the app) and note endpoint url (without `?up=1` part).
9. You can now do a HTTP POST to the url to send a notification. I tried by running `curl -d "title=Hello&message=World&priority=6" <endpoint>`