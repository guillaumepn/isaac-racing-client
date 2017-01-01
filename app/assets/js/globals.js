/*
    Global variables
*/

'use strict';

// Configuration
const domain       = 'isaacracing.net';
const secure       = true; // "true" for HTTPS/WSS and "false" for HTTP/WS
const squirrelPort = 8443; // The port that the squirrel-updates-server runs on
const fadeTime     = 300; // In milliseconds

// The object that contains all of the global variables
module.exports = {
    autoUpdateStatus: null,
    domain: domain,
    conn: null,
    currentScreen: 'title', // We always start on the title screen
    currentRaceID: false, // Equal to false or the ID of the race (as an integer)
    fadeTime: fadeTime,
    initiatedLogout: false,
    lastIPC: null,
    log: null,
    lang: null, // The language switcher instance
    logMonitoringProgram: null,
    myUsername: null,
    myStream: null,
    myTwitchBotEnabled: null,
    myTwitchBotDelay: null,
    playingSound: false,
    roomList: {},
    raceList: {},
    secure: secure,
    spamTimer: new Date().getTime(),
    timeLaunched: new Date().getTime(),
    timeOffset: 0,
    wordList: null, // Set in main.js
	emoteList: null, // Set in main.js
	tabCompleteCounter: 0,
	tabCompleteIndex: 0,
	tabCompleteWordList: null,
};

/*
    By default, we start on the title screen.
    currentScreen can be the following:
    - title
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
