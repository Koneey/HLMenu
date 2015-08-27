//
//  HLLongPressMenu.h
//  
//
//  Created by luhao on 15/6/18.
//
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@protocol LongPressMenuDelegate <NSObject>

/**
 *  点击菜单项之后回调
 *
 *  @param index   button 的 tag
 *  @param map     key为 button 的 tag(NSNumber 类型), value 为button 的 title
 *  @param object  需要传输的数据
 */
- (void)clickMenuWithTitleIndex:(NSInteger)index map:(NSDictionary *)map object:(id)object;

@optional
- (void)menuWillHide;
- (void)menuWillShow;

@end

@interface HLLongPressMenu : UIView

@property (nonatomic, strong) id<LongPressMenuDelegate> delegate;

@property (nonatomic) CGFloat menuTopPadding; //当是右上角菜单时, 菜单据屏幕顶端的距离

/**
 *  自定义居中弹出菜单初始化方法
 *
 *  @param titleDic 传入菜单的 item 的 title,key 为 title 的 tag,必须为 NSNumber 类型,协议回调方法是调用, value 为 item 的标题
 *  @param view     将要展示的 view
 *  @param object   要传入的参数
 *
 *  @return 菜单实例
 */
- (id)initWithTitlesDictionary:(NSDictionary *)titleDic addToView:(UIView *)view object:(id)object;

/**
 *  自定义右边详情菜单初始化方法
 *
 *  @param titleDic 传入菜单的 item 的 title,key 为 title 的 tag,必须为 NSNumber 类型,协议回调方法是调用, value 为 item 的标题
 *  @param view   将要展示的 view
 *  @param object 要传入的参数
 *
 *  @return 菜单实例
 */
- (id)initTopRightSideMenuWithTitleDictionary:(NSDictionary *)titleDic addToView:(UIView *)view object:(id)object;

//刷新
- (void)reloadMenuWithTitlesDictionary:(NSDictionary *)titleDic object:(id)object;

- (void)showMenu;
- (void)hideMenu;       //隐藏 menu
- (void)removeMenu;     //从父视图中移除 menu

@end
