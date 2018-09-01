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

// body.d:  Declares body parts and properties related to them

/++
 + The central Body class
 +
 + This class defines a body part, and is used as a container for pointers to
 + further body parts.
 +
 + Features like whether or not the body part can hold items and what
 + equipment slot is assciated with the body part are contained here.
 +
 + Date:  2018-09-01
 +/
class Body
{
  /// The name associated with the body part.  An empty string (`""`) is
  /// acceptable, but not recommended.
  string name = "";

  /// Determines whether or not the body part is vital for the creature's
  /// survival, e.g. it contains the brain.  The torso should always be vital.
  bool vital = false;

  /// Determines whether or not the body part can hold objects, e.g. it is a
  /// hand
  bool holds_items = false;

  /// Determines which equipment slot this body part has.  The value of equip
  /// should be one of the `EQUIP_FOO` flags from iflags.d.  `EQUIP_NO_ARMOR`
  /// means that this body part does not accept any equipment slot.
  /// Regardless of the value of equip, if this body part `holds_items` any
  /// item can go on this body part's equipment slot.
  uint equip = 0x000;

  /// Determines which item is held by this body part.
  item held = No_item;

  /// A pointer to an array of body parts, such as head, tail, or limbs.
  /// A `null` pointer indicates that no further body parts branch out from
  /// this one, or that such body parts have been severed.
  Body* limbs[];

  /++
   + Removes a body part.
   +
   + This function goes through the array in `limbs` and removes the first one
   + whose `name` matches the input parameter `name`.
   +
   + This function performs a depth-first searh, meaning that each body part's
   + `limbs` is checked before the next `limb` in <em>this</em> body part is
   + checked.
   +
   + TODO:
   +   Figure out a way to get this function to drop items equipped on the
   +   severed body part and its limbs.
   +
   + Params:
   +   name    = The name of the body part to be severed.
   +
   + Returns:
   +   A `ubyte` determining the result of the operation.  If `ret & 0x01`,
   +   the limb was successfully severed.  If `ret & 0x02`, this kills the
   +   creature.  If neither of these results are true, the creature remains
   +   unscathed.
   +/
  ubyte sever_limb( string name )
  {
    if( limbs.length == 0 )  return 0x0;

    ubyte ret = 0x0;

    foreach( c; 0 .. limbs.length )
    {
      if( c == null )  continue;

      if( c.name == name )
      {
        if( c.vital )  ret |= 0x2;

        c = null;
        ret |= 0x1;

        return ret;
      }

      ret = c.sever_limb( name );

      if( ret != 0x0 )  return ret;
    } // foreach( c; 0 .. limbs.length )

    return ret;
  } // ubyte sever_limb( string )

} // class Body
