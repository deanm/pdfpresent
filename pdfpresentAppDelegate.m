//
//  pdfpresentAppDelegate.m
//  pdfpresent
//
//  Created by Dean on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "pdfpresentAppDelegate.h"

@implementation pdfpresentAppDelegate

@synthesize window = window_;

-(void)PageChanged:(NSNotification*)notification {
  [pdf_view2_ goToPage:[pdf_view_ currentPage]];
}

-(BOOL)application:(NSApplication*)app openFile:(NSString*)filename {
  NSArray* screens = [NSScreen screens];
  if ([screens count] < 2) {
    [[NSAlert alertWithMessageText:@"Cannot present on a single screen."
              defaultButton:nil
              alternateButton:nil
              otherButton:nil
              informativeTextWithFormat:@""]
                  beginSheetModalForWindow:window_
                  modalDelegate:nil didEndSelector:nil contextInfo:nil];
    return NO;
  }

  NSURL* doc_url = [NSURL fileURLWithPath:filename];
  PDFDocument* doc = [[PDFDocument alloc] initWithURL:doc_url];

  pdf_view_ = [[PDFView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
  pdf_view2_ = [[PDFView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
  [pdf_view_ setDocument:doc];
  [pdf_view2_ setDocument:doc];
  [pdf_view_ setBackgroundColor:[NSColor blackColor]];
  [pdf_view2_ setBackgroundColor:[NSColor blackColor]];
  [pdf_view_ setDisplayMode:kPDFDisplayTwoUp];
  [pdf_view2_ setDisplayMode:kPDFDisplaySinglePage];
  [pdf_view_ setAutoScales:YES];
  [pdf_view2_ setAutoScales:YES];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(PageChanged:)
                                        name:PDFViewPageChangedNotification
                                        object:pdf_view_];

  [pdf_view2_ enterFullScreenMode:[screens objectAtIndex:1]
              withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithBool:NO], NSFullScreenModeAllScreens, nil]
              ];
  [pdf_view_ enterFullScreenMode:[screens objectAtIndex:0]
             withOptions:[NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithBool:NO], NSFullScreenModeAllScreens, nil]
             ];
  [doc release];
  return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

@end
