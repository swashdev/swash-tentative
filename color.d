/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Defines aliases for colors that can be used by the curses or SDL interfaces

import global;

static if( COLOR )
{

///////////////////
// Curses colors //
///////////////////

version( curses )
{

// If curses is enabled, perfect.  We simply use the predefined colors that
// come with curses.
// Note the mysterious absence of blue; we only use light blue to make it more
// visible against the black background.
enum CLR_DARKGRAY = COLOR_BLACK;
enum CLR_RED      = COLOR_RED;
enum CLR_GREEN    = COLOR_GREEN;
enum CLR_BROWN    = COLOR_YELLOW;

enum CLR_MAGENTA  = COLOR_MAGENTA;
enum CLR_CYAN     = COLOR_CYAN;
enum CLR_GRAY     = COLOR_WHITE;

// Lite (bold) colors:
enum CLR_BLACK       = COLOR_BLACK   | A_BOLD;
enum CLR_LITERED     = COLOR_RED     | A_BOLD;
enum CLR_LITEGREEN   = COLOR_GREEN   | A_BOLD;
enum CLR_YELLOW      = COLOR_YELLOW  | A_BOLD;
enum CLR_BLUE        = COLOR_BLUE    | A_BOLD;
enum CLR_LITEMAGENTA = COLOR_MAGENTA | A_BOLD;
enum CLR_LITECYAN    = COLOR_CYAN    | A_BOLD;
enum CLR_WHITE       = COLOR_WHITE   | A_BOLD;

} // version( curses )
else
{

// If curses is NOT enabled, we'll alias all of the colors that would have
// been defined by curses, so SDL can still refer to them
enum CLR_DARKGRAY = 0;
enum CLR_RED      = 1;
enum CLR_GREEN    = 2;
enum CLR_BROWN    = 3;

enum CLR_MAGENTA  = 5;
enum CLR_CYAN     = 6;
enum CLR_GRAY     = 7;

// Lite (bold) colors:
enum CLR_BLACK       =  8;
enum CLR_LITERED     =  9;
enum CLR_LITEGREEN   = 10;
enum CLR_YELLOW      = 11;
enum CLR_BLUE        = 12;
enum CLR_LITEMAGENTA = 13;
enum CLR_LITECYAN    = 14;
enum CLR_WHITE       = 15;

} // else from version( curses )


// Aliases for specific colors:
enum CLR_LITEBROWN  = CLR_YELLOW;
enum CLR_LITEGRAY   = CLR_WHITE;
enum CLR_PURPLE     = CLR_MAGENTA;
enum CLR_LITEPURPLE = CLR_LITEMAGENTA;
enum CLR_ORANGE     = CLR_LITERED;
enum CLR_PINK       = CLR_LITEMAGENTA;
enum CLR_LITEBLUE   = CLR_BLUE;
enum CLR_LITEYELLOW = CLR_YELLOW;

// Alternate spellings of "gray":
enum CLR_GREY     = CLR_GRAY;
enum CLR_DARKGREY = CLR_DARKGRAY;
enum CLR_LITEGREY = CLR_LITEGRAY;

// Color aliases for item materials:
enum CLR_BRONZE     = CLR_BROWN;
enum CLR_SILVER     = CLR_GRAY;
enum CLR_GOLD       = CLR_YELLOW;
enum CLR_DOLLAR     = CLR_GREEN;
enum CLR_CLOTH      = CLR_PURPLE;
enum CLR_LEATHER    = CLR_BROWN;
enum CLR_CHAIN      = CLR_CYAN;
enum CLR_IRON       = CLR_GRAY;
enum CLR_STEEL      = CLR_GRAY;
enum CLR_GLASS      = CLR_LITECYAN;
enum CLR_PAPER      = CLR_WHITE;
enum CLR_STAMP      = CLR_PAPER;
enum CLR_WOOD       = CLR_BROWN;
enum CLR_DEMONIC    = CLR_RED;
enum CLR_DWARFISH   = CLR_YELLOW;
enum CLR_ELFISH     = CLR_BLUE;
enum CLR_SCALE      = CLR_DARKGRAY;
enum CLR_HOLY       = CLR_WHITE;
enum CLR_GUNPOWDER  = CLR_DARKGRAY;

// Color aliases for map objects:
enum CLR_DEFAULT    = CLR_GREY;
enum CLR_WATER      = CLR_BLUE;
enum CLR_DIRT       = CLR_BROWN;
enum CLR_GRASS      = CLR_GREEN;
enum CLR_LEAF       = CLR_ORANGE;
enum CLR_SNOW       = CLR_WHITE;
enum CLR_TREE       = CLR_GREEN;
enum CLR_TREE_DEAD  = CLR_BROWN;
static if( FOLIAGE )
{
enum CLR_MOLD_FLOOR = CLR_LITEGREEN;
enum CLR_MOLD_WALL  = CLR_GREEN;
}
static if( BLOOD )
{
enum CLR_BLOOD      = CLR_RED;
}

// Color aliases for line-of-sight:
enum CLR_TORCHLIGHT = CLR_YELLOW;
enum CLR_SHADOW     = CLR_DARKGRAY;

// This "no color" is a special case used for when we want no color.
// Generally used for cases where we don't want a special background color for
// a particular glyph, so use the default or inherit the color that's already
// there.
enum CLR_NONE = 255;



////////////////
// SDL colors //
////////////////

version( sdl )
{

// RGB colors for SDL:
static SDL_Color SDL_DARKGRAY = SDL_Color(  64,  64,  64, 255 );
static SDL_Color SDL_RED      = SDL_Color( 128,   0,   0, 255 );
static SDL_Color SDL_GREEN    = SDL_Color(   0, 128,   0, 255 );
static SDL_Color SDL_BROWN    = SDL_Color( 150,  75,   0, 255 );
static SDL_Color SDL_MAGENTA  = SDL_Color( 128,   0, 128, 255 );
static SDL_Color SDL_CYAN     = SDL_Color(   0, 128, 128, 255 );
static SDL_Color SDL_GRAY     = SDL_Color( 128, 128, 128, 255 );

// Lite (bold) colors:
static SDL_Color SDL_BLACK       = SDL_Color(   0,   0,   0, 255 );
static SDL_Color SDL_LITERED     = SDL_Color( 255,   0,   0, 255 );
static SDL_Color SDL_LITEGREEN   = SDL_Color(   0, 255,   0, 255 );
static SDL_Color SDL_YELLOW      = SDL_Color( 255, 255,   0, 255 );
static SDL_Color SDL_BLUE        = SDL_Color(   0,   0, 255, 255 );
static SDL_Color SDL_LITEMAGENTA = SDL_Color( 255,   0, 255, 255 );
static SDL_Color SDL_LITECYAN    = SDL_Color(   0, 255, 255, 255 );
static SDL_Color SDL_WHITE       = SDL_Color( 255, 255, 255, 255 );

static SDL_Color SDL_LITEBLUE = SDL_BLUE;

// The SDL version gets a special color for characters who are "royals": royal
// purple.  This pigment was derived from predatory sea snails, and was highly
// valued because it required the harvesting of tens of thousands of snails,
// hence its association with royalty.
static SDL_Color SDL_PURPLE = SDL_Color( 102, 2, 60, 255 );

// Another special color for priests and other "holy" characters: ultramarine,
// the color of lapis lazuli, which was one of the first blue pigments and was
// so highly prized in antiquity that it was reserved for only the most
// important artistic pieces, such as those depicting Jesus or the virgin
// Mary.
static SDL_Color SDL_ULTRAMARINE = SDL_Color( 64, 0, 255, 255 );


// Some more colors because I can't help myself:  The official colors of the
// Union Jack and the Stars and Stripes:
static SDL_Color SDL_BRITISH_RED   = SDL_Color( 200,  16,  46, 255 );
static SDL_Color SDL_BRITISH_WHITE = SDL_Color( 255, 255, 255, 255 );
static SDL_Color SDL_BRITISH_BLUE  = SDL_Color(   1,  33, 105, 255 );

// Fun fact:  The red and blue used on the American flag are often called
// Old Glory Red and Old Glory Blue.
static SDL_Color SDL_AMERICAN_RED   = SDL_Color( 178,  34,  52, 255 );
static SDL_Color SDL_AMERICAN_WHITE = SDL_Color( 255, 255, 255, 255 );
static SDL_Color SDL_AMERICAN_BLUE  = SDL_Color(  60,  59, 110, 255 );

} // version( sdl )



/////////////////
// Color pairs //
/////////////////

// This struct is used to store color pairs
struct Color_pair
{
version( curses )
{
  attr_t fg, bg;
}
else
{
  ubyte fg, bg;
}
  bool reverse;
  // These booleans trigger the "purple" and "ultramarine" colors above:
  bool royal, holy;
}

version( curses )
{
Color_pair color_pair( attr_t foreground, attr_t background,
                       bool reversed = false,
                       bool royal_purple = false, bool ultramarine = false )
{
  return Color_pair( foreground, background, reversed, royal_purple,
                     ultramarine );
}
}
else
{
Color_pair color_pair( ulong foreground, ulong background,
                       bool reversed = false,
                       bool royal_purple = false, bool ultramarine = false )
{
  return Color_pair( foreground, background, reversed, royal_purple,
                     ultramarine );
}
}


} // static if( COLOR )
