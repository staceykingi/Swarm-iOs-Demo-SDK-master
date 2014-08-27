//
//  BLESUrlDefinitions.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.17..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

/**
 * Here can you change the URL-s used for REST requests
 **/

#ifndef URLmacros
#define URLmacros
#define __BASEURL__ http://192.168.10.100


/**
 * To swich from Azure mock server to the Gears backend, change it to 0. In this case WireShark should be 0 as well.
 **/
#define useMockUrls 0
#define logCallstack 1
#define WireShark 0

#if WireShark
#define baseUrlForReachability @"http://192.168.10.100/publish"
#define urlPostCustomerLocationEvent @"http://192.168.10.100/publish"
#define urlCouponImageOne [NSURL URLWithString: @"http://requinsynergy.azurewebsites.net/Images/Qr-code-ver-10.png"]
#define urlPostReactionForCoupon @"http://192.168.10.100/publish"
#define urlBaseGetCouponForCampaign @"http://192.168.10.100/publish"
#define urlBaseGetActiveCampaignsForLocation @"http://192.168.10.100/publish"
#define urlWhereAmIService @"http://192.168.10.100/publish"
#define urlBaseWhatIsHereService @"http://192.168.10.100/publish"
#define urlBaseGetWallet @"http://192.168.10.100/publish"
#else

//Used to check server's reachability - replace it to the Gears backend url
#define baseUrlForReachability @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/"
#define baseUrlMockForReachability @"http://requinsynergy.azurewebsites.net"
// http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/

//URL for cutomer location event pushes
#define urlPostCustomerLocationEvent @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/publish"
#define urlPostMockCustomerLocationEvent @"http://192.168.10.100/publish"


//URL to GET the customer's accepted, but not yet redeemed coupons
#define urlBaseGetWallet @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/my/coupon?userid="
//URL to download coupons - mock
#define mockCouponsUrl [NSURL URLWithString: @"http://requinsynergy.azurewebsites.net/ListQueries/listCoupons.aspx"]




#define urlCouponImageOne [NSURL URLWithString: @"http://requinsynergy.azurewebsites.net/Images/Qr-code-ver-10.png"]

#define mockCampaignsUrl @"http://requinsynergy.azurewebsites.net/ListQueries/listCampaigns.aspx"

//URL to post accept/reject for a coupon - POST
// /my/coupon/{action}/{couponId}
//#define urlPostReactionForCoupon @"http://requinsynergy.azurewebsites.net/ListQueries/listCoupons.aspx"
#define urlPostReactionForCoupon @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/my/coupon/"
//+{couponid}"

//URL to GET a coupon for a campaign
#define urlBaseGetCouponForCampaign @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/coupon/campaign/"
//#define urlBaseGetCouponForCampaign @"/coupon/campaign/{campaignId}?userid="
#define urlBaseGetMockCouponForCampaign @"http://requinsynergy.azurewebsites.net/ListQueries/getCouponForCampaign.aspx"

//List active campaigns for location id (beacon id) - GET
//TODO: where is this called?!
#define urlBaseGetActiveCampaignsForLocation  @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/campaign/"
//+{major}/{minor}"

#define urlWhereAmIService @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/where_am_i"
//#define urlWhereAmIService @"http://192.168.10.100/publish"
#define urlBaseWhatIsHereService @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/what_is_here?userid="

//url for swarmLogin
#define urlPostSwarmLogin @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/api/login"

#endif


//----Used in DEMO ------------------------------------------------

//Get customers for demo
#define urlGetCustomersForDemo @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/customer"
#define urlGetMockCustomersForDemo @"http://requinsynergy.azurewebsites.net/ListQueries/listUsers.aspx"

//Get a customers segment data
//TODO: use this as well
#define urlBaseGetCustomerSegmentData @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/customer/{customerId}"

//Get list of locations (beacons)
#define urlGetLocations @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/location"
#define mockBeaconsUrl @"http://requinsynergy.azurewebsites.net/ListQueries/listBeacons.aspx"

//Get a single location data
//TODO: használ vhol
#define urlBaseGetLocationData @"http://pos-gateway-dev.swarm-mobile.com/ibeacon/services/location/{locationId}"

//-----------------------------------------------------------------


#define beaconUUID @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
#endif
