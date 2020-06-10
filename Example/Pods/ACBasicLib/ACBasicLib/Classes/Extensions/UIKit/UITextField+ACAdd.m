//
//  UITextField+ACAdd.m
//  ACBasicLib
//
//  Created by Ken.Liu on 2018/9/28.
//

#import "UITextField+ACAdd.h"
#import "NSString+ACAdd.h"

@implementation UITextField (ACAdd)

#pragma mark - format
- (void)formatPhoneNumber {
    [self addTarget:self action:@selector(formatPhoneNumberTextHasChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)removeFormatPhoneNumber {
    [self removeTarget:self action:@selector(formatPhoneNumberTextHasChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)formatPhoneNumberTextHasChanged:(UITextField *)textField {
    NSMutableString *string = [NSMutableString stringWithString:textField.text];
    UITextRange *selectedRange = textField.selectedTextRange;
    UITextPosition* beginning = textField.beginningOfDocument;
    NSInteger location = [textField offsetFromPosition:beginning toPosition:selectedRange.start];
    BOOL shouldChangeSelectedRang = location < textField.text.length;
    textField.text = [NSString formatReviewPhoneNumber:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (shouldChangeSelectedRang) {
        UITextPosition* startPosition = [textField positionFromPosition:beginning offset:location];
        UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:startPosition];
        
        [textField setSelectedTextRange:selectionRange];
    }
}

#pragma mark - selectedTextRange
- (NSRange)selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end
