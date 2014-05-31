//
//  CFExplanationViewController.m
//  CO2 Footprint
//
//  Created by Lee Danilek on 5/28/14.
//  Copyright (c) 2014 Ship Shape. All rights reserved.
//

#import "CFExplanationViewController.h"

@interface CFExplanationViewController () <UIWebViewDelegate>

@end

@implementation CFExplanationViewController

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webview.hidden=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error;
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Explanation" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    [self.webview loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loading Error" message:[NSString stringWithFormat:@"Error: %@", error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        self.webview.hidden=YES;
        self.webview.delegate=self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
