#import <Foundation/Foundation.h>

@interface interpreter : NSObject

- (instancetype)iwf:(NSString *)fn;
- (void)bfi; // brainfuck interpreter theres a github repo name bfi btw :(
             // shortened alot of stuff
             // _c = code, _mem = memory, _ptr = pointer, _i = instructions.
@end

@implementation interpreter
{
    NSString *_c;
    unsigned char _mem[30000];
    unsigned char *_ptr;
    NSUInteger _i;
}

- (instancetype)iwf:(NSString *)fn
{
    self = [super init];
    if (self) {
        _c = [NSString stringWithContentsOfFile:fn encoding:NSUTF8StringEncoding error:nil];
        _ptr = _mem;
        _i = 0;
    }
    return self;
}

- (void)bfi 
{
    while (_i < _c.length) {
        unichar ch = [_c characterAtIndex:_i];
        switch (ch) {
            case '>':
                _ptr++;
                break;
            case '<':
                _ptr--;
                break;
            case '+':
                (*_ptr)++;
                break;
            case '-':
                (*_ptr)--;
                break;
            case '.':
                putchar(*_ptr);
                break;
            case ',':
                *_ptr = getchar();
                break;
            case '[':
                if (*_ptr == 0) {
                    NSUInteger loopCount = 1;
                    while (loopCount != 0) {
                        _i++;
                        if ([_c characterAtIndex:_i] == '[') {
                            loopCount++;
                        } else if ([_c characterAtIndex:_i] == ']') {
                            loopCount--;
                        }
                    }
                }
                break;
            case ']':
                if (*_ptr != 0) {
                    NSUInteger loopCount = 1;
                    while (loopCount != 0) {
                        _i--;
                        if ([_c characterAtIndex:_i] == ']') {
                            loopCount++;
                        } else if ([_c characterAtIndex:_i] == '[') {
                            loopCount--;
                        }
                    }
                }
                break;
            default:
                break;
        }
        _i++;
    }
}

@end

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc != 2) {
            NSLog(@"Usage: %s <input_file>", argv[0]);
            return 1;
        }
        NSString *fn = [NSString stringWithUTF8String:argv[1]];
        interpreter *interpret = [[interpreter alloc] iwf:fn];
        [interpret bfi];
    }
    return 0;
}

