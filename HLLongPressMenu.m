//
//  HLLongPressMenu.m
//  
//
//  Created by luhao on 15/6/18.
//
//

#import "HLLongPressMenu.h"
#import "UIView+Additions.h"

#define kMENU_WIDTH 200 //菜单宽度
#define kMENU_ITEM_HEIGHT 44 //菜单单个条目高度

#define kMENU_TOP_PADDING 7 //右上菜单到顶部的距离

typedef NS_ENUM(NSInteger, HLMenuPosition) {
    centre,
    topRight
};


@interface HLLongPressMenu () {
    CGSize _buttonSize;         //按钮的size
    CGFloat _cornerRadius;      //按钮的圆角半径
}

@property (nonatomic, strong) UIView *ownerView;    //将要添加菜单的视图
@property (nonatomic, strong) id object;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NSDictionary *titleDic; //按钮 Item
@property (nonatomic)         HLMenuPosition menuPosition; //菜单的位置

@end

@implementation HLLongPressMenu


#pragma mark - Life cycle ------------------------------------------------------------------

- (id)initWithTitlesDictionary:(NSDictionary *)titleDic addToView:(UIView *)view object:(id)object
{
    self = [super initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    if (self) {
        self.ownerView = view;
        self.menuPosition = centre;
        self.object = object;
        self.titleDic = titleDic;
        _cornerRadius = 15.0;
        _buttonSize = CGSizeMake(kMENU_WIDTH, kMENU_ITEM_HEIGHT);
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        self.maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        [self addSubview:self.maskView];
        
        [self setupSubViews:titleDic];
        self.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidResign:)];
        [self.maskView addGestureRecognizer:tap];
        
        //添加到视图
        [view addSubview:self];
    }
    return self;
}

- (id)initTopRightSideMenuWithTitleDictionary:(NSDictionary *)titleDic addToView:(UIView *)view object:(id)object
{
    self = [super initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT)];
    if (self) {
        self.ownerView = view;
        self.menuPosition = topRight;
        self.object = object;
        self.titleDic = titleDic;
        
        _menuTopPadding = kMENU_TOP_PADDING;
        
        _cornerRadius = 5.0;
        _buttonSize = CGSizeMake(kMENU_WIDTH, kMENU_ITEM_HEIGHT);
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        self.maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        [self addSubview:self.maskView];
        
        [self setupSubViews:titleDic];
        self.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidResign:)];
        [self.maskView addGestureRecognizer:tap];
        
        //添加到视图
        [view addSubview:self];
    
//        //此菜单有导航栏唤出,需要禁用导航栏右侧按钮
//        UIViewController *owner = view.viewController;
//        [owner.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

//- (CGSize)sizeThatFits:(CGSize)size
//{
//    CGFloat width = kMENU_WIDTH;
//    CGFloat height = kMENU_ITEM_HEIGHT * self.titles.count;
//    return CGSizeMake(width, height);
//}


#pragma mark - Delegate --------------------------------------------------------------------

#pragma mark - Event response --------------------------------------------------------------

- (void)itemButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    
    if ([self.delegate respondsToSelector:@selector(clickMenuWithTitleIndex:map:object:)]) {
        [self.delegate clickMenuWithTitleIndex:index map:self.titleDic object:self.object];
    }
}

- (void)buttonDidResign:(UITapGestureRecognizer *)gestureRecognizer
{
    [self resignFirstResponder];
    [self hideMenu];
}

#pragma mark - Public methods --------------------------------------------------------------


- (void)reloadMenuWithTitlesDictionary:(NSDictionary *)titleDic object:(id)object
{
    for (id object in [self subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            [object removeFromSuperview];
        }
    }
    self.object = object;
    [self setupSubViews:titleDic];
}

- (void)showMenu
{
    
    if ([self.delegate respondsToSelector:@selector(menuWillShow)]) {
        [self.delegate menuWillShow];
    }
//    for (int i=0; i<[self subviews].count; i++) {
//        UIButton *button = (UIButton *)[self viewWithTag:1000+i];
//        //CGRect rect = button.frame;
//        //button.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        //button.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            button.alpha = 1.0;
//            //button.transform = CGAffineTransformMakeScale(1, 1);
//            //button.frame = rect;
//        } completion:nil];
//        //[NSThread sleepForTimeInterval:0.1];
//    }
    if (self.menuPosition == centre) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:nil];
    }
    else if (self.menuPosition == topRight) {
        
        [self.maskView setFrame:CGRectMake(0, 0,
                                           self.maskView.frame.size.width,
                                           self.maskView.frame.size.height + kMENU_ITEM_HEIGHT*self.titleDic.count + 2*kMENU_TOP_PADDING)];
        [self setFrame:self.ownerView.frame];
        CGFloat bottom = self.bottom;
        self.bottom -= (kMENU_ITEM_HEIGHT*self.titleDic.count + 2*kMENU_TOP_PADDING);
        self.maskView.alpha = 0;
        self.alpha = 1;
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakself.maskView.alpha = 0.4;
                             weakself.bottom = bottom;
                         } completion:nil];
    }
}

- (void)hideMenu
{
    if ([self.delegate respondsToSelector:@selector(menuWillHide)]) {
        [self.delegate menuWillHide];
    }

    if (self.menuPosition == centre) {
        
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakself.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else if (self.menuPosition == topRight) {
        
        //        //重新激活导航栏按钮
        //        UIViewController *owner = self.ownerView.viewController;
        //        [owner.navigationItem.rightBarButtonItem setEnabled:YES];
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakself.bottom -= (kMENU_ITEM_HEIGHT*self.titleDic.count + 2*weakself.menuTopPadding);
                             weakself.maskView.alpha = 0;
                             weakself.alpha = 0;
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
}

- (void)removeMenu
{
    [self removeFromSuperview];
}

#pragma mark - Private methods -------------------------------------------------------------

- (void)setupSubViews:(NSDictionary *)titleDic
{
    
    if (titleDic.count == 0) {
        return;
    }
    else {
        NSMutableArray *keys = [NSMutableArray array];
        for (NSNumber *keyNum in [titleDic keyEnumerator]) {
            [keys addObject:keyNum];
        }
        
        [keys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
//            return [obj1 integerValue] > [obj2 integerValue];
        }];
        
        
        if (titleDic.count == 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (self.menuPosition == centre) {
                [button setFrame:CGRectMake((self.frame.size.width-kMENU_WIDTH)/2,
                                            (self.frame.size.height-kMENU_ITEM_HEIGHT*titleDic.count)/2-(20+44)/2,
                                            kMENU_WIDTH,
                                            kMENU_ITEM_HEIGHT)];
            }
            else if (self.menuPosition == topRight) {
                [button setFrame:CGRectMake(self.frame.size.width-_buttonSize.width-kMENU_TOP_PADDING,
                                            _menuTopPadding,
                                            kMENU_WIDTH,
                                            kMENU_ITEM_HEIGHT)];
            }
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                           byRoundingCorners:UIRectCornerAllCorners
                                                                 cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
            
            [button setTitle:[titleDic objectForKey:keys[0]] forState:UIControlStateNormal];
            [button setTitleColor:RGBACOLOR(5, 5, 5, 1) forState:UIControlStateNormal];
            [button setTitleColor:RGBACOLOR(180, 180, 180, 1) forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            button.backgroundColor = RGBACOLOR(245, 245, 245, 1);
            button.tag = [keys[0] integerValue];
            //button.alpha = 0;
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = button.bounds;
            maskLayer.path = maskPath.CGPath;
            button.layer.mask = maskLayer;
            [self addSubview:button];
        }
        else if (titleDic.count > 1) {
            int i=0;
            for (NSNumber *tag in keys) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                
                if (self.menuPosition == centre) {
                    [button setFrame:CGRectMake((self.frame.size.width-kMENU_WIDTH)/2,
                                                (self.frame.size.height-kMENU_ITEM_HEIGHT*titleDic.count)/2-(20+44)/2 + i*kMENU_ITEM_HEIGHT,
                                                kMENU_WIDTH,
                                                kMENU_ITEM_HEIGHT)];
                }
                else if (self.menuPosition == topRight) {
                    [button setFrame:CGRectMake(self.frame.size.width-_buttonSize.width-kMENU_TOP_PADDING,
                                                _menuTopPadding+i*kMENU_ITEM_HEIGHT,
                                                kMENU_WIDTH,
                                                kMENU_ITEM_HEIGHT)];
                }
                
                
                [button setTitle:[titleDic objectForKey:tag] forState:UIControlStateNormal];
                [button setTitleColor:RGBACOLOR(5, 5, 5, 1) forState:UIControlStateNormal];
                [button setTitleColor:RGBACOLOR(180, 180, 180, 1) forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0];
                button.backgroundColor = RGBACOLOR(245, 245, 245, 1);
                button.tag = [tag integerValue];
                //button.alpha = 0;
                
                if (i == 0) {
                    
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                                         cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = button.bounds;
                    maskLayer.path = maskPath.CGPath;
                    button.layer.mask = maskLayer;
                    
                }
                else if (i == (titleDic.count-1)) {
                    
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                                         cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = button.bounds;
                    maskLayer.path = maskPath.CGPath;
                    button.layer.mask = maskLayer;
                    
                    UIView *seperatLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMENU_WIDTH, 1/[[UIScreen mainScreen] scale])];
                    seperatLine.backgroundColor = RGBACOLOR(100, 100, 100, 0.5);
                    [button addSubview:seperatLine];
                }
                else {
                    UIView *seperatLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMENU_WIDTH, 1/[[UIScreen mainScreen] scale])];
                    seperatLine.backgroundColor = RGBACOLOR(100, 100, 100, 0.5);
                    [button addSubview:seperatLine];
                }
                
                [self addSubview:button];
                i++;
            }
        }
    }
    
}

#pragma mark - Getters and setters ---------------------------------------------------------

- (void)setMenuTopPadding:(CGFloat)menuTopPadding
{
    if (menuTopPadding == _menuTopPadding) {
        return;
    }
    _menuTopPadding = menuTopPadding;
    [self reloadMenuWithTitlesDictionary:self.titleDic object:self.titleDic];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
