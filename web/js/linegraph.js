    /* implementation heavily influenced by http://bl.ocks.org/1166403 */
    /* some arguments AGAINST the use of dual-scaled axes line graphs can be found at http://www.perceptualedge.com/articles/visual_business_intelligence/dual-scaled_axes.pdf */

    // define dimensions of graph
    var m = [40, 30, 80, 40]; // margins
    var w = 1300 - m[1] - m[3];	// width
    var h = 700 - m[0] - m[2]; // height

    // create a simple data array that we'll plot with a line (this array represents only the Y values, X will just be the index location)
    var data1 = [4,6,5,4,3,5,3,3,3,2,3,5,6,3,4,4,4,4,4,5,4,5,5,3,4,2,3,4,3,6,1,3,4,1,4,2,2,5,3,3,4,4,5,6,4,3,7,6,10,9,11,14,1,6,6,14,12,4,5,7, 4,8,15,14,18,11,4,12,19,22,19,34,2,1,5];
    var data2 = [543, 367, 215, 56, 65, 62, 87, 156, 287, 398, 523, 685, 652, 674, 639, 619, 589, 558, 605, 574, 564, 496, 525, 476, 432, 458, 421, 387, 375, 368];

    // /get_today_people_count
    // http://150.165.85.12:41205/get_people_current_status

    // X scale will fit all values from data[] within pixels 0-w
    var x = d3.scale.linear().domain([0, data1.length]).range([0, w]);
    // Y scale will fit values from 0-10 within pixels h-0 (Note the inverted domain for the y-scale: bigger is up!)

    var y1 = d3.scale.linear().domain([0, 40]).range([h, 0]); 
        // in real world the domain would be dynamically calculated from the data
    

    var y2 = d3.scale.linear().domain([0, 700]).range([h, 0]);  
        // in real world the domain would be dynamically calculated from the data

        // automatically determining max range can work something like this
        // var y = d3.scale.linear().domain([0, d3.max(data)]).range([h, 0]);


    // create a line function that can convert data[] into x and y points
    var line1 = d3.svg.line()
        // assign the X function to plot our line as we wish
        .x(function(d,i) { 
            // verbose logging to show what's actually being done
            console.log('Plotting X1 value for data point: ' + d + ' using index: ' + i + ' to be at: ' + x(i) + ' using our xScale.');
            // return the X coordinate where we want to plot this datapoint
            return x(i); 
        })
        .y(function(d) { 
            // verbose logging to show what's actually being done
            console.log('Plotting Y1 value for data point: ' + d + ' to be at: ' + y1(d) + " using our y1Scale.");
            // return the Y coordinate where we want to plot this datapoint
            return y1(d); 
        })

    // create a line function that can convert data[] into x and y points
    var line2 = d3.svg.line()
        // assign the X function to plot our line as we wish
        .x(function(d,i) { 
            // verbose logging to show what's actually being done
            console.log('Plotting X2 value for data point: ' + d + ' using index: ' + i + ' to be at: ' + x(i) + ' using our xScale.');
            // return the X coordinate where we want to plot this datapoint
            return x(i); 
        })
        .y(function(d) { 
            // verbose logging to show what's actually being done
            console.log('Plotting Y2 value for data point: ' + d + ' to be at: ' + y2(d) + " using our y2Scale.");
            // return the Y coordinate where we want to plot this datapoint
            return y2(d); 
        })


        // Add an SVG element with the desired dimensions and margin.
        var graph = d3.select("#graph").append("svg:svg")
              .attr("width", w + m[1] + m[3])
              .attr("height", h + m[0] + m[2])
            .append("svg:g")
              .attr("transform", "translate(" + m[3] + "," + m[0] + ")");

        // create yAxis
        var xAxis = d3.svg.axis().scale(x).tickSize(-h).tickSubdivide(true);
        // Add the x-axis.
        graph.append("svg:g")
              .attr("class", "x axis")
              .attr("transform", "translate(0," + h + ")")
              .call(xAxis);


        // create left yAxis
        var yAxisLeft = d3.svg.axis().scale(y1).ticks(4).orient("left");
        // Add the y-axis to the left
        graph.append("svg:g")
              .attr("class", "y axis axisLeft")
              .attr("transform", "translate(-15,0)")
              .call(yAxisLeft);


        // add lines
        // do this AFTER the axes above so that the line is above the tick-lines
        graph.append("svg:path").attr("d", line1(data1)).attr("class", "data1");
        graph.append("svg:path").attr("d", line2(data2)).attr("class", "data2");