// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min-1-12-4.js
//= require jquery-ui.min-1.12.1.js
//= require jquery_ujs
//= require linkify.js
//= require_tree .
//= require jquery.remotipart

 window.onerror = function(message, url, lineNumber, columnNumber, error) {
      try {
		  var params = {
		      message: message,
		      stack: error.stack,
              url: url,
              lineNumber: lineNumber,
              columnNumber: columnNumber,
              location: window.location.href
          }
          util.emailErrors(JSON.stringify(params));
      } catch (e) {
        // Don't allow for infinitely recursively unhandled errors
        return true;
      }
    };