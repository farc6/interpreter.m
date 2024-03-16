#import <Foundation/Foundation.h>

@interface interpreter : NSObject

- (instancetype)iwf:(NSString *)fn;
- (void)compile;

@end

@implementation interpreter
{
    NSString *_code;
    unsigned char _mem[30000];
    unsigned char *_ptr;
    NSUInteger _ip;
}

- (instancetype)iwf:(NSString *)fn
{
    self = [super init];
    if (self) {
        _code = [NSString stringWithContentsOfFile:fn encoding:NSUTF8StringEncoding error:nil];
        _ptr = _mem;
        _ip = 0;
    }
    return self;
}

- (void)compile 
{
    while (_ip < _code.length) {
        unichar ch = [_code characterAtIndex:_ip];
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
                        _ip++;
                        if ([_code characterAtIndex:_ip] == '[') {
                            loopCount++;
                        } else if ([_code characterAtIndex:_ip] == ']') {
                            loopCount--;
                        }
                    }
                }
                break;
            case ']':
                if (*_ptr != 0) {
                    NSUInteger loopCount = 1;
                    while (loopCount != 0) {
                        _ip--;
                        if ([_code characterAtIndex:_ip] == ']') {
                            loopCount++;
                        } else if ([_code characterAtIndex:_ip] == '[') {
                            loopCount--;
                        }
                    }
                }
                break;
            default:
                break;
        }
        _ip++;
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
        interpreter *compiler = [[interpreter alloc] iwf:fn];
        [compiler compile];
    }
    return 0;
}

