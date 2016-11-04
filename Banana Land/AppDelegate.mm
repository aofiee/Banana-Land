//
//  AppDelegate.mm
//  Banana Land
//
//  Created by Khomkrid Lerdprasert on 4/2/2557 BE.
//  Copyright Twin Synergy Co., Ltd. 2557. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "johnVideo.h"
@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskLandscape;
	
	// iPad only
	return UIInterfaceOrientationMaskLandscape;
}
// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
        [NSThread sleepForTimeInterval:2.0];
		[director runWithScene: [johnVideo scene]];
	}
}
@end


@implementation AppController
@synthesize musicPlayerSelected;
@synthesize postScoreStage;
@synthesize session = _session;
@synthesize window=window_, navController=navController_, director=director_;
////////////////////////////
-(void) setUp
{
    //    [[DatabaseController sharedManager] init];
	////////check session login////////
    
	NSDictionary * userDefault = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
	NSString * programReg = [userDefault objectForKey:@"bananaland_session"];
    
	if(programReg == NULL){
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:@"bananaland" forKey:@"bananaland_session"];
		[prefs setObject:@"off" forKey:@"bananaland_session_facebook_login"];
		[prefs setObject:@"" forKey:@"bananaland_session_playerSelected"];
		[prefs setObject:@"0" forKey:@"bananaland_session_score"];
		[prefs setObject:@"0" forKey:@"bananaland_session_level"];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
	////////check session login////////
}
////////////////////////////facebook login controller delegate//////////////////////////////
-(void)postScoreToFaceBook:(UIImage*)img
{
    [postScoreStage setString:[NSMutableString stringWithString:@"LOAD"]];
    if (!self.session.isOpen) {
        [self openSession];
        [self postScoreToFaceBook];
    }else{
        [self postScoreToFaceBook];
    }
    if (self.session.isOpen) {
        NSLog(@"publish_stream");
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream",@"publish_actions", nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError * error) {
             [self postScoreStateChanged:session state:state error:error image:img];
         }];
    }
}
-(void)postScoreToFaceBook
{
    //////////POST//////////
    NSDictionary * userDefault = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://test.khomkrid.com/bananaland/score.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];

    
    NSString * postString = [NSString stringWithFormat:@"USERNAME=%@&FIRSTNAME=%@&LASTNAME=%@&LOCATION_NAME=%@&GANDER=%@&EMAIL=%@&userImageURL=%@&SCORE=%d&LEVEL=%d",[userDefault objectForKey:@"username"],[userDefault objectForKey:@"firstname"],[userDefault objectForKey:@"lastname"],[userDefault objectForKey:@"location"],[userDefault objectForKey:@"gander"],[userDefault objectForKey:@"email"],[userDefault objectForKey:@"userImageURL"],m_totalScore,m_level];
    
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", [data length]] forHTTPHeaderField:@"Content-Length"];
    [NSURLConnection connectionWithRequest:request delegate:self];

    //////////POST//////////9
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [postScoreStage setString:[NSMutableString stringWithString:@"FINISH"]];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Shared Score"
                              message:@"แชร์คะแนนเรียบร้อยแล้วครับ"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    
}
- (void)postScoreStateChanged:(FBSession *)session
                        state:(FBSessionState) state
                        error:(NSError *)error image:(UIImage*)img
{
    switch (state) {
        case FBSessionStateOpen: {
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            connection.errorBehavior = (FBRequestConnectionErrorBehavior)(FBRequestConnectionErrorBehaviorReconnectSession|FBRequestConnectionErrorBehaviorAlertUser|FBRequestConnectionErrorBehaviorRetry);
            
            [connection addRequest:[FBRequest requestForUploadPhoto:img]
                 completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                     if (error) {
                         NSLog(@"%@",error);
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"Error"
                                                   message:error.localizedDescription
                                                   delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
                         [alertView show];
                     }else{
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"Complete"
                                                   message:@"บันทึกคะแนนเรียบร้อยแล้วครับ"
                                                   delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
                         [alertView show];
                     }
                     
                 }];
            
            
            [connection start];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(NSMutableString*)getPostScoreStage
{
    return postScoreStage;
}
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    self.session = session;
    
    switch (state) {
        case FBSessionStateOpen: {
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            connection.errorBehavior = (FBRequestConnectionErrorBehavior)(FBRequestConnectionErrorBehaviorReconnectSession|FBRequestConnectionErrorBehaviorAlertUser|FBRequestConnectionErrorBehaviorRetry);

            
            [connection addRequest:[FBRequest requestForMe]
                 completionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                 if (!error) {

                     NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                     [prefs setObject:user.username forKey:@"username"];
                     [prefs setObject:user.id forKey:@"userid"];
                     [prefs setObject:user.first_name forKey:@"firstname"];
                     [prefs setObject:user.last_name forKey:@"lastname"];
                     [prefs setObject:[user objectForKey:@"gender"] forKey:@"gander"];
                     [prefs setObject:[user objectForKey:@"email"] forKey:@"email"];
                     [prefs setObject:user.location[@"name"] forKey:@"location"];
                     [prefs setObject:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", user.username] forKey:@"userImageURL"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
             }
             ];
            [connection start];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        NSLog(@"%@",error);
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)openSession
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"basic_info",@"public_profile",@"email",@"user_friends", nil];

    if (!self.session.isOpen) {
        self.session = [[FBSession alloc] initWithPermissions:permissions];
        NSLog(@"self.session.state %u",self.session.state);
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:
             ^(FBSession *session,
               FBSessionState state, NSError * error) {
                 [self sessionStateChanged:session state:state error:error];
             }];
            
        }];
    }
}
-(void)setScore:(int)score andLevel:(int)level
{
    m_totalScore = score;
    m_level = level;
}
-(int)getLevel
{
    return m_level;
}
-(int)getScore
{
    return m_totalScore;
}
////////////////////////////facebook login controller delegate//////////////////////////////
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
//    return [FBSession.activeSession handleOpenURL:url];
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}
///////////////////////////
-(void)setmusicPlayerSelected:(NSMutableString*)str
{
    musicPlayerSelected = str;
}
-(NSMutableString*)getmusicPlayerSelected
{
    return musicPlayerSelected;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
    [self setUp];
    postScoreStage = [[NSMutableString alloc] initWithString:@"FINISH"];
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	
	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	// Enable multiple touches
	[glView setMultipleTouchEnabled:YES];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
	return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.session close];
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
	
	[super dealloc];
}
@end

