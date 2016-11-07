// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

import $ from "jquery"
import "jquery"
import "bootstrap-datepicker"

global.jQuery = require("jquery") // Needed for bootstrap.
global.bootstrap = require("bootstrap")

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

$.fn.datepicker.defaults.format = "yyyy-mm-dd";
$.fn.datepicker.defaults.autoclose = true;
$.fn.datepicker.defaults.clearBtn = true;

$(document).ready(() => {
    $('.datepicker').datepicker();
})


// Elm setup

import Elm from './critter4us'

const ivDiv = document.querySelector('#iv-target');
if (ivDiv) {
    Elm.IV.embed(ivDiv);
}


const c4uDiv = document.querySelector('#c4u-target');
if (c4uDiv) {
    Elm.C4u.embed(c4uDiv, {authToken: window.auth_token});
}
