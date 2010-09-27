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

-(void)computerPageChanged:(NSNotification*)notification {
  [pdf_view2_ goToPage:[pdf_view_ currentPage]];
}

-(void)presentPageChanged:(NSNotification*)notification {
  PDFDocument* doc = [pdf_view_thumb_ document];
  [pdf_view_thumb_ goToPage:
      [doc pageAtIndex:[doc indexForPage:[pdf_view2_ currentPage]] + 2]];
}

-(void)updateTimerLabel {
  int diffs = [[NSDate date] timeIntervalSinceDate:start_time_];
  [timer_label_ setStringValue:
      [NSString stringWithFormat:@"%02d : %02d", diffs / 60, diffs % 60]];
}

-(BOOL)application:(NSApplication*)app openFile:(NSString*)filename {
  NSArray* screens = [NSScreen screens];

  NSURL* doc_url = [NSURL fileURLWithPath:filename];
  PDFDocument* doc = [[PDFDocument alloc] initWithURL:doc_url];

  timer_label_ =
      [[NSTextField alloc] initWithFrame:NSMakeRect(450, 0, 500, 70)];
  [timer_label_ setEditable:NO];
  [timer_label_ setDrawsBackground:NO];
  [timer_label_ setBordered:NO];
  [timer_label_ setFont:[NSFont boldSystemFontOfSize:32]];
  [timer_label_ setTextColor:[NSColor whiteColor]];

  pdf_view_ = [[PDFView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
  pdf_view2_ = [[PDFView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
  pdf_view_thumb_ = [[PDFView alloc] initWithFrame:NSMakeRect(0, 0, 400, 400)];
  [pdf_view_ setDocument:doc];
  [pdf_view2_ setDocument:doc];
  [pdf_view_thumb_ setDocument:doc];
  [pdf_view_thumb_ goToPage:[doc pageAtIndex:2]];
  [pdf_view_ setBackgroundColor:[NSColor blackColor]];
  [pdf_view2_ setBackgroundColor:[NSColor blackColor]];
  [pdf_view_thumb_ setBackgroundColor:[NSColor whiteColor]];
  [pdf_view_ setDisplayMode:kPDFDisplayTwoUp];
  [pdf_view2_ setDisplayMode:kPDFDisplaySinglePage];
  [pdf_view_thumb_ setDisplayMode:kPDFDisplaySinglePage];
  [pdf_view_ setAutoScales:YES];
  [pdf_view2_ setAutoScales:YES];
  [pdf_view_thumb_ setAutoScales:YES];
  // Uggg, shouldn't this happen when you set setShouldAntiAlias?  I guess not.
  // There is a thread about what Skim does, setting the graphics context to
  // high interpolation in a drawPage subclass.  We do it the way that preview
  // does it, and call an undocumented private method on PDFViewPrivate.  
  [pdf_view_ setInterpolationQuality:2];
  [pdf_view2_ setInterpolationQuality:2];

  [pdf_view_ addSubview:pdf_view_thumb_];
  [pdf_view_ addSubview:timer_label_];
  
  start_time_ = [[NSDate date] retain];
  [self updateTimerLabel];
  NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1
                            target:self selector:@selector(updateTimerLabel)
                            userInfo:nil repeats:YES];
  [timer retain];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(computerPageChanged:)
                                        name:PDFViewPageChangedNotification
                                        object:pdf_view_];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                        selector:@selector(presentPageChanged:)
                                        name:PDFViewPageChangedNotification
                                        object:pdf_view2_];

  int display_settings = NSApplicationPresentationHideDock |
                         NSApplicationPresentationHideMenuBar;

   NSDictionary* fs_options =
      [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithBool:NO],
          NSFullScreenModeAllScreens,
          [NSNumber numberWithInt:display_settings],
          NSFullScreenModeApplicationPresentationOptions,
          nil];

  if ([screens count] >= 2) {
    [pdf_view2_ enterFullScreenMode:[screens objectAtIndex:1]
                withOptions:fs_options];
  }
  [pdf_view_ enterFullScreenMode:[screens objectAtIndex:0]
              withOptions:fs_options];

  [doc release];
  return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

@end
