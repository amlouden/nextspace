/*
   Shelf preferences.

   Copyright (C) 2018 Sergii Stoian
   Copyright (C) 2005 Saso Kiselkov

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
   
   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#import <AppKit/AppKit.h>
#import <NXAppKit/NXAppKit.h>

#import <Preferences.h>
#import <Preferences/PrefsModule.h>

#define SHELF_LABEL_WIDTH     100
#define SHELF_MIN_LABEL_WIDTH 40
#define SHELF_MAX_LABEL_WIDTH 100

@interface ShelfPrefs : NSObject <PrefsModule>
{
  id bogusWindow;
  id button;
  id iconImage;
  id iconLabel;
  id leftArr;
  id rightArr;
  id resizableSwitch;

  NSBox  *box;
  NSBox  *box2;
  NXIcon *icon;
}

- (void)revert:sender;

@end
