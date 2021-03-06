//
//  TransactionDetailNavigationController.m
//  Blockchain
//
//  Created by Kevin Wu on 9/2/16.
//  Copyright © 2016 Blockchain Luxembourg S.A. All rights reserved.
//

#import "TransactionDetailNavigationController.h"
#import "TransactionRecipientsViewController.h"
#import "Blockchain-Swift.h"

@implementation TransactionDetailNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat safeAreaInsetTop;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetTop = window.rootViewController.view.safeAreaInsets.top;
    } else {
        safeAreaInsetTop = 20;
    }

    CGFloat topBarHeight = ConstantsObjcBridge.defaultNavigationBarHeight + safeAreaInsetTop;
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, topBarHeight)];
    topBar.backgroundColor = UIColor.brandPrimary;
    [self.view addSubview:topBar];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, safeAreaInsetTop + 6, 200, 30)];
    self.headerLabel.font = [UIFont fontWithName:FONT_MONTSERRAT_REGULAR size:FONT_SIZE_TOP_BAR_TEXT];
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.adjustsFontSizeToFitWidth = YES;
    self.headerLabel.text = BC_STRING_TRANSACTION;
    self.headerLabel.center = CGPointMake(topBar.center.x, self.headerLabel.center.y);
    [topBar addSubview:self.headerLabel];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(self.view.frame.size.width - 80, 15, 80, 51);
    self.closeButton.imageEdgeInsets = IMAGE_EDGE_INSETS_CLOSE_BUTTON_X;
    self.closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    self.closeButton.center = CGPointMake(self.closeButton.center.x, self.headerLabel.center.y);
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:self.closeButton];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.backButton.frame = FRAME_BACK_BUTTON;
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backButton setTitle:@"" forState:UIControlStateNormal];
    [topBar addSubview:self.backButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.viewControllers.count > 1) {
        [self.backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.backButton setImage:[UIImage imageNamed:@"back_chevron_icon"] forState:UIControlStateNormal];
        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        [self.backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.hidden = YES;
    } else {
        [self.backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.backButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        self.backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        [self.backButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.hidden = NO;
    }
    self.backButton.center = CGPointMake(self.backButton.center.x, self.headerLabel.center.y);
    
    if ([self.visibleViewController isMemberOfClass:[TransactionRecipientsViewController class]]) {
        self.headerLabel.text = BC_STRING_RECIPIENTS;
    } else {
        self.headerLabel.text = BC_STRING_TRANSACTION;
    }
}

- (void)popViewController
{
    if (self.viewControllers.count > 1) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismiss];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onDismiss) self.onDismiss();
    }];
}

#pragma mark - Actions

- (void)share
{
    TabControllerManager *tabControllerManager = [AppCoordinator sharedInstance].tabControllerManager;
    [self reportShareWithAsset:tabControllerManager.assetType];
    
    AssetType assetType = [AssetTypeLegacyHelper convertFromLegacy:tabControllerManager.assetType];

    NSString *txDetailString = [BlockchainAPI.sharedInstance transactionDetailURLFor:self.transactionHash assetType:assetType];
    NSURL *url = [NSURL URLWithString:txDetailString];

    NSArray *activityItems = @[self, url];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToFacebook];
    
    [activityViewController setValue:BC_STRING_TRANSACTION_DETAILS forKey:@"subject"];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
