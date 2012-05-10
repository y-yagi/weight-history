$(function(){
	$.get('/history/data.json?callback=?', function(data) {
		// Create the chart  
    Highcharts.setOptions({
      global: {
        useUTC: false
      }
    }); 
		window.chart = new Highcharts.Chart({
			chart : {
				renderTo : 'graph-weight'
			},

			rangeSelector : {
				selected : 1
			}, 

			title : {
				text : 'weight history'
			}, 

      xAxis: {
        type: 'datetime', 
        dateTimeLabelFormats: {
        	day: '%m-%d',
	        week: '%m-%d'
        },
			  title: {
				  text: 'date'
        }
      }, 
		  yAxis: {
			  title: {
				  text: 'weight'
        }
			},   
      tooltip: {
          xDateFormat: '%Y-%m-%d',
          shared: true,
					yDecimals: 2
      },

			series : [{
				name : 'weight data',
				data : data["weight"]
			}]
		}); 

		window.chart = new Highcharts.Chart({
			chart : {
				renderTo : 'graph-body-fat'
			},

			rangeSelector : {
				selected : 1
			}, 

			title : {
				text : 'body fat percentage history'
			}, 

      xAxis: {
        type: 'datetime', 
        dateTimeLabelFormats: {
        	day: '%m-%d',
	        week: '%m-%d'
        },
			  title: {
				  text: 'date'
        }
      }, 
		  yAxis: {
			  title: {
				  text: 'body fat percentage'
        }
			},   
      tooltip: {
          xDateFormat: '%Y-%m-%d',
          shared: true,
					yDecimals: 2
      },

			series : [{
				name : 'body fat percentage data',
				data : data['body_fat_percentage']
			}]
		});
	}); 
});
