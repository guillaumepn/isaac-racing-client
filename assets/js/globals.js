/*
    Global variables
*/

'use strict';

// Configuration
const domain     = 'isaacracing.net';
const secure     = true; // "true" for HTTPS/WSS and "false" for HTTP/WS
const fadeTime   = 300; // In milliseconds
const modName    = 'racing+_857628390'; // This is the name of the folder for the Racing+ Lua mod after it is downloaded through Steam
const modNameDev = 'racing+_dev'; // The folder has to be named differently in development or else Steam will automatically delete it
const order9     = [14, 10, 4, 6, 11, 5, 2, 3, 7]; // For the R+9 speedrun category; numbers correspond to the Lua character enums
const order14    = [14, 10, 4, 6, 11, 5, 2, 3, 7, 1, 0, 13, 15, 9]; // For the R+14 speedrun category; numbers correspond to the Lua character enums

// Imports
const isDev = nodeRequire('electron-is-dev');

// The object that contains all of the global variables
module.exports = {
    autoUpdateStatus: null,
    builds: null,
    conn: null,
    currentScreen: 'title-ajax', // We always start on the title-ajax screen
    currentRaceID: false, // Equal to false or the ID of the race (as an integer)
    defaultLogFilePath: '',
    domain: domain,
    emoteList: [], // Filled in main.js
    fadeTime: fadeTime,
    gameState: {
        inGame: false, // The log will tell us if we are in the menu or in a run
        hardMode: false, // The log will tell us if a run is started on hard mode or Greed mode
        challenge: false, // The log will tell us if a run is started on a challenge
        wrongCharacter: false, // The log will tell us if we are on the wrong character
    },
    initError: null, // Filled in main.js (only if there is an error)
    itemList: {}, // Filled in main.js
    lastPM: null,
    log: null,
    lang: null, // The language switcher instance
    modLoader: {
        status: 'none',
        myStatus: 'not ready',
        rType: 'unranked',
        solo: false,
        rFormat: 'unseeded',
        character: 'Judas',
        goal: 'Blue Baby',
        seed: '-',
        startingBuild: -1,
        countdown: -1,
        placeMid: 0,
        place: 1,
        // order9-1, order14-1, order9-2, order14-2, order9-3, and order14-3 will be filled in in main.js
    },
    modName: modName,
    modNameDev: modNameDev,
    modPath: null, // Set in main.js
    myUsername: null,
    order9: order9,
    order14: order14,
    playingSound: false,
    Raven: null, // Raven (Sentry logging) has to be a global or else it won't be initialized in other JavaScript files
    roomList: {},
    raceList: {},
    secure: secure,
    spamTimer: new Date().getTime(),
    steam: {
        id: null,
        screenName: null,
        ticket: null,
    },
    stream: {
        URL: '',
        URLBeforeTyping: '',
        URLBeforeSubmit: '',
        TwitchBotEnabled: null,
        TwitchBotDelay: null,
    },
    tabCompleteCounter: 0,
	tabCompleteIndex: 0,
	tabCompleteWordList: null,
    timeLaunched: new Date().getTime(),
    timeOffset: 0,
    trinketList: {}, // Filled in main.js
    wordList: null, // Filled in main.js
};

/*
    By default, we start on the title screen.
    currentScreen can be the following:
    - title-ajax
    - tutorial1
    - tutorial2
    - login
    - login-ajax
    - forgot
    - forgot-ajax
    - register
    - register-ajax
    - updating
    - lobby
    - race
    - error
    - warning
    - waiting-for-server
    - transition
    - null (a blank screen)
*/
