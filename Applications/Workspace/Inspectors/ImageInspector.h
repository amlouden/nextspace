/*
  ImageInspector.h



  Copyright (C) 2014 Sergii Stoian

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#import <AppKit/AppKit.h>

#import <Workspace.h>

@interface ImageInspector : WMInspector
{
  id view;
  id imageView;
  id widthLabel;
  id widthField;
  id heightLabel;
  id heightField;
  id zoomPercentField;

  NSString *selectedPath;
  NSArray  *selectedFiles;

}

@end
