package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import openfl.Lib;
#end

#if android
import openfl.utils.JNI;
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
			
			__init(appId,testMode, debugMode);
			__unityads_set_event_handle(notifyListeners);
		}catch(e:Dynamic){
			trace("iOS INIT Exception: "+e);
		}
		#end
		
		#if android
		if(initialized) return;
		initialized = true;
		try{
			// JNI METHOD LINKING
			__showVideo = openfl.utils.JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "showVideo", "(Ljava/lang/String;)V");
			__showRewarded = openfl.utils.JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "showRewarded", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
			__canShowAds = openfl.utils.JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "canShowUnityAds", "(Ljava/lang/String;)Z");
			__isSupported = openfl.utils.JNI.createStaticMethod("com/byrobin/unityads/UnityAdsEx", "isSupportedUnityAds", "()Z");
			
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
	#end

}
