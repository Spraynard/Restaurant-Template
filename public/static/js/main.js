window.onload = function() {
	'use-strict';

	var loading_dock = document.getElementById('loading-dock');

	console.log( loading_dock );
	loading_dock.classList.remove('loading');

	var logoWrapper = document.getElementById('main-logo-wrapper');

	var logoStateTimeout = window.setTimeout(function( callback ) {
		logoWrapper.classList.add('fan-out');
		callback();
		window.clearTimeout( logoStateTimeout );
	}, 500, function() {
		logoStateTimeoutStageTwo = window.setTimeout(function() {
			logoWrapper.classList.remove('fan-out');
			window.clearTimeout( logoStateTimeoutStageTwo );
		}, 2000);
	});

	var currentBackgroundPosition = 0;
	var currentBackgroundPositionX = 0;

	var backgroundPositionInterval = 20; // 20 pixel interval
	var backgroundPositionXInterval = 1; // 1 pixel interval
	var siteNav = document.getElementById('main-site-nav');

	window.setInterval(function() {
		siteNav.style['background-position-y'] = '-' + currentBackgroundPosition + 'px';
		siteNav.style['background-position-x'] = currentBackgroundPositionX + 'px';
		currentBackgroundPosition += backgroundPositionInterval;

		if ( currentBackgroundPosition > 100 )
		{
			currentBackgroundPosition = 0;
		}
		currentBackgroundPositionX += 1;
		if ( currentBackgroundPositionX > window.innerWidth )
		{
			currentBackgroundPositionX = 0;
		}
	}, (1000 / 15)); // 15 frames per second.
};