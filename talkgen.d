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
/* swash-tentative status: TENTATIVE */

// Defines functions and structures related to random dialogue generation

import global;

static if( PROFANITY )
{
string[] interjections = [ "crap", "zounds", "gadzooks", "frig",
                           "by the True God" ];
string[] insults = [ "you wanker", "you bastard", "asshole", "poppet",
                     "you blasphemous goat-lover", "you penis-minstrel" ];
string[] dismissals = [ "humbug", "bollocks" ];
string[] curses = [ "bollocks to you", "a pox on you", "a pox on your house",
                    "may your innards be invaded by a donkey",
                    "go die in a ditch", "Thunderhammer devour you",
                    "eat a dick", "eat a pussy", "I hope your pet dies",
                    "may you shrivel like a prune",
      "may your nose fall off in a freak accident involving a shady hooker" ];
}
else
{
string[] interjections = [ "dang", "by the True God" ];
string[] insults = [ "you dork", "you spoon", "you blasphemous goat-lover" ];
string[] dismissals = [ "yeah right", "I'm sure", "in your dreams" ];
string[] curses = [ "Thunderhammer devour you", "I hope your pet dies",
                    "go die in a ditch", "may you shrivel like a prune" ];
}

enum Profanity_category { interjection, insulting, dismissive, cursing };

char[] profanity( string[] cuss )
{ return cuss[ uniform( 0, cuss.length, Lucky ) ].dup;
}

char[] profanity( Profanity_category type )
{
  string[] cuss;

  final switch( type )
  {
    case Profanity_category.interjection:
      cuss = interjections;
      break;
    case Profanity_category.insulting:
      cuss = insults;
      break;
    case Profanity_category.dismissive:
      cuss = dismissals;
      break;
    case Profanity_category.cursing:
      cuss = curses;
      break;
  }

  return profanity( cuss );
}
