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

#define FirstPage @"https://www.mangak.info"
#define SecondPage @"https://www.mangak.info/hot/"
#define ThirdPage @"https://www.mangak.info/full/"

#define TABHEIGHT 58

@interface MainViewController () <WKNavigationDelegate> {
    //UIActivityIndicatorView *spinView;
    WKWebViewConfiguration *theConfiguration;
    WKWebView *webView;
    
}
@property (weak, nonatomic) IBOutlet UIView *containerTab;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentTab;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIProgressView *processView;

@end

@interface MainViewController ()<GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    theConfiguration = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 58, self.view.frame.size.width, self.view.frame.size.height) configuration:theConfiguration];
    webView.navigationDelegate = self;
    [webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    [self setupView];
    [self loadPage:FirstPage];
    
    [self startNewGame];
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
    
    switch (self.segmentTab.selectedSegmentIndex)
    {
        case 0:
            [self loadPage:FirstPage];
            [self startNewGame];
            break;
        case 1:
            [self loadPage:SecondPage];
            [self startNewGame];
            break;
        case 2:
            [self loadPage:ThirdPage];
            [self startNewGame];
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
    }
    
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)createAndLoadInterstitial{
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[ kGADSimulatorID, @"bb3f849f9804eae0523d878052a26a41" ];
    [self.interstitial loadRequest:request];

}

-(void)startNewGame{
    
    [self createAndLoadInterstitial];
}
@end

