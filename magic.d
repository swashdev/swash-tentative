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
  /* TODO */
  return 100;
}

// Calcs the cost in spell points for the given spell based on its base
// properties
uint calc_spell_cost( uint effect, uint target, uint magnitude,
                      uint duration )
{
  /* TODO */
  return 0;
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
