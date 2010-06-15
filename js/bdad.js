LAST_MOVE = null;
FIRST_X = null;
FIRST_Y = null;
LAST_X = null;
LAST_Y = null;
PATH = "";
SHAPE_LIST = [];

DEBUG = true;

CRAZY = "";
WISCONSIN = "M424 63L423 63L423 64L422 64L422 65L421 65L422 75L421 75L421 76L420 76L420 77L419 77L418 77L418 78L417 78L416 79L416 80L415 81L415 83L415 84L416 84L417 84L417 85L418 86L417 87L417 88L417 90L417 91L416 92L417 93L417 94L417 95L417 96L417 97L419 99L419 100L420 100L421 100L423 100L423 101L424 102L427 103L428 103L429 104L429 105L429 106L430 107L431 107L432 107L432 108L433 109L434 109L435 109L437 111L438 112L438 113L438 114L438 115L438 116L439 117L437 117L418 119L405 119L371 121L370 91L369 90L369 89L368 89L367 89L366 88L366 87L365 86L365 85L367 83L367 82L368 82L368 80L368 78L368 77L368 75L368 74L368 73L367 73L366 72L366 71L366 69L365 69L365 68L365 67L365 65L365 64L365 63L364 63L364 62L364 60L364 59L364 57L364 56L364 55L364 54L364 53L364 52L363 52L363 51L363 49L362 49L362 48L362 47L361 47L361 46L361 45L360 44L360 43L360 42L360 41L360 40L360 38L360 37L360 36L360 35L360 34L359 32L358 30L359 29L384 28L383 22L385 23L386 22L387 23L388 23L387 23L388 25L388 26L389 27L389 28L390 30L389 30L390 31L389 31L389 32L390 32L391 33L392 33L393 33L394 33L395 33L395 34L400 34L400 35L401 35L402 35L403 35L405 35L405 34L406 34L406 33L407 33L408 33L410 33L411 33L414 34L415 34L415 35L414 35L414 36L415 36L416 36L417 36L417 37L418 38L418 39L420 39L419 38L419 37L420 37L421 37L422 37L423 37L423 38L423 39L423 38L423 39L424 39L425 39L426 39L426 40L427 40L426 40L427 40L427 41L427 40L427 41L428 40L428 41L429 41L430 41L431 41L432 41L434 39L435 39L435 38L436 38L436 37L437 38L437 39L437 38L438 39L438 40L440 40L440 39L441 39L440 39L441 40L441 39L442 39L443 39L443 40L444 39L446 39L447 39L448 40L449 41L450 40L451 40L452 40L453 40L454 40L453 40L453 41L452 40L452 41L451 41L450 42L449 43L448 43L441 46L439 48L438 49L435 52L433 54L431 57L429 57L429 58L428 59L427 60L426 61L423 63L424 64z";
MAP_PATH = WISCONSIN;

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
    drawState(56);
    
    //initialize main canvas
    $("#canvas_container").width(CANVAS_WIDTH);
    $("#canvas_container").height(CANVAS_HEIGHT);

    MAIN_CANVAS = new Raphael(document.getElementById('canvas_container'), CANVAS_WIDTH, CANVAS_HEIGHT);
    $("#canvas_container").mousemove(function(e) {
        if(isDown) {
            var x = e.pageX - this.offsetLeft;
            var y = e.pageY - this.offsetTop;
            registerPoint(MAIN_CANVAS, LAST_X, LAST_Y, x, y);
        }
    });
    $("#canvas_container").mousedown(function(e) {
        isDown = true;
    });
    $("#canvas_container").mouseup(function() {
        isDown = false;
        saveShape(MAIN_CANVAS, PATH);
    });

});

function debug(debug_str) {
    if (DEBUG) {
        $('#debug').html(debug_str);
    }
}

function registerPoint(canvas, last_x, last_y, x,y) {
    if (LAST_MOVE == "M") {
        x_rel = x - last_x;
        y_rel = y - last_y;
        PATH = PATH + " l " + x_rel + " " + y_rel;
        LAST_X = x;
        LAST_Y = y;
    } else {
        PATH = PATH + " M " + x + " " + y;
        FIRST_X = x;
        FIRST_Y = y;
        LAST_X = x;
        LAST_Y = y;
        LAST_MOVE = "M";
    }
    drawPath(canvas, PATH);
}

function saveShape(canvas, path) {
    SHAPE_LIST.push(path + "z");
    drawPath(canvas, path);
    LAST_MOVE = null;
    FIRST_X = null;
    FIRST_Y = null;
    LAST_X = null;
    LAST_Y = null;
    PATH = "";
}

function drawPath(canvas, path) {
    canvas.clear();
    for (i in SHAPE_LIST) {
        this_shape = canvas.path(SHAPE_LIST[i]);
        this_shape.attr({'stroke-width':3, 'fill':'#FFCCCC', 'opacity':0.2});
    }
    drawing = canvas.path(PATH);
    drawing.attr({'stroke-width':3, 'fill':'#FFCCCC', 'opacity':0.2});
    debug(PATH);
}    

function clearPath(canvas) {
    SHAPE_LIST = [];
    PATH = "";
    LAST_MOVE = null;
    LAST_X = null;
    LAST_Y = null;
    canvas.clear();
    debug('');
}

function undo(canvas) {
    path=null;
    SHAPE_LIST.pop();
    drawPath(canvas, path);
}

function initializeStateList() {
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
        drawState(this.value);
    }

}

function drawState(state_value) {
    state_paths = STATES.features[state_value.toString()].paths;
    center_state = centerScaleRegion(state_paths).path_list;
    MAP_CANVAS.clear();
    for (i in center_state) {
        m = MAP_CANVAS.path(center_state[i]);
        m.attr({'fill':'#CCCCFF'});
    }
}

//return path list centered on canvas
//hackhackhackhackhackhackhack
function centerScaleRegion(path_list) {
    var low_x = 10000;
    var low_y = 10000;
    var high_x = 0;
    var high_y = 0;
    for (i in path_list) {
        coord_array = pathToArray(path_list[i]);
        for (j in coord_array) {
            low_x = Math.min(coord_array[j].x, low_x);
            low_y = Math.min(coord_array[j].y, low_y);
            high_x = Math.max(coord_array[j].x, high_x);
            high_y = Math.max(coord_array[j].y, high_y);
        }
    }
    width = high_x - low_x;
    height = high_y - low_y;
    x_skew_factor = CANVAS_WIDTH / width;
    y_skew_factor = CANVAS_HEIGHT / height;
    x_avg = (low_x + high_x) / 2;
    y_avg = (low_y + high_y) / 2;
    canvas_mid_x = CANVAS_WIDTH / 2;
    canvas_mid_y = CANVAS_HEIGHT / 2;
    offset_x = canvas_mid_x - x_avg;
    offset_y =canvas_mid_y - y_avg;
    new_path_list=[];
    for (i in path_list) {
        coord_array = pathToArray(path_list[i]);
        for (j in coord_array) {
            coord_array[j].x = (coord_array[j].x + offset_x);
            coord_array[j].y = (coord_array[j].y + offset_y);
        }
        new_path_list.push(arrayToPath(coord_array));
    }
    skew = {'x_skew':x_skew_factor, 'y_skew':y_skew_factor, 'x_offset':offset_x, 'y_offset':offset_y};
    return({'skew':skew, 'path_list':new_path_list});
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
    return(path_array);
}

//convert svg array of node elements to path string
function arrayToPath(path_array) {
    path_string = "";
    for (i in path_array) {
        path_string = path_string + path_array[i].command + " " + path_array[i].x + " " + path_array[i].y + " ";
    }
    path_string = path_string + "z";
    return path_string;
}