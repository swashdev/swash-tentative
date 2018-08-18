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

// magicfx.d: Defines flags for determining spell effects and other attributes
// of spells.  For defining actual spells, see ``magic.d''

import global;

//////////////////////////
// Spell Target Options //
//////////////////////////

// These flags determine what kind of spell it is; i.e. projectile, shielding,
// targeted-at-self, etcetera.

// The spell instantaneously affects the caster
enum TARGET_AT_SELF = 0;

// The spell instantaneously forms a shield around the caster
enum SHIELD         = 1;

// The spell instantaneously places a ward on a spot next to the caster
enum WARD           = 2;

// The spell affects the next monster the caster touches
enum TOUCH          = 3;

// The spell fires a projectile that impacts the first monster it touches
enum PROJECTILE     = 4;

// The spell fires a projectile that explodes on impact with a monster or wall
enum EXPLOSION      = 5;

// The spell fires a beam that impacts all characters in its path until it
// touches a wall or is absorbed
enum BEAM           = 6;

// The spell instantaneously affects a targeted monster
enum LINE_OF_SIGHT  = 7;

// The spell instantaneously affects a targeted area; if the spell duration is
// greater than 0, the area of effect will persist.
// AFFECT_AREA must be greater than the other magic effect flags, because the
// formula (X - AFFECT_AREA), where X is the number given for the magic effect
// flag, is used to determine the radius of the effect.
enum AFFECT_AREA    = 8;

///////////////////
// Spell Effects //
///////////////////

// These flags determine the actual effect of the spell.

// Healing Magic
///////////////////

/// This flag determines that the spell effect is governed by healing magic
enum HEALING_EFFECT = 0x1000;

enum RESTORE_HEALTH  = HEALING_EFFECT | 0x0001;
enum RESTORE_STAMINA = HEALING_EFFECT | 0x0002;
enum CURE_POISON     = HEALING_EFFECT | 0x0004;
enum CURE_DISEASE    = HEALING_EFFECT | 0x0008;
enum REMOVE_CURSE    = HEALING_EFFECT | 0x0010;
enum PROTECTION      = HEALING_EFFECT | 0x0020;
enum CURE_PARALYSIS  = HEALING_EFFECT | 0x0040;

// Thaumaturgy
/////////////////

/// This flag determines that the spell effect is governed by thaumaturgy
enum THAUMATURGY_EFFECT = 0x2000;

enum WATER_WALKING   = THAUMATURGY_EFFECT | 0x0001;
enum WATER_BREATHING = THAUMATURGY_EFFECT | 0x0002;
enum LEVITATE        = THAUMATURGY_EFFECT | 0x0004;
enum DISENTANGLE     = THAUMATURGY_EFFECT | 0x0008;
enum INVISIBILITY    = THAUMATURGY_EFFECT | 0x0010;
enum TURN_UNDEAD     = THAUMATURGY_EFFECT | 0x0020;
enum BANISH_UNDEAD   = THAUMATURGY_EFFECT | 0x0040;
enum BANISH_DEMON    = THAUMATURGY_EFFECT | 0x0080;
enum SUMMON_FAMILIAR = THAUMATURGY_EFFECT | 0x0100;
enum TELEKINESIS     = THAUMATURGY_EFFECT | 0x0200;
enum IDENTIFY_ITEM   = THAUMATURGY_EFFECT | 0x0400;
enum WISH_FOR_ITEM   = THAUMATURGY_EFFECT | 0x0800;

// Offensive
///////////////

/// This flag determines that the spell effect is govened by offensive magic
enum OFFENSIVE_EFFECT = 0x4000;

enum FIRE            = OFFENSIVE_EFFECT | 0x0001;
enum THUNDER         = OFFENSIVE_EFFECT | 0x0002;
enum WIND            = OFFENSIVE_EFFECT | 0x0004;
enum ICE             = OFFENSIVE_EFFECT | 0x0008;
enum VENOM           = OFFENSIVE_EFFECT | 0x0010;
enum ACID            = OFFENSIVE_EFFECT | 0x0020;
enum THORNS          = OFFENSIVE_EFFECT | 0x0040;
enum NECROTIZE       = OFFENSIVE_EFFECT | 0x0080;
enum PARALYZE        = OFFENSIVE_EFFECT | 0x0100;
enum BLIND           = OFFENSIVE_EFFECT | 0x0200;

// Charm
///////////

/// This flag determines that the spell effect is governed by charm magic
enum CHARM_EFFECT = 0x8000;

enum PACIFY          = CHARM_EFFECT | 0x0001;
enum ENCOURAGE       = CHARM_EFFECT | 0x0002;
enum ENRAGE          = CHARM_EFFECT | 0x0004;
enum BETRAY          = CHARM_EFFECT | 0x0008;
enum FEAR            = CHARM_EFFECT | 0x0010;
enum HYPNOTIZE       = CHARM_EFFECT | 0x0020;
