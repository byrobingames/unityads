## Stencyl Unity Advertising Extension (Openfl)

For Stencyl 3.4 9280 and above

Stencyl extension for “UnityAds” (http://unityads.unity3d.com) for iOS and Android. This extension allows you to easily integrate UnityAds on your Stencyl game / application. (http://www.stencyl.com)

### Important!!

This Extension Required the Toolset Extension Manager [https://byrobingames.github.io](https://byrobingames.github.io)

![unityadstoolset](https://byrobingames.github.io/img/unityads/unityadstoolset.png)

## Main Features

  * Video Support
  * Rewarded Video Support

## How to Install

To install this Engine Extension, go to the toolset (byRobin Extension Mananger) in the Extension menu of your game inside Stencyl.<br/>
Select the Engine Extension from the left menu and click on "Download"

If you not have byRobin Extension Mananger installed, install this first.
Go to: [https://byrobingames.github.io](https://byrobingames.github.io)

## Documentation and Block Examples

**Step 1**: If you don’t have an account, create one on [https://operate.dashboard.unity3d.com](https://operate.dashboard.unity3d.com)

**Step 2:** Create an project and add your platfom (iOS/Andoid)

**Step 3:** Open Project and get your Game id of the Platform you work with.
![unityadspoject](https://byrobingames.github.io/img/unityads/unityadspoject.png)

Fill your Game id in the Toolset Manager<br/>
![unityadsgameid](https://byrobingames.github.io/img/unityads/unityadsgameid.png)

**Step 4:** Use the initialize UniAds block in when created event of your first (loading)scene.<br/>
![initializeUnityAds](https://byrobingames.github.io/img/unityads/unityadsinitialize.png)

If your game is not live yet, enable Testads in the Toolset Manager, don’t forget to disable Testads when your uploading your game to the store.<br/>
![unityadstestmode](https://byrobingames.github.io/img/unityads/unityadstestmode.png)

**Step 5:** Open the Platform you work with (iOS or Android) and get your <strong>Integration Id</strong> of the placements your added.<br/>
In this example i use iOS platform:<br/>
The Integration Id of Ad Placement Video is <strong>video</strong><br/>
The Integration Id of Ad Placement Rewarded Video is <strong>rewardedVideo</strong>,<br/>
<span style="color:red;">make sure you have enabled the Rewarded Video. </span>

**Step 6:** Show Video with placement id (INTERGRATION ID).<br/>
Show Unityads Video with placement id block,<br/>
![unityadsshowvideo](https://byrobingames.github.io/img/unityads/unityadsshowvideo.png)

**Step 7:** Show Rewarded Video.
Show Unityads Rewarded Video with placement id block,<br/>
Create and Alert title and Message that ask the player if he wants to watch the Rewarded Video or not. If Alert title is empty no Alert box will show.<br/>
![unityadsshowrewarded](https://byrobingames.github.io/img/unityads/unityadsshowrewarded.png)

**Step 8:** Can Show Ads
Check if ads with placement id can be show , it return true when it can show and false if ads cannot be show.<br/>
![unityadscanshow](https://byrobingames.github.io/img/unityads/unityadscanshow.png)

**Step 9:** Callbacks<br/>
![unityadscallbacks](https://byrobingames.github.io/img/unityads/unityadscallbacks.png)<br/>
Use the callback blocks in an Updated event in an if statement.<br/>
– did show<br/>
– is completed<br/>
– is skipped (Video only, Rewarded cannot be skipped)

### Button Example:

Video ad:<br/>
![unityadsexamplevideobutton](https://byrobingames.github.io/img/unityads/unityadsexamplevideobutton.png)

Rewarded ad:<br/>
![unityadsexamplerewardedbutton](https://byrobingames.github.io/img/unityads/unityadsexamplerewardedbutton.png)

## Version History

- 2016-03-28 (0.0.1) First release
- 2016-04-26 (0.0.2) Single touch after dismiss Ad is now working.
- 2016-04-27 (0.0.3) Create an extra block to check if Ads are available.
- 2016-05-02 (0.0.4) Show an Alert box before showing Rewarded ad that ask if player want to watch rewarded video or not. (show Video block and show Rewarded are now 2 seperated blocks)
- 2016-05-04 (0.0.5) Added canShowad block and set Placement id block.
- 2016-10-02 (0.0.6)<br />
           - Updated iOS and Android SDK to 2.0.4<br />
           - Removed Set Placement ID block, this is not required in SDK 2.0.4<br />
           - Added placementid in Can Show Ads block.<br />
           - Verion 0.0.5 of byRobin Extension Manager is needed.<br />
- 2016-10-06 (0.0.7) – Fix: Android export/publish game
- 2016-11-18 (0.0.8) – Updated for use with Heyzap Extension 2.7
- 2017-03-19 (0.0.9) – Updated to use with Heyzap Extension 2.9, Update SDK to iOS: 2.0.8 Android: 2.0.8, Added Android Gradle support for openfl4
- 2017-05-16(0.1.0) Update SDK to iOS: 2.1.0 Android: 2.1.0, Tested for Stencyl 3.5, Required byRobin Toolset Extension Manager

## Submitting a Pull Request

This software is opensource.<br/>
If you want to contribute you can make a pull request

Repository: [https://github.com/byrobingames/unityads](https://github.com/byrobingames/unityads)

Need help with a pull request?<br/>
[https://help.github.com/articles/creating-a-pull-request/](https://help.github.com/articles/creating-a-pull-request/)

## Donate

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HKLGFCAGKBMFL)<br />

## Privacy Policy

http://unityads.unity3d.com

## License

Author: Robin Schaafsma

The MIT License (MIT)

Copyright (c) 2014 byRobinGames [http://www.byrobin.nl](http://www.byrobin.nl)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
