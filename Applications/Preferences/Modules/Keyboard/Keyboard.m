/*
  Controller class for Keyboard preferences bundle

  Author:	Sergii Stoian <stoyan255@ukr.net>
  Date:		28 Nov 2015

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation; either version 2 of
  the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public
  License along with this program; if not, write to:

  Free Software Foundation, Inc.
  59 Temple Place - Suite 330
  Boston, MA  02111-1307, USA
*/

#import <Foundation/Foundation.h>

#import <AppKit/NSApplication.h>
#import <AppKit/NSNibLoading.h>
#import <AppKit/NSView.h>
#import <AppKit/NSBox.h>
#import <AppKit/NSImage.h>
#import <AppKit/NSButton.h>
#import <AppKit/NSBrowser.h>
#import <AppKit/NSMatrix.h>

#import <NXFoundation/NXDefaults.h>

#import "Keyboard.h"

@implementation Keyboard

static NSBundle                 *bundle = nil;
static NSUserDefaults           *defaults = nil;
static NSMutableDictionary      *domain = nil;

- (id)init
{
  self = [super init];
  
  defaults = [NSUserDefaults standardUserDefaults];
  domain = [[defaults persistentDomainForName:NSGlobalDomain] mutableCopy];

  bundle = [NSBundle bundleForClass:[self class]];
  NSString *imagePath = [bundle pathForResource:@"Keyboard" ofType:@"tiff"];
  image = [[NSImage alloc] initWithContentsOfFile:imagePath];

  layouts = [NSArray arrayWithObjects:
                       @"Dutch",		// nl,basic
                     @"Dutch (standard)",	// nl, std
                     @"Dutch (Macintosh)",	// nl, mac
                     @"English (US)",
                     @"English (US, with euro on 5)",
                     @"English (US, international with dead keys)",
                     @"English (US, alternative international)",
                     @"English (Dvorak)",
                     @"English (Dvorak, international with dead keys)",
                     @"English (Dvorak alternative international no dead keys)",
                     @"English (left handed Dvorak)",
                     @"English (right handed Dvorak)",
                     @"English (classic Dvorak)",
                     @"English (programmer Dvorak)",
                     @"English (Macintosh)",
                     @"English (Colemak)",
                     @"English (international AltGr dead keys)",
                     @"English (US)",
                     @"English (layout toggle on multiply/divide key)",
                     @"English (Workman)",
                     @"English (Workman, international with dead keys)",
                     @"English (US, international AltGr Unicode combining)",
                     @"English (US, international AltGr Unicode combining, alternative)",
                     @"English (South Africa)",
                     @"Esperanto",
                     @"Esperanto (Portugal, Nativo)",
                     @"French",
                     @"French (Canada)",
                     @"French (Canada, Dvorak)",
                     @"French (Canada, legacy)",
                     @"French (Democratic Republic of the Congo)",
                     @"French (Switzerland)",
                     @"French (Switzerland, Macintosh)",
                     @"French (Cameroon)",
                     @"French (alternative)",
                     @"French (alternative, latin-9 only)",
                     @"French (legacy, alternative)",
                     @"French (Bepo, ergonomic, Dvorak way)",
                     @"French (Bepo, ergonomic, Dvorak way, latin-9 only)",
                     @"French (Dvorak)",
                     @"French (Breton)",
                     @"French (Macintosh)",
                     @"French (Guinea)",
                     @"French (Morocco)",
                     @"French (Mali, alternative)",
                     @"German",
                     @"German (Austria)",
                     @"German (Austria, Macintosh)",
                     @"German (Switzerland)",
                     @"German (Switzerland, legacy)",
                     @"German (Switzerland, Macintosh)",
                     @"German (legacy)",
                     @"German (T3)",
                     @"German (Dvorak)",
                     @"German (Neo 2)",
                     @"German (Macintosh)",
                     @"German (qwerty)",
                     @"German (US keyboard with German letters)",
                     @"German (with Hungarian letters and no dead keys)",
                     @"Hungarian",
                     @"Hungarian (standard)",
                     @"Hungarian (eliminate dead keys)",
                     @"Hungarian (qwerty)",
                     @"Hungarian (101/qwertz/comma/dead keys)",
                     @"Hungarian (101/qwertz/comma/eliminate dead keys)",
                     @"Hungarian (101/qwertz/dot/dead keys)",
                     @"Hungarian (101/qwertz/dot/eliminate dead keys)",
                     @"Hungarian (101/qwerty/comma/dead keys)",
                     @"Hungarian (101/qwerty/comma/eliminate dead keys)",
                     @"Hungarian (101/qwerty/dot/dead keys)",
                     @"Hungarian (101/qwerty/dot/eliminate dead keys)",
                     @"Hungarian (102/qwertz/comma/dead keys)",
                     @"Hungarian (102/qwertz/comma/eliminate dead keys)",
                     @"Hungarian (102/qwertz/dot/dead keys)",
                     @"Hungarian (102/qwertz/dot/eliminate dead keys)",
                     @"Hungarian (102/qwerty/comma/dead keys)",
                     @"Hungarian (102/qwerty/comma/eliminate dead keys)",
                     @"Hungarian (102/qwerty/dot/dead keys)",
                     @"Hungarian (102/qwerty/dot/eliminate dead keys)",
                     @"Italian",
                     @"Korean",
                     @"Russian",
                     @"Slovak",
                     @"Spanish",
                     @"Traditional Chinese",
                     @"Ukrainian",
                     @"Ukrainian (legacy)",
                     @"Ukrainian (WinKeys)",
                     @"Ukrainian (typewriter)",
                     @"Ukrainian (phonetic)",
                     @"Ukrainian (standard RSTU)",
                     @"Ukrainian (homophonic)",
                     nil];
  [layouts retain];

      
  return self;
}

- (void)dealloc
{
  NSLog(@"KeyboardPrefs -dealloc");
  [image release];
  [super dealloc];
}

- (void)awakeFromNib
{
  [view retain];
  [window release];

  [repeatBox retain];
  [repeatBox removeFromSuperview];
  [layoutsBox retain];
  [layoutsBox removeFromSuperview];
  [shortcutsBox retain];
  [shortcutsBox removeFromSuperview];

  [[sectionsMtrx cellWithTag:0] setRefusesFirstResponder:YES];
  [[sectionsMtrx cellWithTag:1] setRefusesFirstResponder:YES];
  [[sectionsMtrx cellWithTag:2] setRefusesFirstResponder:YES];

  [shortcutsBrowser loadColumnZero];
  [shortcutsBrowser setTitle:@"Action" ofColumn:0];
  [shortcutsBrowser setTitle:@"Shortcut" ofColumn:1];

  [self sectionButtonClicked:sectionsMtrx];
}

- (NSView *)view
{
  if (view == nil)
    {
      if (![NSBundle loadNibNamed:@"Keyboard" owner:self])
        {
          NSLog (@"Could not load Keyboard.gorm file.");
          return nil;
        }
    }
  
  return view;
}

- (NSString *)buttonCaption
{
  return @"Keyboard Preferences";
}

- (NSImage *)buttonImage
{
  return image;
}

//
// Action methods
//
- (void)sectionButtonClicked:(id)sender
{
  switch ([[sender selectedCell] tag])
    {
    case 0: // Key Repeat
      [sectionBox setContentView:repeatBox];
      break;
    case 1: // Layouts
      [sectionBox setContentView:layoutsBox];
      [self layoutsDictionary];
      break;
    case 2: // Shortcuts
      [sectionBox setContentView:shortcutsBox];
      break;
    default:
      NSLog(@"Keyboard.preferences: Unknow section button was clicked!");
    }
}

@end

@implementation Keyboard (KeyRepeat)

- (void)repeatAction:(id)sender
{
  NXDefaults 		*defs = [[NXDefaults alloc] initWithUserDefaults];
  NSMutableDictionary	*keybDefs;
  
  keybDefs = [[defs objectForKey:@"NXKeyboard"] mutableCopy];
  if (sender == initialRepeatMtrx)
    { // NXKeyboard-InitialKeyRepeat - delay in milliseconds before repeat
      [keybDefs setObject:[NSNumber numberWithInt:[[sender selectedCell] tag]]
                   forKey:@"InitialKeyRepeat"];
    }
  else if (sender == repeatRateMtrx)
    { // NXKeyboard - RepeatRate - num of repeates per second
      [keybDefs setObject:[NSNumber numberWithInt:[[sender selectedCell] tag]]
                   forKey:@"RepeatRate"];
    }

  [defs setObject:keybDefs forKey:@"NXKeyboard"];
  [defs synchronize];
}

@end

@implementation Keyboard (XKB)

#define XKB_BASE_LST @"/usr/share/X11/xkb/rules/base.lst"

- (NSDictionary *)parseXkbBaseList
{
  NSMutableDictionary	*dict = [[NSMutableDictionary alloc] init];
  NSMutableDictionary	*modeDict == nil;
  NSString		*baseLst;
  NSScanner		*scanner;
  NSString		*lineString = @" ";
  NSString		*sectionName, *columnOne, *columnTwo;
  NSArray		*lineComponents;
  // BOOL			layoutScanning = NO;

  baseLst = [NSString stringWithContentsOfFile:XKB_BASE_LST];
  scanner = [NSScanner scannerWithString:baseLst];

  while ([scanner scanUpToString:@"\n" intoString:&lineString] == YES)
    {
      // New section start encountered
      if ([lineString characterAtIndex:0] == '!')
        {
          if (modeDict != nil)
            {
              [dict addObject:modeDict forKey:sectionName];
            }
          
          sectionName = [lineString substringFromIndex:2];
          
          // if ([sectionName isEqualToString:@"layout"] == YES)
          //   layoutScanning = YES;
          // if ([sectionName isEqualToString:@"layout"] == NO && layoutScanning == YES)
          //   break;
          
          NSLog(@"Keyboard: found section: %@", sectionName);
        }
      else
        { // Parse line and add into 'modeDict' dictionary
          columnOne
        }
    }

  return [dict autorelease];
}

@end
