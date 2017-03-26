/*
 *
 * Created by Robin Schaafsma
 * www.byrobingames.com
 *
 */
#include <hx/CFFI.h>
#include <UnityAdsEx.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UnityAds/UnityAds.h>

using namespace unityads;

extern "C" void sendUnityAdsEvent(char* event);

@interface UnityAdsController : NSObject <UnityAdsDelegate>
{
    UIViewController *viewController;
    BOOL showedVideo;
    BOOL showedRewarded;
}

- (id)initWithID:(NSString*)appID testModeOn:(BOOL)testMode debugModeOn:(BOOL)debugMode;
- (void)showVideoAdWithPlacementID:(NSString*)videoPlacementId;
- (void)showRewardedAdWithPlacementID:(NSString*)videoPlacementId andTitle:(NSString*)title withMsg:(NSString*)msg;
- (BOOL)canShowUnityAds:(NSString*)placementId;
- (BOOL)isSupportedUnityAds;

@property (nonatomic, assign) BOOL showedVideo;
@property (nonatomic, assign) BOOL showedRewarded;

@end

@implementation UnityAdsController

@synthesize showedVideo;
@synthesize showedRewarded;

- (id)initWithID:(NSString*)ID testModeOn:(BOOL)testMode debugModeOn:(BOOL)debugMode
{
    self = [super init];
    NSLog(@"UnityAds Init");
    if(!self) return nil;
    
    [UnityAds setDebugMode:debugMode];
    
    [UnityAds initialize:ID delegate:self testMode:testMode];
    
    return self;
}


- (void)showVideoAdWithPlacementID:(NSString*)videoPlacementId
{
    showedVideo = YES;
    showedRewarded = NO;
    
    if ([UnityAds isReady:videoPlacementId]) {
            
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        viewController = [[UIViewController alloc] init];
        [window addSubview: viewController.view];
        //[window.rootViewController presentViewController:viewController animated:YES completion:^(void)
        //{
         //   [UnityAds show:viewController placementId:videoPlacementId];
        //}];
        [UnityAds show:viewController placementId:videoPlacementId];
        
    }
    
        
}


- (void)showRewardedAdWithPlacementID:(NSString*)rewardPlacementId andTitle:(NSString*)title withMsg:(NSString*)msg
{
    showedVideo = NO;
    showedRewarded = YES;
    
    if ([UnityAds isReady:rewardPlacementId])
    {
    
        if ([title length] >0)
        {
            UIAlertController* alert=   [UIAlertController
                                          alertControllerWithTitle:title
                                          message:msg
                                          preferredStyle:UIAlertControllerStyleAlert];
        
            UIAlertAction* discard = [UIAlertAction
                                      actionWithTitle:@"Discard"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                          //nothing to do..
                                      }];
        
            UIAlertAction* view =   [UIAlertAction
                                     actionWithTitle:@"Watch"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                                         NSLog(@"UnityAds show start ");
                                         UIWindow* window = [UIApplication sharedApplication].keyWindow;
                                         viewController = [[UIViewController alloc] init];
                                         [window addSubview: viewController.view];
                                         //[window.rootViewController presentViewController:viewController animated:YES completion:^(void)
                                          //{
                                          //    [UnityAds show:viewController placementId:rewardPlacementId];
                                          //}];
                                         [UnityAds show:viewController placementId:rewardPlacementId];
                                     }];
        
            [alert addAction:discard];
            [alert addAction:view];
        
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
        }else{
        
            NSLog(@"UnityAds show start ");
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            viewController = [[UIViewController alloc] init];
            [window addSubview: viewController.view];
            //[window.rootViewController presentViewController:viewController animated:YES completion:^(void)
            //{
            //    [UnityAds show:viewController placementId:rewardPlacementId];
            //}];
            [UnityAds show:viewController placementId:rewardPlacementId];
        }
    }
}

- (BOOL)canShowUnityAds:(NSString*)placementId
{
    return [UnityAds isReady];
}

- (BOOL)isSupportedUnityAds
{
    return [UnityAds isSupported];
}


#pragma mark - UnityAdsSDK Delegate

- (void)unityAdsReady:(NSString *)placementId {
    NSLog(@"unityAdsReady");
    sendUnityAdsEvent("adisfetch");
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message {
    NSLog(@"UnityAds ERROR: %ld - %@",(long)error, message);
    sendUnityAdsEvent("adfailedtofetch");
}

- (void)unityAdsDidStart:(NSString *)placementId {
    NSLog(@"unityAdsDidShow");
    if (showedVideo) {
        sendUnityAdsEvent("videodidshow");
    }else if (showedRewarded){
        sendUnityAdsEvent("rewardeddidshow");
    }
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    
    [viewController dismissViewControllerAnimated:YES completion:^(void)
     {
         UIWindow *window = [UIApplication sharedApplication].keyWindow;
         [viewController.view removeFromSuperview];
         [window makeKeyAndVisible];
     }];
    
    NSLog(@"unityAdsDidHide");
    /*if (showedVideo) {
        sendUnityAdsEvent("videoclosed");
    }else if (showedRewarded){
        sendUnityAdsEvent("rewardedclosed");
    }*/
    
    switch (state) {
        case kUnityAdsFinishStateError:
            //stateString = @"ERROR";
            break;
        case kUnityAdsFinishStateSkipped:
            //stateString = @"SKIPPED";
            sendUnityAdsEvent("videoisskipped");
            break;
        case kUnityAdsFinishStateCompleted:
            //stateString = @"COMPLETED";
            if (showedVideo) {
                sendUnityAdsEvent("videocompleted");
            }else if (showedRewarded){
                sendUnityAdsEvent("rewardedcompleted");
            }
            break;
        default:
            break;
    }
}

@end

namespace unityads {
	
	static UnityAdsController *unityAdsController;
    
	void init(const char *__appID, bool testMode, bool debugMode){
        
        if(unityAdsController == NULL)
        {
            unityAdsController = [[UnityAdsController alloc] init];
        }
        
        NSString *appID = [NSString stringWithUTF8String:__appID];

        [unityAdsController initWithID:appID testModeOn:(BOOL)testMode debugModeOn:(BOOL)debugMode];
    }
    
    void showVideo(const char *__videoPlacementId)
    {
        NSString *videoPlacementId = [NSString stringWithUTF8String:__videoPlacementId];
        
        if(unityAdsController != NULL) [unityAdsController showVideoAdWithPlacementID:videoPlacementId];
    }
    
    void showRewarded(const char *__rewardPlacementId,const char *__title,const char *__msg)
    {
        NSString *rewardPlacementId = [NSString stringWithUTF8String:__rewardPlacementId];
        NSString *title = [NSString stringWithUTF8String:__title];
        NSString *msg = [NSString stringWithUTF8String:__msg];
        
        if(unityAdsController != NULL) [unityAdsController showRewardedAdWithPlacementID:rewardPlacementId andTitle:title withMsg:msg];
    }
    
    bool unityCanShow(const char *__placementId)
    {
         NSString *placementId = [NSString stringWithUTF8String:__placementId];
        
        if(unityAdsController == NULL) return false;
        
        return [unityAdsController canShowUnityAds:placementId];
    }
    
    bool unityIsSupported()
    {
        if(unityAdsController == NULL) return false;
        
        return [unityAdsController isSupportedUnityAds];
    }
}
