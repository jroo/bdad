LAST_MOVE = null;
FIRST_X = null;
FIRST_Y = null;
PATH = "";
DRAWING = {'state':null, 'district':null, 'transform':{'factor':null, 'x_offset':null, 'y_offset':null, 'scale':null}, 'path_list':[]};
DUMMY_TOKEN = 'jroo-test' + Math.random();

DEBUG = false;
DOMAIN = '10.13.30.253:3000';

CANVAS_WIDTH = 640;
CANVAS_HEIGHT = 480;

$('document').ready(function() {
    initializeStateList();
    
    var isDown = false;
    
    //set up hotkeys
    $(document).bind('keydown', 'ctrl+z', function() { undo(MAIN_CANVAS) });
    
    //initialize map canvas
    $("#map_container").width(CANVAS_WIDTH);
    $("#map_container").height(CANVAS_HEIGHT);
    
    MAP_CANVAS = new Raphael(document.getElementById('map_container'), CANVAS_WIDTH, CANVAS_HEIGHT);
    
    //initialize main canvas
    $("#canvas_container").width(CANVAS_WIDTH);
    $("#canvas_container").height(CANVAS_HEIGHT);

    MAIN_CANVAS = new Raphael(document.getElementById('canvas_container'), CANVAS_WIDTH, CANVAS_HEIGHT);
    $("#canvas_container").mousemove(function(e) {
        if(isDown) {
            var x = e.pageX - this.offsetLeft;
            var y = e.pageY - this.offsetTop;
            registerPoint(MAIN_CANVAS, x, y);
        }
    });
    $("#canvas_container").mousedown(function(e) {
        document.body.style.cursor = 'crosshair';
        isDown = true;
    });
    $("#canvas_container").mouseup(function() {
        document.body.style.cursor = 'default';
        isDown = false;
        saveShape(MAIN_CANVAS, PATH);
    });

});

function debug(debug_str) {
    if (DEBUG) {
        $('#debug').html(debug_str);
    }
}

function registerPoint(canvas, x, y) {
    if (LAST_MOVE == "M") {
        PATH = PATH + "L" + x + " " + y;
    } else {
        PATH = PATH + "M" + x + " " + y;
        FIRST_X = x;
        FIRST_Y = y;
        LAST_MOVE = "M";
    }
    drawPath(canvas, PATH);
}

function saveShape(canvas, path) {
    DRAWING.path_list.push(path + "z");
    drawPath(canvas, path);
    LAST_MOVE = null;
    FIRST_X = null;
    FIRST_Y = null;
    PATH = "";
}

function saveDrawing(drawing) {
    descaled_paths = descalePaths(drawing.path_list, drawing.transform);
    d = { 'map':descaled_paths };
    url = 'http://' + DOMAIN + '/screen_data/';
    t = DUMMY_TOKEN;
    data = { 'd':d, 't':t }
    $.post(url, data, function(data) {
    }, "json");
}

function drawPath(canvas, path) {
    canvas.clear();
    for (i in DRAWING.path_list) {
        this_shape = canvas.path(DRAWING.path_list[i]);
        this_shape.attr({'stroke-width':3, 'fill':'#FFCCCC', 'opacity':0.2});
    }
    drawing = canvas.path(PATH);
    drawing.attr({'stroke-width':3, 'fill':'#FFCCCC', 'opacity':0.2});
    debug(PATH);
}

function clearPath(canvas) {
    DRAWING.path_list = [];
    PATH = "";
    LAST_MOVE = null;
    canvas.clear();
    debug('');
}

function undo(canvas) {
    path=null;
    DRAWING.path_list.pop();
    drawPath(canvas, path);
}

function initializeStateList() {
    $('#state_select')
        .find('option')
        .remove()
        .end();
    $('#state_select').
        append($("<option></option>").
        attr("value", null).
        text(''));
    for (i in STATES.features) {
         $('#state_select').
          append($("<option></option>").
          attr("value", STATES.features[i].attributes.state).
          text(STATES.features[i].attributes.name));
    }
    select = document.getElementById('state_select');
    select.onchange = function() {
        populateDistricts(this.value);
    }

}

function populateDistricts(state_value) {
    district_list = STATES.features[state_value.toString()].attributes.districts;
    $('#district_select')
        .find('option')
        .remove()
        .end();
    for (i in district_list) {
        district = district_list[i].replace(state_value, '');
        district_value = state_value + "," + district;
        $('#district_select').
            append($("<option></option>").
            attr("value", district_value).
            text(district));
    }
    select = document.getElementById('district_select');
    select.onchange = function() {
        drawDistrict(this.value);
    }
}

function scalePaths(paths, x_factor, y_factor, x_offset, y_offset, scale) {
    factor = Math.min(x_factor, y_factor);
    positioned_paths = [];
    for (i in paths) {
        coord_array = pathToArray(paths[i]);
        for (j in coord_array) {
            coord_array[j].x = (coord_array[j].x + x_offset);
            coord_array[j].y = (coord_array[j].y + y_offset);         
        }
        positioned_paths.push(coord_array);
    }
    
    scaled_paths = [];
    for (i in positioned_paths) {
        coord_array = positioned_paths[i];
        for (j in coord_array) {
            coord_array[j].x = ((coord_array[j].x - (CANVAS_WIDTH / 2)) * factor * scale) + (CANVAS_WIDTH / 2);
            coord_array[j].y = ((coord_array[j].y - (CANVAS_HEIGHT / 2)) * factor * scale) + (CANVAS_HEIGHT / 2);
        }
        scaled_paths.push(arrayToPath(coord_array));
    }
    return({'attr':{'factor':factor, 'x_offset':x_offset, 'y_offset':y_offset, 'scale':scale}, 'paths':scaled_paths});
}

function descalePaths(scaled_paths, transform) {
    //descale
    refactor = 1/(transform.factor * transform.scale)
    var descaled_paths = [];
    for (i in scaled_paths) {
        coord_array = pathToArray(scaled_paths[i]);
        for (j in coord_array) {  
            coord_array[j].x = parseInt(((coord_array[j].x - (CANVAS_WIDTH / 2)) * refactor) + (CANVAS_WIDTH / 2));
            coord_array[j].y = parseInt(((coord_array[j].y - (CANVAS_HEIGHT / 2)) * refactor) + (CANVAS_HEIGHT / 2));
        }
        descaled_paths.push(coord_array);
    }
    
    var positioned_paths = [];
    for (i in descaled_paths) {
        coord_array = descaled_paths[i];
        for (j in coord_array) {
            coord_array[j].x = coord_array[j].x - transform.x_offset;
            coord_array[j].y = coord_array[j].y - transform.y_offset;
        }
        positioned_paths.push(arrayToPath(coord_array));
    }
    return(positioned_paths);
}

function drawDistrict(district_string) {
    dist_arr = district_string.split(',');
    state_id = dist_arr[0];
    district_id = dist_arr[0] + dist_arr[1];
    district = STATES.features[state_id.toString()].attributes.districts
    bounds = DISTRICTS.features[district_id.toString()].bounds;
    paths = DISTRICTS.features[district_id.toString()].paths;
    mid_x = (bounds.minX + bounds.maxX) / 2;
    mid_y = (bounds.minY + bounds.maxY) / 2;
    x_offset = (CANVAS_WIDTH / 2) - mid_x;
    y_offset = (CANVAS_HEIGHT / 2) - mid_y;
    width = bounds.maxX - bounds.minX;
    height = bounds.maxY - bounds.minY;
    x_factor = CANVAS_WIDTH / width;
    y_factor = CANVAS_HEIGHT / height;
    var new_paths = scalePaths(paths, x_factor, y_factor, x_offset, y_offset, 0.6);
    DRAWING.transform = new_paths.attr;
    drawSVG(MAP_CANVAS, new_paths.paths);
}

function drawSVG(canvas, paths) {
    canvas.clear();
    for (i in paths) {
        m = canvas.path(paths[i]);
        m.attr({'fill':'#CCCCFF'});
    }
}

//convert svg path to array of node elements
function pathToArray(path) {
    //definitely a more elegant way to handle this
    path_array = [];
    arr = path.split('L');
    for (i in arr) {
        var coord_str;
        if (arr[i][0] == 'M') {
            command = 'M';
            coord_str = arr[i].replace('M', '');
        } else {
            command = 'L';
            coord_str = arr[i];
        }
        coord_str.replace('z', '');
        coord_arr = coord_str.split(' ');
        x = coord_arr[0];
        y = coord_arr[1];
        path_array.push({'command':command, 'x':parseInt(x), 'y':parseInt(y)});
    }
    debug(path_array);
    return(path_array);
}

//convert svg array of node elements to path string
function arrayToPath(path_array) {
    path_string = "";
    for (i in path_array) {
        path_string = path_string + path_array[i].command + path_array[i].x + " " + path_array[i].y;
    }
    path_string = path_string + "z";
    return path_string;
}