//
//  TDTCollectionViewController.m
//  todot
//
//  Created by Rodrigo K on 2/22/14.
//  Copyright (c) 2014 Rodrigo Krummenauer. All rights reserved.
//

#import "TDTCollectionViewController.h"

@interface TDTCollectionViewController () {
    CGPoint originalPosition;
    UIColor *originalColor;
}

@end

@implementation TDTCollectionViewController

static NSString * CellIdentifier = @"cellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *) [otherCell viewWithTag:100];
    

    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveObject:)];
    pan.minimumNumberOfTouches = 1;
    [label addGestureRecognizer:pan];
    
    return otherCell;
}

-(void)moveObject:(UIPanGestureRecognizer *)pan;
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        originalPosition = pan.view.center;
        originalColor = [((UILabel *)pan.view) textColor];
    }
    
    UIColor *newColor = originalColor;
    
    CGPoint location = [pan locationInView:pan.view.superview];
    
    UILabel *label = (UILabel *) [pan.view.superview viewWithTag:200];

    CGFloat alpha = 1 - (location.x - originalPosition.x) / 50;
    if (alpha > 1) {
        alpha = 1;
    } else if (alpha < 0) {
        alpha = 0;
    }

    label.alpha = alpha;
    
    UILabel *dot1 = (UILabel *) [pan.view.superview viewWithTag:300];
    UILabel *dot2 = (UILabel *) [pan.view.superview viewWithTag:400];
    UILabel *dot3 = (UILabel *) [pan.view.superview viewWithTag:500];
    UILabel *dot4 = (UILabel *) [pan.view.superview viewWithTag:600];
    UILabel *dot5 = (UILabel *) [pan.view.superview viewWithTag:700];
    
    alpha = (location.x - originalPosition.x) / 100;
    if (alpha > 1) {
        alpha = 1;
    } else if (alpha < 0) {
        alpha = 0;
    }
                              
    dot1.alpha = alpha;
    dot2.alpha = alpha;
    dot3.alpha = alpha;
    dot4.alpha = alpha;
    dot5.alpha = alpha;

    
    NSArray *dots = @[dot1, dot2, dot3, dot4, dot5];
    
    for (int i = 0; i < dots.count; i++) {
        UILabel *dot = [dots objectAtIndex:i];
        if (location.x > dot.center.x - 22 && location.x < dot.center.x + 22) {
            location.x = dot.center.x;
            newColor = dot.textColor;
            break;
        }
    }

    location.y = pan.view.center.y;

    
    if (ABS(pan.view.center.x - location.x) > 21) {
        [UIView animateWithDuration: 0.3
                         animations: ^ {
                             pan.view.center = location;
                         }
                         completion: ^(BOOL finished) {
                             if (finished == YES) {
                                 ((UILabel *)pan.view).textColor = newColor;
                             }
                         }];

    } else {
        pan.view.center = location;
//        ((UILabel *)pan.view).textColor = newColor;
    }

    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration: 0.2
                              delay: 0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations: ^ {
                             pan.view.center = originalPosition;
//                             ((UILabel *)pan.view).textColor = originalColor;
                             label.textColor = ((UILabel *)pan.view).textColor;
                         }
                         completion: ^(BOOL finished) {

                         }];
    
        [UIView animateWithDuration: 0.2
                         animations: ^ {
                             label.alpha = 1;
                             dot1.alpha = 0;
                             dot2.alpha = 0;
                             dot3.alpha = 0;
                             dot4.alpha = 0;
                             dot5.alpha = 0;
                         }
                         completion: ^(BOOL finished) {
                             
                         }];
    }
}


@end
