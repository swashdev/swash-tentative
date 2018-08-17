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

// flags related to monster generation

// group generation

enum SOLITARY = 0;

// commonality

// This flag actually has nothing to do with how common the monster is, but
// instead is a special flag used to determine whether or not the player has
// heard of it before.  This property is also determined by the monster
// generation data, but is forced if this flag is set by either the
// UBIQUITOUS, VERY_COMMON, COMMON, or LEGENDARY flags.
enum FORCE_KNOWN = 0x100;

enum UBIQUITOUS  = 0x001 | FORCE_KNOWN;
enum VERY_COMMON = 0x002 | FORCE_KNOWN;
enum COMMON      = 0x004;
enum UNCOMMON    = 0x008;
enum RARE        = 0x010;
enum VERY_RARE   = 0x020;
// Note that UNHEARD_OF and LEGENDARY have the same value, except that
// LEGENDARY monsters are always known.
enum UNHEARD_OF  = 0x040;
enum LEGENDARY   = UNHEARD_OF | FORCE_KNOWN;

enum NO_GEN      = 0x080;

// environment

enum GEN_DUNGEONS  = 0x0001;
enum GEN_MOUNTAINS = 0x0002;
enum GEN_FORESTS   = 0x0004;
enum GEN_PLAINS    = 0x0008;
enum GEN_SWAMPS    = 0x0010;
enum GEN_DESERT    = 0x0020;
enum GEN_LAKE      = 0x0040;
enum GEN_OCEAN     = 0x0080;
enum GEN_TOWNS     = 0x0100;
enum GEN_ROADS     = 0x0200;
enum GEN_HOUSES    = 0x0400;

enum GEN_CIVILIZED = GEN_TOWNS | GEN_ROADS;
enum GEN_DOMESTIC  = GEN_TOWNS | GEN_HOUSES;
enum GEN_OVERWORLD = GEN_FORESTS | GEN_PLAINS | GEN_DESERT | GEN_ROADS;
