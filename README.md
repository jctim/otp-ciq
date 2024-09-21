[<img src="publish/Connect IQ Badge-White.png" alt="version 2" height="88"/>](https://apps.garmin.com/en-US/apps/ee88adca-09ca-41c1-a097-dd0d6346541f)

# otp-ciq

**OTP Auth Widget for Garmin Connect IQ** - manager of one-time passwords right on a Garmin wearable device. 

It actually consists of two parts:

- the 'settings' part aimed to enter secret keys for several accounts (limited by 10 in initial version and by 20 in version 2.0), it runs on a smartphone (Garmin Connect&trade; mobile app)
- the generator and viewer of one-time passwords on a Garmin wearable device

### Existing Features

- Supported all existing round Garmin watches
- One-time passwords are 6-digit codes (or 7- and 8-digit codes in version 2.0)
- Secret keys are transferred from Garmin Connect&trade; to a wearable device and stay there in [Application Storage](https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/Application/Storage.html) (for Connect IQ 2.4 and higher) or in [App Properties](https://developer.garmin.com/downloads/connect-iq/monkey-c/doc/Toybox/Application/AppBase.html#getProperty-instance_method) for older devices (e.g. Fenix3)
- Secret codes can be entered and copied directly to corresponding text inputs (including spaces between groups)

### TODO Features

- Support Garmin watches from square family

# Links

- [Connect IQ Store](https://apps.garmin.com/en-US/apps/f341dc64-bf39-4224-9c03-14d2434354a4)
- [Connect IQ Store (version 2.0)](https://apps.garmin.com/en-US/apps/ee88adca-09ca-41c1-a097-dd0d6346541f)
- [TOTP RFC](https://tools.ietf.org/html/rfc6238)

# License

The source code is released under the [MIT license](https://opensource.org/licenses/MIT)
