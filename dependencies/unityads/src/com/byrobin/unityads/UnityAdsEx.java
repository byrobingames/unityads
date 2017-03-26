/*
 *
 * Created by Robin Schaafsma
 * www.byrobingames.com
 * copyright
 */

package com.byrobin.unityads;


import android.app.Activity;
import android.app.*;
import android.content.*;
import android.content.Context;
import android.os.*;
import android.util.Log;
import android.content.ActivityNotFoundException;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

import com.unity3d.ads.UnityAds;
import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.ads.log.DeviceLog;
import com.unity3d.ads.metadata.MediationMetaData;
import com.unity3d.ads.metadata.MetaData;
import com.unity3d.ads.metadata.PlayerMetaData;
import com.unity3d.ads.misc.Utilities;
import com.unity3d.ads.properties.SdkProperties;

public class UnityAdsEx extends Extension implements IUnityAdsListener {


	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////
    private static UnityAdsEx _self = null;
    protected static HaxeObject unityadsCallback;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static String appId=null;
    
    protected  static boolean showedVideo=false;
    protected  static boolean showedRewarded=false;

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////

	static public void init(HaxeObject cb, final String appId,final boolean testMode,final boolean debugMode){
        
        unityadsCallback = cb;
        UnityAdsEx.appId= appId;
        
		Extension.mainActivity.runOnUiThread(new Runnable() {
            public void run() 
			{
                Log.d("UnityAdsEx","Init UnityAds appId:" + appId);
                UnityAds.setListener(_self);
                UnityAds.setDebugMode(debugMode);
            
                UnityAds.initialize(Extension.mainActivity, appId, _self, testMode);
			}
		});	
	}

	static public void showVideo(final String videoPlacementId)
    {
        showedVideo = true;
        showedRewarded = false;
        
        Log.d("UnityAdsEx","Show Video Begin");
		if(appId=="") return;
        if(UnityAds.isReady(videoPlacementId)){
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run()
            {
                UnityAds.show(Extension.mainActivity, videoPlacementId);
            }
		});
        }
		Log.d("UnityAdsEx","Show Video End ");
	}
    
    static public void showRewarded(final String rewardPlacementId, final String title, final String msg)
    {
        showedVideo = false;
        showedRewarded = true;
        
        Log.d("UnityAdsEx","Show Rewarded Begin");
        if(appId=="") return;
        if(UnityAds.isReady(rewardPlacementId)){
        Extension.mainActivity.runOnUiThread(new Runnable() {
            public void run()
            {
                if(title.length() > 0)
                {
                    Dialog dialog = new AlertDialog.Builder(mainActivity).setTitle(title).setMessage(msg).  setPositiveButton
                    (
                    "Watch",
                    new DialogInterface.OnClickListener()
                    {
                        public void onClick(DialogInterface dialog, int whichButton)
                        {
                            UnityAds.show(Extension.mainActivity, rewardPlacementId);
                        }
                    }
                    ).setNegativeButton
                    (
                    "Discard",
                    new DialogInterface.OnClickListener()
                    {
                        public void onClick(DialogInterface dialog, int whichButton)
                        {
                            //Do nothing go back to mainActivity
                        }
                    }
                    ).create();
                
                    dialog.show();
                }else{
                   UnityAds.show(Extension.mainActivity, rewardPlacementId);
                }
            }
        });
        }
        Log.d("UnityAdsEx","Show Rewarded End ");
    }
    
    public static boolean canShowUnityAds(final String placementId){
        
            return UnityAds.isReady(placementId);
    }
    
    public static boolean isSupportedUnityAds(){
        
        return UnityAds.isSupported();
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    @Override
    public void onUnityAdsReady(final String zoneId) {
        
        Log.d("UnityAdsEx","Fetch Completed ");
        unityadsCallback.call("onAdIsFetch", new Object[] {});
    }
    
    @Override
    public void onUnityAdsError(UnityAds.UnityAdsError error, String message) {
        Log.d("UnityAdsEx","Fetch Failed ");
        unityadsCallback.call("onAdFailedToFetch", new Object[] {});
    }
    
    @Override
    public void onUnityAdsStart(String zoneId) {
        
        if (showedVideo) {
            unityadsCallback.call("onVideoDidShow", new Object[] {});
        }else if (showedRewarded){
            unityadsCallback.call("onRewardedDidShow", new Object[] {});
        }
    }
    
    @Override
    public void onUnityAdsFinish(String zoneId, UnityAds.FinishState result) {
        
        switch(result){
            case ERROR:
                break;
            case SKIPPED:
                unityadsCallback.call("onVideoSkipped", new Object[] {});
                break;
            case COMPLETED:
                if (showedVideo) {
                    unityadsCallback.call("onVideoCompleted", new Object[] {});
                }else if (showedRewarded){
                    unityadsCallback.call("onRewardedCompleted", new Object[] {});
                }
                break;
        }
        
    }

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////

    public void onCreate ( Bundle savedInstanceState )
    {
        super.onCreate(savedInstanceState);
        _self = this;
    }
    
    public void onResume () {
        super.onResume();
        
    }

}
