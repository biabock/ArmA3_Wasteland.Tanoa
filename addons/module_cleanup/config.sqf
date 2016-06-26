/*
*	The module_cleanUp configuration file.
*	You can change the variables below to whatever suits your mission best.
*
*	The radius is specified meters.
*	Timers are specified in seconds.
*/


///////////////////////////////
// Clean destroyed vehicles //
//////////////////////////////
pvpfw_cleanUp_vehicleRadius = 10; // Destroyed vehicles cleanup timer will start if no unit is closer than this
pvpfw_cleanUp_vehicleTimer = 300;

//////////////////
// Clean bodies //
//////////////////
pvpfw_cleanUp_bodyTimer = 600; // Bodies will be removed after the specified amount of seconds

/////////////////////////////////
//     Clean weaponholders     //
// weapons/magazines on ground //
/////////////////////////////////
#define __pvpfw_cleanUp_cleanWeaponHolders //comment out this line if you dont want weaponHolders to be cleaned up
pvpfw_cleanUp_weaponHolderRadius = 10; // The weaponholders cleanup countdown will start if no unit is closer than this
pvpfw_cleanUp_weaponHolderTimer = 180; // Weaponholders will be deleted after this time

///////////////////////////////
// Clean destroyed buildings //
///////////////////////////////
#define __pvpfw_cleanUp_cleanRuins //comment out this line if you dont want destroyed buildings to be cleaned up
pvpfw_cleanUp_ruinRadius = 50; // Destroyed Buildings will be deleted if no entity is in the specified range around them

// Advanced
//#define __pvpfw_cleanUp_cleanExtra //comment out this line if you dont need the objects below to be checked
pvpfw_cleanUp_chemLightTimer = 300; //effectively overrides the max "timeToLive" for the chemlight ammo object which is 900 seconds by default