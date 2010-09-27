//
//  pdfpresentAppDelegate.h
//  pdfpresent
//
//  Created by Dean on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface pdfpresentAppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow* window_;
  PDFView* pdf_view_;
  PDFView* pdf_view2_;
  PDFView* pdf_view_thumb_;
  NSTextField* timer_label_;
  NSDate* start_time_;
}

@property (assign) IBOutlet NSWindow *window;

@end
