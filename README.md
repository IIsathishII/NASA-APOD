# NASA-APOD

## ABOUT
This app uses VIP architecture with Coordinator to support navigation as the app grows. Feature related files can be found under 'Modules/PictureDetailExplorer'. The api key is added in Config.xcconfig. Run the app on a device as switching network availability is glitchy on simulator. Change the date in device settings to simulate the Test scenarios. 

## IMPROVEMENT AREAS
- Using a different persistent storage to store PictureOfDayModel rather than UserDefaults
- Made an assumption that the first time app is opened, the phone will be connected to the internet
- Need to delete old image from Document directory when new Picture of Day is fetched
