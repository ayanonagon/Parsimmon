// ParsimmonToken.m
// 
// Copyright (c) 2013 Ayaka Nonaka
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ParsimmonTaggedToken.h"

@interface ParsimmonTaggedToken ()
@property (copy, nonatomic, readwrite) NSString *token;
@property (copy, nonatomic, readwrite) NSString *tag;
@end

@implementation ParsimmonTaggedToken

- (instancetype)initWithToken:(NSString *)token tag:(NSString *)tag
{
    self = [super init];
    if (self) {
        self.token = token;
        self.tag = tag;
    }
    return self;
}


#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"('%@', %@)", self.token, self.tag];
}

- (NSUInteger)hash
{
    NSUInteger hash = self.token.hash ^ self.tag.hash;
    
    return hash;
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = NO;

    if ([object isKindOfClass:[self class]]) {
        isEqual = [self isEqualToTaggedToken:object];
    }
    return isEqual;
}

- (BOOL)isEqualToTaggedToken:(ParsimmonTaggedToken *)taggedToken
{
    return ([self.token isEqualToString:taggedToken.token] &&
            [self.tag isEqualToString:taggedToken.tag]);
}

@end
