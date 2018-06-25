function obtainRandomVector( xMax, yMax )
{
	// Randomly select whether or not we are going
	// to have a negative number.
	var xSign = ( Math.random() >= .50 ) ? 1 : -1;
	var ySign = ( Math.random() >= .50 ) ? 1 : -1;

	return [
		Math.ceil(Math.random() * ( xSign * xMax)),
		Math.ceil(Math.random() * ( ySign * yMax))
	];
}

window.onload = function() {
	'use-strict';

	var loading_dock = document.getElementById('loading-dock');

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

	var background_y = 0;
	var background_x = 0;

	var background_y_interval = 20; // 20 pixel interval
	var background_x_interval = 3; // 1 pixel interval
	var background_x_limit = 20;
	var background_coordinate_origin = 1;
	var siteNav = document.getElementById('main-site-nav');

	window.setInterval(function() {
		siteNav.style['background-position-y'] = '-' + background_y + 'px';
		siteNav.style['background-position-x'] = background_x + 'px';

		background_y += background_y_interval;

		if ( background_y > 100 )
		{
			background_y = 0;
		}

		/**
		 * This block alternates between shifting the background right to left.
		 */
		if ( background_coordinate_origin === 1 )
		{
			background_x += background_x_interval;

			if ( background_x >= background_x_limit )
			{
				background_coordinate_origin = -1;
			}
		} else if ( background_coordinate_origin === -1 ) {

			background_x -= background_x_interval;

			if ( background_x <= ( -1 * background_x_limit ) )
			{
				background_coordinate_origin = 1;
			}
		}

		if ( background_x > window.innerWidth )
		{
			background_x = 0;
		}
	}, (1000 / 15)); // 15 frames per second.

	var menuItemArray = document.getElementsByClassName('menu-item');
	var menuItem = null;

	for ( var i = 0; i < menuItemArray.length; i++ )
	{
		menuItem = menuItemArray[i];

		// console.log( menuItem );
		menuItem.addEventListener('mouseenter', function() {
			var numberItemsArray = this.getElementsByClassName('number');

			for ( var j = 0; j < numberItemsArray.length; j++ )
			{
				var numberItem = numberItemsArray[j];
				var vector = obtainRandomVector(5, 5);

				numberItem.style.transform = 'translate3d(' + vector[0] + 'px, ' + vector[1] + 'px, 0)';

				(function( outerItem ) {
					var numberItemTimeout = window.setTimeout(function( item ) {
						item.style.transform = 'translate3d(0,0,0)';
						window.clearTimeout( numberItemTimeout );
					}, 250, outerItem );
				})( numberItem );
				// move the number by the vector, then reset it back after a period.

			}
		});
	}
};