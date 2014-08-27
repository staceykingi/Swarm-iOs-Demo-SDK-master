Swarm-iOS-SDK
==================
##Intro to Swarm iOS SDK                                                                                                                                                                        
Swarm introduces the Swarm iOS SDK, empowering application providers to access real-time 1st party shopper data by simply integrating the Swarm iOS SDK into your mobile application. Swarm enables a direct communication channel with your consumers, every time they are in range of a Swarm Beacon (Typical range maximum is approximately 40 ft). Now you can understand your users offline behavior as much as you understand their online behavior.

##SDK Setup
__Note:__ This Demo version of the SDK is identical to the Production SDK except that it is configured to monitor the Demo Swarm Beacon Network ID (Demo UUID) instead of the Production Swarm Beacon Network ID (Production UUID). When you have completed your testing, contact us and we will migrate you to the Production Swarm Beacon Network (Production UUID).

As part of your request for access to this SDK, you should have received both a Swarm PartnerID and an API Key in the email arranging access to the Github repository. The API key is your individualized key and you should take care to keep it secure and secret. If you do not have a PartnerID or an API Key please reach out to support@swarm-mobile.com.

To get started, you can download Swarm iOS SDK here. Click button called “Download as Zip” which allows you to download a zip file containing all the SDK files.

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/download_pic.png)

Drag the project called SwarmSDK.xcodeproj called located in the /SwarmSDK/ directory into your project workspace.

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/xcodeproject_folder.png)

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/sucessful_import.png)


In XCode, go to the Build Phases menu and open the Link Binary with Libraries section and open that section.  

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/link_binary.png)

Click the “+”  under the “Name” and the file libSwarmSDK.a should appear  under the Workspace section.

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/libswarmsdk_a_add_to_build.png)

Add this file. If this file does not appear, click “Add other” and navigate to SwarmSDK / build / Debug-iphoneos /  and add the libSwarmSDK.a file located there.

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/add_other_libswarmsdk_a.png)

After this you can import the SwarmSDK.h header file. To get an instance, call [[SwarmSDK alloc]init].

It is expected that there is only one instance of the class, stored inside a singleton object. Each time you navigate to a new view controller, you can set up the delegates provided by the SDK, so the actual controller will always get notification from the SDK. As the application uses core location, the appropriate permissions have to be enabled for the project.

Before using the SDK, you have to setup the API key, which is unique for every developer using the SDK. This will be assigned to you when you get the package, and can be set by calling the setSwarmApiKey method.

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/api_instance.png)

After the API key is set, you need to provide a customerId and your partnerId. The CustomerID the one in your system, which we will call “remoteId” in this document, and can be set by initRemoteId. The partnerId represents you, as a SwarmSDK implementor, and together with the remoteId it can identify your enduser. This can be set with the initPartnerId function.

These pieces of data, and some other information are used to sign all requests sent to our servers, and they increase the security of the communication. The API key is never transmitted directly, and you should keep it in secret too.


##How it works
By integrating the Swarm iOS SDK with your application, you will be able to understand and engage with your users like never before. Upon first connection with the Swarm Beacon, our database will assign a unique identifier. As your application user moves throughout the physical world, Swarm Beacons and in-store POS integrations will capture their activities. The Swarm Collective Intelligence Database will then establish linkages between these activities to paint a detailed picture of their offline behavior, presented to you in the form of a comprehensive shopper profile.

The Swarm iOS SDK toolkit consists of a set of services to facilitate data exchange

* __WhereAmI__ Match user with a specific beacon, to identify where they are in-store.
* __WhatIsHere__: Identify campaigns associated with that specific location, and match items/brands to that place.
* __DoSwarmLogin__: Create a Swarm ID for user, for a faster way to find them. Exchange app data with Swarm data.


In order to best leverage Swarm’s Beacon Ecosystem it is important to carefully consider exactly what the SDK is able to do and it’s limitations when trying to implement your Usecase.

The iBeacon standard, which Swarm Beacons adhere to, is an extension of iOS’s [Location Services](http://support.apple.com/kb/HT6048). One of the services that it offers is Region Monitoring. In geographical terms a Region would be a circular region centered around a lat/long coordinate. In iBeacon terms this would be a network of iBeacons defined by a shared UUID. 

Region Monitoring is able to wake the App up from running in the background or if closed when the App enters or exits the region.

Once the App is awoken it can run for 10 seconds if closed completely and ~2 minutes if it is running in the background. The only triggers that will wake the App from closed or running the background is if you enter or exit the region, e.g. when the App first detects something broadcasting the monitored UUID and when it can no longer detect the UUID.

While the App is running actively in the foreground it can Range which determines signal strength between Beacons it has detected and itself. iBeacon uses signal strength to estimate distance. It buckets the estimated distance into 1 of 3 proximity ranges:

1. __Immediate:__ 0 - 6 inches
1. __Near:__ 6 inches - 4 feet
1. __Far:__ 4 feet - 40 feet

__Note:__ Given that distance is estimated based on signal strength there may be some variance in when proximity ranges transition for you. This variance can be due to interference from other physical objects or devices broadcasting in the same frequency range (Bluetooth/WiFi devices).

Consider the proximity ranges and the state of the App (Closed/Background/Foreground) relevant to your Usecase. Fundamentally the SDK extends the set of signals that your App can use to trigger App behavior like sending a notification or checking a User in.

While Closed/Background the SDK empowers your App to awake to trigger behavior if/when it enters/exits the Swarm Beacon Region.

While running in the Foreground the SDK empowers your App to trigger behavior based on the App’s proximity to the Beacon and knowledge of the User.

##Data Exchange
Swarm aggregates data from the consumer, the beacon, and the application. Each time your user is in proximity of a Swarm Beacon, we securely capture the following elements from each source:

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/how_it_works_01.png)

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/data_exchange_1.png)

The Swarm iOS SDK offers a flexible framework for you to achieve varying levels of micromarketing. You can determine the data fields that your app will receive. The more fields you specify, the higher level of data specificity we are able to deliver. The table below outlines fields and data points that your app can receive, or you can create new fields:

![](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/images/data_exchange_2.png)

By integrating with our SDK, you will attain direct access to the SCI Database, with the freedom to aggregate and process the data using the same protocols you currently employ within the rest of your application, or the option to leverage our dashboard to visualize the consumer data.

__Note:__ As per Apple’s App Store policies, we do not recommend collecting the IDFA if your App does not display an ad as it is likely your App will be rejected.

##SDK Services Documentation
More detailed documentation on the SDK's services and how to use them and the data they return is available  [here](http://swarm-mobile.github.io/Swarm-iOs-Demo-SDK/index.html).

##Contact Us
If you find any issues with the SDK or have interesting Usecases that you would like supported please reach out to your Swarm Point of Contact or email us at support@swarm-mobile.com
