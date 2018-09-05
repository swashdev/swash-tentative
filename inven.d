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

import global;

// defines the `Inven' struct, used for Inventories

/++
 + A struct for inventory items
 +
 + This is a simple struct used to represent an item in the inventory.
 + Actually all it is is an `Item` followed by a counter representing how many
 + of that Item are in the given Stack.
 +
 + Date:  2018-09-05
 +/
struct Stack
{
  Item i;
  uint count;
}

/++
 + The inventory
 +
 + This struct defines an inventory.  It contains an array of 40 `Stack`s of
 + `items` (14 for equipment slots followed by 26 more for a "bag"), and the
 + number of `coins` in the inventory.
 +
 + Date:  2018-09-05
 +/
struct Inven
{
  // all `Items' carried in this inventory; 14 "inventory slots" for the
  // various body parts, plus 26 for the "bag" (to be implemented)
  Stack[40] items; 
  uint coins;
}

// Special array indeces in the `items' array which correspond to the
// specific Inventory slots seen on the Inventory screen
enum INVENT_WEAPON    =  0;
enum INVENT_OFFHAND   =  1;
enum INVENT_QUIVER    =  2;
enum INVENT_HELMET    =  3;
enum INVENT_CUIRASS   =  4;
enum INVENT_PAULDRONS =  5;
enum INVENT_BRACERS   =  6;
enum INVENT_RINGL     =  7;
enum INVENT_RINGR     =  8;
enum INVENT_NECKLACE  =  9;
enum INVENT_GREAVES   = 10;
enum INVENT_KILT      = 11;
enum INVENT_FEET      = 12;
enum INVENT_TAIL      = 13;

enum INVENT_LAST_SLOT = INVENT_TAIL;

/++
 + Checks a given item against a given inventory equipment slot
 +
 + This function checks the given `Item` `i`'s equipment type against a given
 + equipment slot `s`.  The function returns `true` if the item can go in the
 + given inventory slot.
 +
 + The function will always return `true` if `s` represents one of the
 + character's hands (`INVENT_WEAPON` for the "weapon-hand" or
 + `INVENT_OFFHAND` for the "off-hand"), because any item can be carried in
 + one's hands.
 +
 + Params:
 +   i = an `Item` to be checked
 +   s = the index of the equipment slot to be checked
 +
 + Returns:
 +   `true` if i can be equipped in equipment slot s, `false` otherwise
 +/
bool check_equip( Item i, uint s )
{
  // an empty item can go in any slot (obviously)
  if( i.sym.ch == '\0' )
  { return true;
  }
  // the player can hold any item in their hands
  if( s == INVENT_WEAPON || s == INVENT_OFFHAND )
  { return true;
  }

  // everything else goes into the switch statement
  switch( s )
  {
    case INVENT_QUIVER:
      return cast(bool)i.type & ITEM_WEAPON_MISSILE;

    case INVENT_HELMET:
      return cast(bool)i.equip & EQUIP_HELMET;

    case INVENT_CUIRASS:
      // the "cuirass" item slot can accept either cuirasses or shields (the
      // player straps a shield to their back)
      return (i.equip & EQUIP_CUIRASS) || (i.equip & EQUIP_SHIELD);

    case INVENT_PAULDRONS:
      return cast(bool)i.equip & EQUIP_PAULDRONS;

    case INVENT_BRACERS:
      return cast(bool)i.equip & EQUIP_BRACERS;

    case INVENT_RINGL:
      // rings are obviously ambidexterous
    case INVENT_RINGR:
      return cast(bool)i.equip & EQUIP_JEWELERY_RING;

    case INVENT_NECKLACE:
      return cast(bool)i.equip & EQUIP_JEWELERY_NECK;

    case INVENT_GREAVES:
      return cast(bool)i.equip & EQUIP_GREAVES;

    case INVENT_KILT:
      return cast(bool)i.equip & EQUIP_KILT;

    case INVENT_FEET:
      return cast(bool)i.equip & EQUIP_FEET;

    case INVENT_TAIL:
      return cast(bool)i.equip & EQUIP_TAIL;

    default:
      return false;
  }
}

/++
 + Gets an item out of the given slot in the inventory
 +
 + This function gets a given `Item` from the given `Inven` without
 + modifying the contents of the `Inven`.
 +
 + This can be used for verifying what item is equipped in a given equipment
 + slot or what items are in the inventory, but is not useful if a monster
 + wants to drop or otherwise remove an item.
 +
 + Date:  2018-09-05
 +
 + See_Also:
 +   <a href="#get_stack">get_stack</a>,
 +   <a href="#pop_item">pop_item</a>,
 +   <a href="#pop_stack">pop_stack</a>
 +
 + Returns:
 +   An `Item` from `tory.items[index].i`
 +/
Item get_item( Inven tory, uint index )
{ return tory.items[index].i;
}

/++
 + Gets a stack of items out of the given slot in the inventory
 +
 + This function gets a given `Stack` from the given `Inven` without
 + modifying the contents of the `Inven`.
 +
 + This can be used for verifying what item is equipped in a given equipment
 + slot or what items are in the inventory, but is not useful if a monster
 + wants to drop or otherwise remove a stack of items.
 +
 + Date:  2018-09-05
 +
 + See_Also:
 +   <a href="#get_item">get_item</a>,
 +   <a href="#pop_stack">pop_stack</a>,
 +   <a href="#pop_item">pop_item</a>,
 +   <a href="#count_stack">count_stack</a>
 +
 + Returns:
 +   A `Stack` from `tory.items[index]`
 +/
Stack get_stack( Inven tory, uint index )
{ return tory.items[index];
}

/++
 + Pops an item out of the given stack in an inventory
 +
 + This function gets an `Item` from the given equipment slot from the given
 + inventory and removes one item from that slot.
 +
 + This can be used when a monster wants to drop or otherwise remove an item
 + from their inventory, but is not appropriate if we want to get rid of an
 + entire stack.
 +
 + Date:  2018-09-05
 +
 + See_Also:
 +   <a href="#get_item">get_item</a>,
 +   <a href="#get_stack">get_stack</a>,
 +   <a href="#pop_stack">pop_stack</a>
 +
 + Returns:
 +   An `Item` removed from `tory.items[index]`
 +/
Item pop_item( Inven tory, uint index )
{
  if( tory.items[index].count <= 0 )
  { return No_item;
  }

  tory.items[index].count--;
  return tory.items[index].i;
}

/++
 + Pops a stack out of the given inventory
 +
 + This function gets a `Stack` from the given equipment slot from the given
 + inventory and removes the stack from that slot.
 +
 + This can be used when a monster wants to drop or otherwise remove a stack
 + of items from their inventory, but is not appropriate if we only want to
 + get rid of one item.
 +
 + Date:  2018-09-05
 +
 + See_Also:
 +   <a href="#pop_item">pop_item</a>,
 +   <a href="#get_stack">get_stack</a>,
 +   <a href="#get_item">get_item</a>,
 +
 + Returns:
 +   An `Item` removed from `tory.items[index]`
 +/
Stack pop_stack( Inven tory, uint index )
{
  if( tory.items[index].i == No_item )
  { return Stack( No_item, 0 );
  }

  Stack ret = tory.items[index];

  tory.items[index] = Stack( No_item, 0 );

  return ret;
}

/++
 + Counts the number of items in a given stack in the given inventory
 +
 + Date:  2018-09-05
 +
 + Returns:
 +   `tory.items[index].count`, or 0 if the `Item` in the given `Stack` is
 +   `No_item`
 +/
uint count_stack( Inven tory, uint index )
{
  if( tory.items[index].i == No_item )
  { return 0;
  }

  return tory.items[index].count;
}
