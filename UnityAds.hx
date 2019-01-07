package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import openfl.Lib;
#end

#if android
#if openfl_legacy
import openfl.utils.JNI;
#else
import lime.system.JNI;
#end
#end

import com.stencyl.Engine;
import com.stencyl.Input;
import openfl.events.MouseEvent;

import scripts.ByRobinAssets;

class UnityAds {

	private static var initialized:Bool=false;
	private static var _adIsFetch:Bool=false;
	private static var _adFailedToFetch:Bool=false;
	private static var _videoAdDidShow:Bool=false;
	private static var _rewardedAdDidShow:Bool=false;
	private static var _videoCompleted:Bool=false;
	private static var _rewardedCompleted:Bool=false;
	private static var _videoIsSkipped:Bool=false;
	private static var _bannerDidClick:Bool=false;
	private static var _bannerDidError:Bool=false;
	private static var _bannerDidHide:Bool=false;
	private static var _bannerDidShow:Bool=false;


	////////////////////////////////////////////////////////////////////////////
	#if ios
	private static var __init:String->Bool->Bool->Void = function(appId:String,testMode:Bool, debugMode:Bool){};
	private static var __unityads_set_event_handle = Lib.load("unityads","unityads_set_event_handle", 1);
	#end
	#if android
	private static var __init:Dynamic;
	#end
	private static var __showVideo:String->Void = function(videoPlacementId:String){};
	private static var __showRewarded:String->String->String->Void = function(rewardPlacementId:String,alertTitle:String,alertMSG:String){};
	private static var __canShowAds:String->Bool = function(placementId:String):Bool {return false;};
	private static var __isSupported:Void->Bool = function():Bool {return false;};
  private static var __showBanner:String->Void = function(bannerPlacementId:String){};
	private static var __hideBanner:Void->Void = function(){};
	private static var __moveBanner:String->Void = function(position:String){};
	//private static var __destroyBanner:Void->Void = function(){};
	private static var __setConsent:Bool->Void = function(isGranted:Bool){};
	private static var __getConsent:Void->Bool = function(){return false;};

	////////////////////////////////////////////////////////////////////////////

	public static function init(){

		#if ios
		var appId:String = ByRobinAssets.UAIosGameID;
		#elseif android
		var appId:String = ByRobinAssets.UAAndroidGameID;
		#end
		var testMode:Bool = ByRobinAssets.UATestAds;
		var debugMode:Bool = ByRobinAssets.UADebugMode;


		#if ios
		if(initialized) return;
		initialized = true;
		try{
			// CPP METHOD LINKING
			__init = cpp.Lib.load("unityads","unityads_init",3);
			__showVideo = cpp.Lib.load("unityads","unityads_video_show",1);
			__showRewarded = cpp.Lib.load("unityads","unityads_rewarded_show",3);
			__canShowAds = cpp.Lib.load("unityads","unityads_canshow",1);
			__isSupported = cpp.Lib.load("unityads","unityads_issupported",0);
			__showBanner = cpp.Lib.load("unityads","unityads_banner_show",1);
			__hideBanner = cpp.Lib.load("unityads","unityads_banner_hide",0);
			__moveBanner = cpp.Lib.load("unityads","unityads_banner_move",1);
			// __destroyBanner = cpp.Lib.load("unityads","unityads_banner_destroy",0);
			__setConsent = cpp.Lib.load("unityads","unityads_setconsent",1);
			__getConsent = cpp.Lib.load("unityads","unityads_getconsent",0);

			__init(appId,testMode, debugMode);
			__unityads_set_event_handle(notifyListeners);
		}catch(e:Dynamic){
			trace("iOS INIT Exception: "+e);
			initialized = false;
		}
		#end

		#if android
		if(initialized) return;
		initialized = true;
		try{
			// JNI METHOD LINKING
			__showVideo = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "showVideo", "(Ljava/lang/String;)V");
			__showRewarded = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "showRewarded", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
			__canShowAds = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "canShowUnityAds", "(Ljava/lang/String;)Z");
			__isSupported = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "isSupportedUnityAds", "()Z");
			__showBanner = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "showBanner", "(Ljava/lang/String;)V");
			__hideBanner = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "hideBanner", "()V");
			__moveBanner = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "moveBanner", "(Ljava/lang/String;)V");
			// __destroyBanner = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "﻿destroyBanner", "()V");
			__setConsent = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "setUsersConsent", "(Z)V");
			__getConsent = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "getUsersConsent", "()Z");

			if(__init == null)
			{
				__init = JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "init", "(Lorg/haxe/lime/HaxeObject;Ljava/lang/String;ZZ)V", true);
			}

			var args = new Array<Dynamic>();
			args.push(new UnityAds());
			args.push(appId);
			args.push(testMode);
			args.push(debugMode);
			__init(args);
		}catch(e:Dynamic){
			trace("Android INIT Exception: "+e);
		}
		#end
	}

	public static function showVideo(videoPlacementId:String) {
		try {
			__showVideo(videoPlacementId);
		} catch(e:Dynamic) {
			trace("ShowVideo Exception: "+e);
		}
	}

	public static function showRewarded(rewardPlacementId:String,alertTitle:String,alertMSG:String) {
		try {
			__showRewarded(rewardPlacementId,alertTitle,alertMSG);
		} catch(e:Dynamic) {
			trace("ShowRewardedVideo Exception: "+e);
		}
	}

	public static function canShowAds(placementID:String):Bool{

		return __canShowAds(placementID);
	}

	public static function isSupported():Bool{

		return __isSupported();
	}

	public static function showBanner(bannerPlacementId:String) {
		try {
			__showBanner(bannerPlacementId);
		} catch(e:Dynamic) {
			trace("ShowBanner Exception: "+e);
		}
	}

	public static function hideBanner() {
		try {
			__hideBanner();
		} catch(e:Dynamic) {
			trace("HideBanner Exception: "+e);
		}
	}

	public static function moveBanner(position:String) {
		try {
			__moveBanner(position);
		} catch(e:Dynamic) {
			trace("MoveBanner Exception: "+e);
		}
	}
	//Game crash after using destroyBanner
	/*public static function destroyBanner() {
		try {
			__destroyBanner();
		} catch(e:Dynamic) {
			trace("DestroyBanner Exception: "+e);
		}
	}*/

	public static function setConsent(isGranted:Bool) {
		try {
			__setConsent(isGranted);
		} catch(e:Dynamic) {
			trace("SetConsent Exception: "+e);
		}
	}

	public static function getConsent():Bool {

		return __getConsent();
	}

	////callbacks funtions
	public static function adIsFetch():Bool{

		if(_adIsFetch){
			_adIsFetch = false;
			return true;
		}

		return false;
	}

	public static function adFailedToFetch():Bool{

		if(_adFailedToFetch){
			_adFailedToFetch = false;
			return true;
		}

		return false;
	}

	public static function videoAdDidShow():Bool{

		if(_videoAdDidShow){
			_videoAdDidShow = false;
			return true;
		}

		return false;
	}

	public static function rewardedAdDidShow():Bool{

		if(_rewardedAdDidShow){
			_rewardedAdDidShow = false;
			return true;
		}

		return false;
	}

	public static function videoCompleted():Bool{

		if(_videoCompleted){
			_videoCompleted = false;
			return true;
		}

		return false;
	}

	public static function rewardedCompleted():Bool{

		if(_rewardedCompleted){
			_rewardedCompleted = false;
			return true;
		}

		return false;
	}

	public static function videoIsSkipped():Bool{

		if(_videoIsSkipped){
			_videoIsSkipped = false;
			return true;
		}

		return false;
	}

	public static function bannerDidClick():Bool{

		if(_bannerDidClick){
			_bannerDidClick = false;
			return true;
		}

		return false;
	}

	public static function bannerDidError():Bool{

		if(_bannerDidError){
			_bannerDidError = false;
			return true;
		}

		return false;
	}

	public static function bannerDidHide():Bool{

		if(_bannerDidHide){
			_bannerDidHide = false;
			return true;
		}

		return false;
	}

	public static function bannerDidShow():Bool{

		if(_bannerDidShow){
			_bannerDidShow = false;
			return true;
		}

		return false;
	}


	///////Events Callbacks/////////////

	#if ios
	//Ads Events only happen on iOS.
	private static function notifyListeners(inEvent:Dynamic)
	{
		var event:String = Std.string(Reflect.field(inEvent, "type"));

		if(event == "adisfetch")
		{
			trace("AD IS FETCH");
			_adIsFetch = true;
		}
		if(event == "adfailedtofetch")
		{
			trace("AD FAILED TO FETCH");
			_adFailedToFetch = true;
		}
		if(event == "videodidshow")
		{
			trace("VIDEO DID SHOW");
			_videoAdDidShow = true;
		}
		if(event == "rewardeddidshow")
		{
			trace("REWARDED DID SHOW");
			_rewardedAdDidShow = true;
		}
		if(event == "videocompleted")
		{
			trace("VIDEO COMLETED");
			_videoCompleted = true;
		}
		if(event == "rewardedcompleted")
		{
			trace("REWARDED COMPLETED");
			_rewardedCompleted = true;
		}
		if(event == "videoisskipped")
		{
			trace("VIDEO IS SKIPPED");
			_videoIsSkipped = true;
		}
		if(event == "bannerdidclick")
		{
			trace("BANNER DID CLICK");
			_bannerDidClick = true;
		}
		if(event == "bannerdiderror")
		{
			trace("BANNER DID ERROR");
			_bannerDidError = true;
		}
		if(event == "bannerdidhide")
		{
			trace("BANNER DID HIDE");
			_bannerDidHide = true;
		}
		if(event == "bannerdidshow")
		{
			trace("BANNER DID SHOW");
			_bannerDidShow = true;
		}
	}

	#end

	#if android
	private function new() {}

	public function onAdIsFetch()
	{
		_adIsFetch = true;
	}
	public function onAdFailedToFetch()
	{
		_adFailedToFetch = true;
	}
	public function onVideoDidShow()
	{
		_videoAdDidShow = true;
	}
	public function onRewardedDidShow()
	{
		_rewardedAdDidShow = true;
	}
	public function onVideoCompleted()
	{
		_videoCompleted = true;
	}
	public function onRewardedCompleted()
	{
		_rewardedCompleted = true;
	}
	public function onVideoSkipped()
	{
		_videoIsSkipped = true;
	}
	public function onBannerShow()
	{
		_bannerDidShow = true;
	}
	public function onBannerClick()
	{
		_bannerDidClick = true;
	}
	public function onBannerHide()
	{
		_bannerDidHide = true;
	}
	public function onBannerError()
	{
		_bannerDidError = true;
	}

	#end

}
