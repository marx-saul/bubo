/**
 * identifier.d
 * Defines the struct 'Identifier'
 */
module identifier;

import token: Location;

struct Identifier {
	Location loc;
	string name;
}