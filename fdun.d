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
/* swash-tentative status: ACTIVE */

// fdun.d: Functions for reading and writing dungeon level files

import global;

import fexcept;

import std.stdio;
import std.format;
import std.file;

/++
 + Opens a level from a file.
 +
 + This function opens a level from a file.  The file is specified by the
 + given integer level_number.  The file will have the file name
 + `save/lev/<level_number>.lev`
 +
 + The file is always opened in "read mode," because this function is only
 + intended to <i>access</i> files, not save them.
 +
 + Throws:
 +     DungeonFileException if the dungeon file does not exist or is
 +     inaccessible
 +
 + Params:
 +     level_number: The dungeon level that we want to load.
 +
 + Returns: A `File` opened by the function.
 +/
File open_level( T... )( T args )
{
  string path = format( "save/lev/%s.lev", format( args ) );

  // Check if the file exists; if it doesn't, throw an exception
  if( !exists( path ) )
  { level_file_error( path, "File does not exist." );
  }

  if( !isFile( path ) )
  { level_file_error( path, "This is a directory or symlink, not a file" );
  }

  File ret;

  try
  {
    ret = File( path, "r" );
  }
  catch( FileException e )
  {
    level_file_error( path, e.msg );
  }

  return ret;
}

/++
 + Saves a level to a file
 +
 + This function takes in a `map` and a `player` and writes the map data and
 + the player's coordinates to a file.  The file is specified by the given
 + integer level_number.  The file will always be in the same directory as the
 + program, and will be the file name `<level_number>.lev`
 +
 + The file is accessed in "write mode," and will overwrite any existing file.
 +
 + Throws:
 +     DungeonFileException if the file path is inaccessible,
 +     FileException if some other problem happened while writing.
 +
 + Params:
 +     m = The `map` to be saved
 +     u = The `player` character
 +     level_number = The level number to be used for the resulting file name
 +/
void save_level( T... )( map m, player u, T args )
{
  File fil;
  string path = format( "save/lev/%s.lev", format( args ) );

  if( exists( path ) && !isFile( path ) )
  {
    level_file_error( path,
                      "This file name points to a directory or symlink" );
  }

  try
  {
    fil = File( path, "w" );
  }
  catch( FileException e )
  {
    level_file_error( path, e.msg );
  }

  // First things first: Output the version number so that we can determine
  // level file compatibility:
  string ver = format( "%.3f", VERSION );
  fil.writeln( VERSION );

  // We start by recording all of the tiles on the map:

  // Leave a marker indicating we're starting tile recording:
  fil.writeln( cast(char)20 );

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      tile t = m.t[y][x];

      // Each tile has a symbol...
      symbol s = t.sym;

      // Each symbol has a char...
      char ch = s.ch;

      // We write the char first.
      fil.writeln( ch );

      // Each symbol has a Color...
      Color c = s.color;

      // Each Color has a foreground color...
      ubyte fg = c.fg;

      // Write that as 2-bit hexadecimal
      fil.writef( "%4x\n", fg );

      // ...and a boolean...
      bool reverse = c.reverse;

      // Write that as a char
      fil.writeln( reverse ? '1': '0' );

      // Each tile also has a series of booleans:
      bool block_c = t.block_cardinal_movement,
           block_d = t.block_diagonal_movement,
           block_v = t.block_vision,
           lit = t.lit, seen = t.seen;

      // Write them alllllllllllll! (maniacal laughter)
      fil.writef( "%c\n", block_c ? '1' : '0' );
      fil.writef( "%c\n", block_d ? '1' : '0' );
      fil.writef( "%c\n", block_v ? '1' : '0' );
      fil.writef( "%c\n", lit     ? '1' : '0' );
      fil.writef( "%c\n", seen    ? '1' : '0' );

      // Finally, each tile contains a short:
      ushort hazard = t.hazard;

      // We write that as a four-digit hexadecimal number:
      fil.writef( "%4x\n", hazard );

      // We're done with this tile.
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  // Leave a marker indicating that we're finishing tile output and starting
  // items:
  fil.writeln( cast(char)20 );

  // Start writing items:
  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      item i = m.i[y][x];

      // Every item has a symbol:
      symbol s = i.sym;

      // Unlike with the tiles, if the symbol's character is equal to '\0' we
      // actually just output a marker and then continue, because that
      // indicates that there's no item there.
      if( s.ch == '\0' )
      {
        fil.writeln( cast(char)19 );
        continue;
      }

      // Otherwise, we treat this symbol much like the tile's symbol:

      char ch = s.ch;
      fil.writeln( ch );

      Color c = s.color;

      ubyte fg = c.fg;
      fil.writef( "%2x\n", fg );

      bool reverse = c.reverse;
      fil.writeln( reverse ? '1': '0' );

      // Each item has a name...
      string name = i.name;

      // The name gets output using "writeln" so that it can be easily read
      // using "readln"
      fil.writeln( name );

      // Each item has two ushorts...
      ushort type = i.type, equip = i.equip;

      // Write both of those as four-digit hexadecimals:
      fil.writef( "%4x\n%4x\n", type, equip );

      // Each item has two bytes...
      byte addd = i.addd, addm = i.addm;

      // Write these as characters
      fil.writef( "%2x\n%2x\n", addd, addm );

      // We're done with the item.
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  // Leave a marker indicating that we're done with items and now are
  // outputting monsters
  fil.writeln( cast(char)20 );

  // Start writing monsters:
  foreach( n; 0 .. m.m.length )
  {
    monst mn = m.m[n];

    // If the monster has no hit points, skip it... dead monsters aren't worth
    // recording.
    if( mn.hp <= 0 )
    { continue;
    }

    // Every monster has--you guessed it!  A symbol!
    symbol s = mn.sym;

    char ch = s.ch;
    fil.writeln( ch );

    Color c = s.color;

    ubyte fg = c.fg;
    fil.writef( "%2x\n", fg );

    bool reverse = c.reverse;
    fil.writeln( reverse ? '1': '0' );

    // Every monster has a string...
    string name = mn.name;
    fil.writeln( name );

    // Every monster has an int...
    int hp = mn.hp;

    // That gets output as a 16-bit hexadecimal (16-bit because on some
    // specifications it might be a 64-bit decimal number)
    fil.writef( "%16x\n", hp );

    // Every monster has for ubytes...
    ubyte fly = mn.fly, swim = mn.swim, x = mn.x, y = mn.y;

    // Write all of these as chars...
    fil.writef( "%2x\n%2x\n%2x\n%2x\n", fly, swim, x, y );

    // Every monster has a dicebag...
    dicebag db = mn.attack_roll;

    // Every dicebag has a ubyte...
    ubyte di = db.dice;

    // Output this as a char
    fil.writef( "%2x\n", di );

    // Every dicebag has a short...
    short modifier = db.modifier;

    // Output this as a 4-digit hexadecimal
    fil.writef( "%4x\n", modifier );

    // Every dicebag has two ints...
    int floor = db.floor, ceiling = db.ceiling;

    // Output each of these as a 16-bit hexadecimal
    fil.writef( "%16x\n%16x\n", floor, ceiling );

    // We're done with the monster.
  } // foreach( n; 0 .. m.m.length )

  // Leave a marker indicating that we're done with outputting monsters
  fil.writeln( cast(char)20 );

  // Finally, we output the coordinates that the player character is standing
  // at.
  ubyte x = u.x, y = u.y;

  fil.writef( "%2x\n%2x\n", x, y );

  // We're done.
  fil.close();
} // save_level( map, player, uint )

/++
 + Get a saved level from a file
 +/
map level_from_file( string file_label )
{
  string path = format( "save/lev/%s.lev", file_label );

  if( !exists( path ) )
  { level_file_error( path, "File does not exist." );
  }

  if( !isFile( path ) )
  { level_file_error( path, "This is a directory or a symlink, not a file." );
  }

  File fil;

  try
  {
    fil = File( path, "r" );
  }
  catch( FileException e )
  {
    level_file_error( path, e.msg );
  }

  float ver = 0.000;

  fil.readf!"%f\n"( ver );

  if( ver < 0.025 )
  {
    fil.close();
    level_file_error( path, "File version %.3f not compatible with current "
                      ~ "version %.3f", ver, VERSION );
  }

  char marker = '\0';

  fil.readf!"%c\n"( marker );

  if( marker != cast(char)20 )
  {
    fil.close();
    level_file_error( path,
                  "Could not read map tiles; file not formatted correctly." );
  }

  map m;

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      tile t;

      char ch = '?';
      ubyte fg = CLR_LITERED;
      char reversed = '0';

      fil.readf!"%c\n%x\n%c\n"( ch, fg, reversed );

      t.sym.ch = ch;
      t.sym.color.fg = fg;
      t.sym.color.reverse = reversed == '0' ? false : true;

      char block_c = '1', block_d = '1', block_v = '1', lit = '0',
           seen = '0';

      fil.readf!"%c\n%c\n%c\n%c\n%c\n"( block_c, block_d, block_v, lit, seen );

      t.block_cardinal_movement = block_c == '0' ? false : true;
      t.block_diagonal_movement = block_d == '0' ? false : true;
      t.block_vision = block_v == '0' ? false : true;
      t.lit = lit == '0' ? false : true;
      t.seen = seen == '0' ? false : true;

      ushort hazard = 0;

      fil.readf!"%x\n"( hazard );

      t.hazard = hazard;

      m.t[y][x] = t;
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  fil.readf!"%c\n"( marker );

  if( marker != cast(char)20 )
  {
    fil.close();
    level_file_error( path,
                  "Could not read items; file not formatted correctly." );
  }

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      char ch = '\0';

      fil.readf!"%c\n"( ch );

      if( ch == cast(char)19 )
      {
        m.i[y][x] = No_item;
        continue;
      }

      item i;

      ubyte fg = CLR_LITERED;
      char reversed = '1';

      fil.readf!"%x\n%c\n"( fg, reversed );

      i.sym.ch = ch;
      i.sym.color.fg = fg;
      i.sym.color.reverse = reversed == '0' ? false : true;

      string name = fil.readln();

      i.name = name;

      ushort type = 0, equip = 0;

      fil.readf!"%x\n%x\n"( type, equip );

      i.type = type;
      i.equip = equip;

      byte addd = 0, addm = 0;

      fil.readf!"%x\n%x\n"( addd, addm );

      i.addd = addd;
      i.addm = addm;

      m.i[y][x] = i;
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  fil.readf!"%c\n"( marker );

  if( marker != cast(char)20 )
  {
    fil.close();
    level_file_error( path,
                  "Could not read monsters; file not formatted correctly." );
  }

  char ch = '\0';
  uint count = 0;

  fil.readf!"%c\n"( ch );

  while( ch != cast(char)20 )
  {
    if( fil.eof() )
    {
      fil.close();
      level_file_error( path, "Reached EOF before end of monster array" );
    }

    monst mn;

    ubyte fg = CLR_LITERED;
    char reversed = '1';

    fil.readf!"%x\n%c\n"( fg, reversed );

    mn.sym.ch = ch;
    mn.sym.color.fg = fg;
    mn.sym.color.reverse = reversed == '0' ? false : true;

    string name = fil.readln();
 
    mn.name = name;

    int hp = 0;

    fil.readf!"%x\n"( hp );

    mn.hp = hp;

    ubyte fly = 0, swim = 0;

    fil.readf!"%x\n%x\n"( fly, swim );

    mn.fly = fly;
    mn.swim = swim;

    ubyte di = 0;

    fil.readf!"%x\n"( di );

    mn.attack_roll.dice = di;

    short modifier = 0;

    fil.readf!"%x\n"( modifier );

    mn.attack_roll.modifier = modifier;

    int floor = 1000, ceiling = 0;

    fil.readf!"%x\n%x\n"( floor, ceiling );

    mn.attack_roll.floor = floor;
    mn.attack_roll.ceiling = ceiling;

    ubyte x = 0, y = 0;

    fil.readf!"%x\n%x\n"( x, y );

    mn.x = x;
    mn.y = y;

    m.m[count] = mn;
    count++;

    fil.readf!"%c\n"( ch );
  }

  ubyte px = 0, py = 0;

  fil.readf!"%x\n%x\n"( px, py );

  m.player_start = [ py, px ];

  fil.close();

  return m;
} // level_from_file( string )
