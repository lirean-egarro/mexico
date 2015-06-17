//
//  UISegmentedControl+Resize.m
//  jajko
//
//  Created by Esteban Garro on 2015-06-16.
//  Copyright (c) 2015 transcriptics. All rights reserved.
//

#import "UISegmentedControl+Resize.h"

@implementation UISegmentedControl (UISegmentedControl_Resize)

-(void)resizeSegmentsToFitTitles {
    CGFloat textWidth = 0; // total width of all text labels
    CGFloat marginWidth = 0; // total width of all margins
    NSUInteger nSegments = self.subviews.count;
    
    //Use one segment to find the font
    UIView *aSegment = [self.subviews objectAtIndex:0];
    UIFont *theFont = nil;
    for (UILabel *label in aSegment.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            theFont = label.font;
            break;
        }
    }
    
    // calculate width of text in each segment
    NSDictionary *attributes = @{NSFontAttributeName : theFont};
    
    for (NSUInteger i = 0; i < nSegments; i++) {
        NSString *title = [self titleForSegmentAtIndex:i];
        CGFloat width = [title sizeWithAttributes:attributes].width;
        CGFloat margin = 15;
        
        if (width > 200) {
            NSString *ellipsis = @"…";
            CGFloat width2 = [ellipsis sizeWithAttributes:attributes].width;
            
            while (width > 200-width2) {
                title = [title substringToIndex:title.length-1];
                width = [title sizeWithAttributes:attributes].width;
            }
            
            title = [title stringByAppendingString:ellipsis];
        }
        
        [self setTitle:title forSegmentAtIndex:i];
        
        textWidth += width;
        marginWidth += margin;
    }
    
    // resize segments to accomodate text size, evenly split total margin width
    for (NSUInteger i = 0; i < nSegments; i++) {
        // size for label width plus an equal share of the space
        CGFloat textWidth = [[self titleForSegmentAtIndex:i]
                             sizeWithAttributes:attributes].width;
        // the control leaves a 1 pixel gap between segments if width
        // is not an integer value; roundf() fixes this
        CGFloat segWidth = roundf(textWidth + (marginWidth / nSegments));
        [self setWidth:segWidth forSegmentAtIndex:i];
    }
    
    // set control width
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, (textWidth + marginWidth), self.frame.size.height)];
}

@end
