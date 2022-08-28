#include "clipboard.h"
#import <AppKit/AppKit.h>

using namespace fluxe;

void Clipboard::copyStringToClipboard(std::string text) {
    NSLog(@"%s", text.c_str());
  [[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObject:NSPasteboardTypeString] owner:nil];
  [[NSPasteboard generalPasteboard] setString:[NSString stringWithUTF8String:text.c_str()] forType:NSPasteboardTypeString];
}

std::string Clipboard::pasteStringFromClipboard() {
  NSString * str = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
  return std::string(str.UTF8String);
}
