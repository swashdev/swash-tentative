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

// Defines a "symbol library," which allows the user to look up what a
// particular symbol represents by giving them a list of names associated with
// that symbol.  Also defines functions related to the library.

// This associative array is the "symbol library," and is used to allow the
// player to look up what a given symbol means.
static string[][char] Symbol_library;

// This function gives an array of definitions for the given `index' char.
string[] what_is( char index )
{
  // First check that the char is listed in the library.
  string* d = (index in Symbol_library);

  // if not, we'll return an empty array.
  if( d == null )
  { return [];
  }

  return Symbol_library[index];
}

// This function adds a definition to the symbol library
void symbol_is( char index, string definition )
{
  // First check if the given index is already in the library
  if( (index in Symbol_library) == null )
  {
    // If not, we add a new index and set the definition to an array
    // containing only `definition'
    Symbol_library[index] = [definition];
  }
  // If the index _is_ present, we have to check if the given definition is
  // already present in the library.
  else
  {
    // If it is not present, we'll append `definition' to the array.
    if( (definition in Symbol_library[index]) == null )
    {
      Symbol_library[index] ~= definition;
    }
  }
} // void symbol_is( char, string )

// Removes a definition from the library
void symbol_is_not( char index, string definition )
{
  if( (index in Symbol_library) != null )
  {
    if( (definition in Symbol_library[index]) != null )
    {
      // Determine the index that the definition is at and overwrite that
      // definition with the next in line:
      int index_of = -1, num_found = 0;
      foreach( i; (definition in Symbol_library[index]
                  .. Symbol_library[index].length - 1 )
      { Symbol_library[index][i] = Symbol_library[index][i + 1];
      }
      // Truncate the library's length:
      Symbol_library[index].length--;
    }
  }
} // void symbol_is_not( char, string )
