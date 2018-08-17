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

// flags related to items

enum NO_ITEM = 0x0;

// item type

enum ITEM_INVALID         = 0x0000;
enum ITEM_WEAPON          = 0x0001;
enum ITEM_WEAPON_LARGE    = 0x0003;
enum ITEM_WEAPON_LAUNCHER = 0x0007;
enum ITEM_WEAPON_MISSILE  = 0x0009;
enum ITEM_TOOL            = 0x0010;
enum ITEM_FOOD            = 0x0020;
enum ITEM_DRINK           = 0x0040;
enum ITEM_SCROLL          = 0x0080;
enum ITEM_BOOK            = 0x0100;
enum ITEM_ARMOR           = 0x0200;
enum ITEM_JEWELERY        = 0x0400;
enum ITEM_COIN            = 0x0800;
enum ITEM_REAGENT         = 0x1000;

// equip areas (for armor)

enum EQUIP_NO_ARMOR       = 0x000;
enum EQUIP_SHIELD         = 0x001;
enum EQUIP_HELMET         = 0x002;
enum EQUIP_CUIRASS        = 0x004;
enum EQUIP_PAULDRONS      = 0x008;
enum EQUIP_GLOVES         = 0x010;
enum EQUIP_BRACERS        = 0x020;
enum EQUIP_GREAVES        = 0x040;
enum EQUIP_KILT           = 0X080;
enum EQUIP_FEET           = 0x100;
enum EQUIP_TAIL           = 0x200;
enum EQUIP_JEWELERY_RING  = 0x400;
enum EQUIP_JEWELERY_NECK  = 0x800;

// weapon class

// Note that WEAPON_IMPROVISED is 0, which is the default value.  Any item
// which isn't a weapon will qualify as WEAPON_IMPROVISED.
enum WEAPON_IMPROVISED    = 0x0000;
enum WEAPON_CLUB          = 0x0001;
enum WEAPON_HAMMER        = 0x0002;
enum WEAPON_AXE           = 0x0004;
enum WEAPON_SPEAR         = 0x0008;
enum WEAPON_SWORD         = 0x0010;
enum WEAPON_POLEARM       = 0x0020;
enum WEAPON_DAGGER        = 0x0040;
enum WEAPON_KNIFE         = 0x0080;
enum WEAPON_BOW           = 0x0100;
enum WEAPON_CROSSBOW      = 0x0200;
enum WEAPON_THROWN_KNIFE  = 0x0400;
enum WEAPON_SHURIKEN      = 0x0800;
enum WEAPON_BOOMERANG     = 0x1000;
enum WEAPON_BALL_SECRET   = 0x2000;

// weapon damage

// BASH, used for heavy blunt weapons (any item can be used as an "improvised"
// blunt weapon, but weapons with the BLUNT flag do more damage)
enum BASH                 = 0x0001;
// HACK, used for heavy-bladed penetrating weapons like axes and polearms
enum HACK                 = 0x0002;
// SLASH, used for slashing weapons like swords and knives
enum SLASH                = 0x0004;
// PARRY, used for weapons which can be used for parrying, like swords and
// polearms
enum PARRY                = 0x0008;
// PIERCE, used for piercing weapons like spears, swords, and polearms
enum PIERCE               = 0x0010;
// Used for thrusting weapons, which can be used to reach long distances.
enum THRUST               = 0x0020;
// Used for "long" weapons, which can _only_ reach long distances.
enum LONG                 = 0x0040;

// SWASH is a shorthand for "swashbuckling" weapons, typically swords.
enum SWASH = SLASH | PARRY | PIERCE | THRUST;
