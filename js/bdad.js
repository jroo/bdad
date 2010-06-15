LAST_MOVE = null;
FIRST_X = null;
FIRST_Y = null;
LAST_X = null;
LAST_Y = null;
PATH = "";
SHAPE_LIST = [];

DEBUG = true;

CANVAS_WIDTH = 640;
CANVAS_HEIGHT = 480;
Y_SCALE = null;

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
        populateDistricts(this.value);
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

function populateDistricts(state_value) {
    district_list = STATES.features[state_value.toString()].attributes.districts;
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

function drawDistrict(district_string) {
    dist_arr = district_string.split(',');
    state_id = dist_arr[0];
    district_id = dist_arr[0] + dist_arr[1];
    district = STATES.features[state_id.toString()].attributes.districts
    alert(district_id);
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
    debug('x_factor: ' + x_skew_factor + ', y_factor: ' + y_skew_factor);
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