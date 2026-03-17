#import "FIXToast.h"
#import "AntiDebug.h"
#import "CryptoEngine.h"

@implementation FIXToast

+ (void)show:(NSString *)message {
    if ([AntiDebug isDebuggerAttached]) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
        
        if (@available(iOS 13.0, *)) {
            NSArray *scenes = [[UIApplication sharedApplication].connectedScenes allObjects];
            for (id scene in scenes) {
                if ([scene respondsToSelector:@selector(activationState)] &&
                    [scene activationState] == 0) {
                    if ([scene respondsToSelector:@selector(windows)]) {
                        keyWindow = [scene windows].firstObject;
                        break;
                    }
                }
            }
        } else {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }
        
        if (!keyWindow) return;
        
        UIView *toast = [[UIView alloc] initWithFrame:CGRectMake(20, 100, keyWindow.bounds.size.width - 40, 60)];
        toast.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.9];
        toast.layer.cornerRadius = 12;
        toast.layer.borderWidth = 2;
        toast.layer.borderColor = [UIColor systemGreenColor].CGColor;
        toast.alpha = 0;
        toast.tag = 9999;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, toast.bounds.size.width - 20, 60)];
        label.text = message;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 3;
        [toast addSubview:label];
        
        [[keyWindow viewWithTag:9999] removeFromSuperview];
        [keyWindow addSubview:toast];
        
        [UIView animateWithDuration:0.3 animations:^{
            toast.alpha = 1.0;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    toast.alpha = 0;
                } completion:^(BOOL finished) {
                    [toast removeFromSuperview];
                }];
            });
        }];
    });
}

@end