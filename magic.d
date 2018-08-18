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

// magic.d: Structs and functions for defining and using magic spells

import global;

struct Spell
{
  // Base spell properties //
  ///////////////////////////

  // These "base spell properties" are the meat and potatoes of the spell

  // What spell effect does this spell use? (from ``magicfx.d'')
  uint effect;

  // How does the spell use this effect? (from ``magicfx.d'')
  uint target;

  // What's the magnitude of the spell?  This could be damage, total hit
  // points healed, etcetera.  Not used if not relevant for the given magic
  // effect.  This number is smaller for Large monsters, and obviously does
  // not include resistances.
  uint magnitude;

  // How long does the spell last in rounds?  If this is greater than zero,
  // the above `magnitude' will be repeated for every round the spell is
  // active.  This will really hurt.  (calculated for a level one character)
  uint duration;

  // Derivative spell properties //
  /////////////////////////////////

  // These spell properties are calculated based on the base spell properties

  // What's the probability of success? (as a percentage, calculated for a
  // level 1 character)
  ubyte chance;

  // How many spell points does this spell cost?  (calculated for a level 1
  // character)
  uint cost;

  // Enchantment properties //
  ////////////////////////////

  // These properties are used only for enchantments on items, not on spells

  // In the event that this spell is being used for an item enchantment, this
  // boolean determines whether or not that enchantment comes from a demon
  // that is posessing the item.  In that case, when the item becomes broken
  // or otherwise unenchanted, a demon is spawned.
  bool posessed;
} // struct Spell

// Calcs the chance of success for the given spell based on its base
// properties
ubyte calc_spell_chance( uint effect, uint target, uint magnitude,
                         uint duration )
{
  // XXX: The numbers here are essentially placeholders and require testing
  // for balance.
  uint base_chance = 50;

  if( target !in [TARGET_AT_SELF, SHIELD, WARD] )
  { base_chance -= 20;
  }
  if( target >= AREA_EFFECT )
  {
    if( base_chance > (1 + (target - AREA_EFFECT)) )
    { base_chance -= 1 + (target - AREA_EFFECT);
    }
    else
    {
      base_chance = 1;
      goto adjust_base_chance;
    }
  }

  if( base_chance == 0 )
  { goto adjust_base_chance;
  }

  if( base_chance < magnitude )
  {
    base_chance = 1;
    goto adjust_base_chance;
  }

  if( magnitude > 40 )
  { base_chance -= 40;
  }
  else
  { base_chance -= magnitude;
  }

  if( base_chance == 0 )
  { goto adjust_base_chance;
  }

  if( base_chance > duration )
  { base_chance -= duration;
  }
  else
  { base_chance = 1;
  }

adjust_base_chance:
  if( base_chance == 0 )
  { base_chance = 1;
  }

  if( base_chance < 100 )
  { base_chance *= 10;
  }

  // Switch Statement From Hell divides the base chance by a certain number
  // based on what effect specifically is being used:
  switch( effect )
  {
    default:
      return 0;

    // Healing magic effects

    case RESTORE_STAMINA:
    case PROTECTION:
      // These effects have no special base chance, always give them the max
      // of the above-calculated number.
      return base_chance;

    case RESTORE_HEALTH:
      base_chance *= 0.9;
      break;

    case CURE_POISON:
      base_chance *= 0.8;
      break;

    case CURE_DISEASE:
      base_chance *= 0.6;
      break;

    case REMOVE_CURSE:
      base_chance *= 0.65;
      break;

    case CURE_PARALYSIS:
      base_chance *= 0.75;
      break;

    // Thaumaturgy magic

    case WATER_WALKING:
      base_chance *= 0.75;
      break;

    case WATER_BREATHING:
      base_chance *= 0.5;
      break;

    case LEVITATE:
      base_chance *= 0.7;
      break;

    case DISENTANGLE:
      base_chance *= 0.8;
      break;

    case INVISIBILITY:
      base_chance *= 0.4;
      break;

    case TURN_UNDEAD:
      base_chance *= 0.35;
      break;

    case BANISH_UNDEAD:
      base_chance *= 0.25;
      break;

    case BANISH_DEMON:
      base_chance *= 0.15;
      break;

    case SUMMON_FAMILIAR:
      base_chance *= 0.6;
      break;

    case TELEKINESIS:
      base_chance *= 0.7;
      break;

    case IDENTIFY_ITEM:
    case WISH_FOR_ITEM:
      base_chance *= 0.1;
      break;

    // Offensive magic effects

    case WIND:
      return base_chance;

    case FIRE:
    case ICE:
      base_chance *= 0.9;
      break;

    case THUNDER:
      base_chance *= 0.8;
      break;

    case VENOM:
    case ACID:
      base_chance *= 0.75;
      break;

    case THORNS:
      base_chance *= 0.6;
      break;

    case NECROTIZE:
      base_chance *= 0.4;
      break;

    case PARALYZE:
      base_chance *= 0.75;
      break;

    case BLIND:
      base_chance *= 0.5;
      break;

    // Charm magic effects

    case PACIFY:
      base_chance *= 0.5;
      break;

    case ENCOURAGE:
      base_chance *= 0.65;
      break;

    case ENRAGE:
      base_chance *= 0.4;
      break;

    case BETRAY:
      base_chance *= 0.25;
      break;

    case FEAR:
      base_chance *= 0.3;
      break;

    case HYPNOTIZE:
      base_chance *= 0.1;
      break;
  }

  if( base_chance > 100 )
  { return 100;
  }

  if( base_chance == 0 )
  { return 1;
  }

  return base_chance;
}

// Calcs the cost in spell points for the given spell based on its base
// properties
uint calc_spell_cost( uint effect, uint target, uint magnitude,
                      uint duration )
{
  // XXX: The numbers here are essentially placeholders and require testing
  // for balance.
  uint base_cost = 1;

  if( target !in [TARGET_AT_SELF, SHIELD, TOUCH] )
  {
    if( target >= AREA_EFFECT )
    { base_cost = (1 + target - AREA_EFFECT) * 10;
    }
    else
    { base_cost = 10;
    }
  }
  else if( target == TOUCH && (effect & OFFENSIVE_EFFECT) )
  { base_cost = 5;
  }
  else if( target == SHIELD && effect != PROTECTION )
  {
    if( !(effect & OFFENSIVE_EFFECT) )
    { base_cost = 20;
    }
    else if( effect == THUNDER )
    { base_cost = 7;
    }
    else if( effect == THORNS )
    { base_cost = 10;
    }
    else
    { base_cost = 5;
    }
  }

  base_cost *= (magnitude + duration);

  return base_cost;
}

Spell new_spell( uint effect, uint target, uint magnitude, uint duration )
{
  Spell ret;

  ret.effect    = effect;
  ret.target    = target;
  ret.magnitude = magnitude;
  ret.duration  = duration;

  ret.chance = calc_spell_chance( effect, target, magnitude, duration );
  ret.cost = calc_spell_cost( effect, target, magnitude, duration );

  ret.posessed = false;
}

Spell new_enchantment( uint effect, uint target, uint magnitude,
                       uint duration, bool posessed )
{
  Spell ret;

  ret.effect    = effect;
  ret.target    = target;
  ret.magnitude = magnitude;
  ret.duration  = duration;

  ret.cost = 0;
  ret.chance = 100;

  ret.posessed = posessed;
  return ret;
}

Spell enchantment_from_spell( Spell spell, bool posessed )
{
  Spell ret = spell;

  ret.cost = 0;
  ret.chance = 100;

  ret.posessed = posessed;

  return ret;
}
