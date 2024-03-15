/*
 * barebone bf/brainfuck compiler
 * usage: clang bfcompiler.m -framework Cocoa
 */ 

#import <Foundation/Foundation.h>

@interface bfcompiler : NSObject

- (instancetype)iwf:(NSString *)fn;
- (void)compile;

@end

@implementation bfcompiler
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
                NSLog(@"ptr out of mem bounds");
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
        bfcompiler *compiler = [[bfcompiler alloc] iwf:fn];
        [compiler compile];
    }
    return 0;
}

