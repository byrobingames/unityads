/*
 *
 * Created by Robin Schaafsma
 * https://byrobingames.github.io
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

import android.view.Gravity;
import android.view.animation.Animation;
import android.view.animation.AlphaAnimation;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.view.ViewGroup;


import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.ads.UnityAds;
import com.unity3d.services.core.log.DeviceLog;
import com.unity3d.ads.metadata.MediationMetaData;
import com.unity3d.ads.metadata.MetaData;
import com.unity3d.ads.metadata.PlayerMetaData;
import com.unity3d.services.core.misc.Utilities;
import com.unity3d.services.core.properties.SdkProperties;
import com.unity3d.services.core.webview.WebView;

import com.unity3d.services.banners.IUnityBannerListener;
import com.unity3d.services.banners.UnityBanners;

public class UnityAdsEx extends Extension implements IUnityAdsListener, IUnityBannerListener {

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////
    private static UnityAdsEx _self = null;
    protected static HaxeObject unityadsCallback;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private View bannerView;
    private LinearLayout layout;

    private static String appId=null;
    
    protected  static boolean showedVideo=false;
    protected  static boolean showedRewarded=false;
    private  static boolean bannerLoaded=false;
    private static int gravity=Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////

    static public void init(HaxeObject cb, final String appId,final boolean testMode,final boolean debugMode){
        
        unityadsCallback = cb;
        UnityAdsEx.appId= appId;
        
		Extension.mainActivity.runOnUiThread(new Runnable() {
                        public void run()
			{
                            Log.d("UnityAdsEx","Init UnityAds appId:" + appId);
                            UnityAds.setDebugMode(debugMode);
                            UnityAds.initialize(mainActivity, appId, _self, testMode);
			}
		});	
	}

    static public void showVideo(final String videoPlacementId)
    {
        showedVideo = true;
        showedRewarded = false;
        
        Log.d("UnityAdsEx","Show Video Begin");
                if(appId=="") return;
		Extension.mainActivity.runOnUiThread(new Runnable() {
                    public void run()
                        {
                            UnityAds.show(mainActivity, videoPlacementId);
                        }
                });
		Log.d("UnityAdsEx","Show Video End ");
	}
    
    static public void showRewarded(final String rewardPlacementId, final String title, final String msg)
    {
        showedVideo = false;
        showedRewarded = true;
        
        Log.d("UnityAdsEx","Show Rewarded Begin");
        if(appId=="") return;
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
                            UnityAds.show(mainActivity, rewardPlacementId);
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
                   UnityAds.show(mainActivity, rewardPlacementId);
                }
            }
        });
        Log.d("UnityAdsEx","Show Rewarded End ");
    }
    
    public static boolean canShowUnityAds(final String placementId){
        
            return UnityAds.isReady(placementId);

    }
    
    public static boolean isSupportedUnityAds(){
        
        return UnityAds.isSupported();
    }

    static public void showBanner(final String bannerPlacementId){

        Extension.mainActivity.runOnUiThread(new Runnable() {
                public void run() {

                    if(bannerLoaded){

                        _self.bannerView.setVisibility(View.VISIBLE);

                        Animation animation1 = new AlphaAnimation(0.0f, 1.0f);
                        animation1.setDuration(1000);
                        _self.layout.startAnimation(animation1);

                        unityadsCallback.call("onBannerShow", new Object[] {});

                     }else{
                        UnityBanners.setBannerListener (_self);
                        UnityBanners.loadBanner (mainActivity, bannerPlacementId);

                     }
                }
        });

    }

    static public void hideBanner(){

        if(bannerLoaded){

            Extension.mainActivity.runOnUiThread(new Runnable() {
                    public void run() {
                        Animation animation1 = new AlphaAnimation(1.0f, 0.0f);
                        animation1.setDuration(1000);
                        _self.layout.startAnimation(animation1);

                        final Handler handler = new Handler();
                        handler.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                _self.bannerView.setVisibility(View.GONE);

                                unityadsCallback.call("onBannerHide", new Object[] {});
                            }
                        }, 1000);


                    }
            });
        }

    }

    static public void destroyBanner(){

        Extension.mainActivity.runOnUiThread(new Runnable() {
                public void run() {

                    UnityBanners.destroy ();

                }
        });
    }

    static public void moveBanner(final String position){

        Extension.mainActivity.runOnUiThread(new Runnable(){
                public void run(){
                    if(position.equals("TOP"))
                    {
                        if(_self.bannerView==null)
                        {
                                UnityAdsEx.gravity=Gravity.TOP | Gravity.CENTER_HORIZONTAL;
                        }else{
                                UnityAdsEx.gravity=Gravity.TOP | Gravity.CENTER_HORIZONTAL;
                                _self.layout.setGravity(gravity);
                        }
                    }else{

                        if(_self.bannerView ==null)
                        {
                            UnityAdsEx.gravity=Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
                        }else{
                            UnityAdsEx.gravity=Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
                            _self.layout.setGravity(gravity);
                        }
                    }
                }
        });

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
    //public void onAdStarted(String zoneId) {
        
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
///banner listener
    @Override
    public void onUnityBannerLoaded (String placementId, View view) {
        _self.bannerView = view;
        _self.layout = new LinearLayout(mainActivity);
        _self.layout.setGravity(Gravity.BOTTOM);

        mainActivity.addContentView(_self.layout, new LayoutParams(LayoutParams.FILL_PARENT,LayoutParams.FILL_PARENT));
        _self.layout.addView(_self.bannerView);
        _self.layout.bringToFront();

        moveBanner("BOTTOM");
        _self.bannerView.setVisibility(View.VISIBLE);

        UnityAdsEx.bannerLoaded = true;

        }

    @Override
    public void onUnityBannerUnloaded (String placementId) {
        UnityAdsEx.bannerLoaded = false;
        _self.bannerView.setVisibility(View.GONE);
        _self.bannerView = null;

    }

    @Override
    public void onUnityBannerShow (String placementId) {

        unityadsCallback.call("onBannerShow", new Object[] {});
    }

    @Override
    public void onUnityBannerClick (String placementId) {
        unityadsCallback.call("onBannerClick", new Object[] {});
    }

    @Override
    public void onUnityBannerHide (String placementId) {
        unityadsCallback.call("onBannerHide", new Object[] {});
    }

    @Override
    public void onUnityBannerError (String message) {
        UnityAdsEx.bannerLoaded = false;
        unityadsCallback.call("onBannerError", new Object[] {});
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
