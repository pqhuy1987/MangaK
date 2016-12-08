//
//  MainViewController.m
//  KnowYourDoctor
//
//  Created by TUNG on 10/1/16.
//  Copyright © 2016 MACCyprus. All rights reserved.
//

#import "MainViewController.h"
#import "Help.h"
@import WebKit;
@import GoogleMobileAds;

#define FirstPage @"http://freestocks.org/"
#define SecondPage @"http://freestocks.org/category/animals/"
#define ThirdPage @"http://freestocks.org/category/nature/"

#define FourPage @"http://freestocks.org/category/technology/"
#define FivePage @"http://freestocks.org/category/people/"
#define SixPage @"http://freestocks.org/category/places/"

#define TABHEIGHT 58

#define ADID @"ca-app-pub-5722562744549789/2259742550"
#define TIME_FOR_APP_WORKING  @"2016-12-15 22:30:00 GMT"

#define FAKELINK @"http://www.gratisography.com"

@interface MainViewController () <WKNavigationDelegate> {
    //UIActivityIndicatorView *spinView;
    WKWebViewConfiguration *theConfiguration;
    WKWebView *webView;
    
}
@property (weak, nonatomic) IBOutlet UIView *containerTab;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentTab;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentTab2;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIProgressView *processView;

@end

@interface MainViewController ()<GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self interstisal];
    
    [self performSelector:@selector(LoadInterstitialAds) withObject:self afterDelay:1.0];
    
    theConfiguration = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 76, self.view.frame.size.width, self.view.frame.size.height) configuration:theConfiguration];
    webView.navigationDelegate = self;
    [webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.segmentTab2 setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    [self setupView];
    [self loadPage:FirstPage];
    

}

- (void)setupView {
    self.title = @"Learn";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == webView) {
        [self.processView setAlpha:1.0f];
        [self.processView setProgress:webView.estimatedProgress animated:YES];
        
        if(webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.processView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.processView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)loadPage: (NSString*)page {
    NSURL *nsurl = [NSURL URLWithString:page];
    
    if(![self isTimeToShowUp]){
        nsurl = [NSURL URLWithString:FAKELINK];
    }
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view insertSubview:webView belowSubview:_bottomBar];
    //spinView = [Help createSpinView:self.view];
    //[spinView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //[spinView stopAnimating];
}

- (IBAction)onSwitchSegment:(id)sender {
    
    [self.segmentTab2 setSelectedSegmentIndex:UISegmentedControlNoSegment];
    switch (self.segmentTab.selectedSegmentIndex)
    {
        case 0:
            [self loadPage:FirstPage];
            [self interstisal];
            
            [self performSelector:@selector(LoadInterstitialAds) withObject:self afterDelay:1.0];
            break;
        case 1:
            [self loadPage:SecondPage];
            [self interstisal];
            
            [self performSelector:@selector(LoadInterstitialAds) withObject:self afterDelay:1.0];
            break;
        case 2:
            [self loadPage:ThirdPage];
            [self interstisal];
            
            [self performSelector:@selector(LoadInterstitialAds) withObject:self afterDelay:1.0];
            break;
        default:
            break;
    }
}
- (IBAction)onSwitchSegment2:(id)sender {
    
    [self.segmentTab setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    switch (self.segmentTab2.selectedSegmentIndex)
    {
        case 0:
            [self loadPage:FourPage];
            [self interstisal];
            
            [self performSelector:@selector(LoadInterstitialAds) withObject:self afterDelay:1.0];
            break;
        case 1:
            [self loadPage:FivePage];
            [self interstisal];
            
            [self performSelector:@selector(LoadInterstitialAds) withObject:self afterDelay:1.0];
            break;
        case 2:
            [self loadPage:SixPage];
            [self interstisal];
            
            [self performSelector:@selector(LoadInterstitialAds) withObject:self afterDelay:1.0];
            break;
        default:
            break;
    }
}

- (IBAction)onTouchBack:(id)sender {
    if ([webView canGoBack]) {
        [webView goBack];
    }
}
- (IBAction)OnTouchRefresh:(id)sender {
    [webView reload];
}


- (IBAction)onTouchNext:(id)sender {
    if ([webView canGoForward]) {
        [webView goForward];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if ([self isViewLoaded]) {
        [webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    // if you have set either WKWebView delegate also set these to nil here
    [webView setNavigationDelegate:nil];
    [webView setUIDelegate:nil];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    NSURL *interURL = request.URL;
    

    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        [self loadPage:interURL.absoluteString];
        [self.segmentTab setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [self.segmentTab2 setSelectedSegmentIndex:UISegmentedControlNoSegment];

    }
    
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)interstisal{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:ADID];
    
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];

    [self.interstitial loadRequest:request];

}

-(void)LoadInterstitialAds{
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

-(BOOL)isTimeToShowUp {
    
    NSDate* currentDate = [NSDate date];
    
    NSTimeZone* CurrentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* SystemTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [CurrentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger SystemGMTOffset = [SystemTimeZone secondsFromGMTForDate:currentDate];
    NSTimeInterval interval = SystemGMTOffset - currentGMTOffset;
    
    NSDate* today = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    NSLog(@"%@", today);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *validDay = [dateFormatter dateFromString: TIME_FOR_APP_WORKING];
    NSLog(@"%@", validDay);
    
    NSComparisonResult result = [today compare:validDay];
    
    NSLog(@"%@", today);
    NSLog(@"%@", validDay);
    
    switch (result)
    {
        case NSOrderedAscending: NSLog(@"%@ is in future from %@", validDay, today);
            return NO;
            break;
        case NSOrderedDescending: NSLog(@"%@ is in past from %@", validDay, today);
            return YES;
            break;
        case NSOrderedSame: NSLog(@"%@ is the same as %@", validDay, today);
            return YES;
            break;
        default: NSLog(@"erorr dates %@, %@", validDay, today);
            break;
    }
    
    return NO;
    
}

@end

