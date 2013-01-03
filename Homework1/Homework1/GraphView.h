//
//  GraphView.h
//  Homework1
//
//  Created by Jan Sabbe on 3/01/13.
//
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource <NSObject>
- (double) giveYForX: (double) x inView: (GraphView*) view;
@end

@interface GraphView : UIView
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@property (nonatomic, weak) id<GraphViewDataSource> delegate;
@end
