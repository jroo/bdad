LAST_MOVE = null;
FIRST_X = null;
FIRST_Y = null;
PATH = "";
DRAWING = {'state':null, 'district':null, 'transform':{'factor':null, 'x_offset':null, 'y_offset':null, 'scale':null}, 'path_list':[], 'attr':{'stroke-width':2, 'fill':'#FFCCCC', 'opacity':0.4}};
DUMMY_TOKEN = 'jroo-test' + Math.random();

DOMAIN = '10.13.30.253:3000';

CANVAS_WIDTH = 640;
CANVAS_HEIGHT = 480;

$('document').ready(function() {

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
    
    drawDistrict(document.getElementById('district_code').value, 'map_container');

});

function registerPoint(canvas, x, y) {
    if (LAST_MOVE == "M") {
        current_move = "L" + x + " " + y;
        PATH = PATH + current_move;
    } else {
        current_move = "M" + x + " " + y;
        PATH = PATH + current_move;
        FIRST_X = x;
        FIRST_Y = y;
        LAST_MOVE = "M";
    }
    drawSVG(canvas, DRAWING.path_list, PATH, DRAWING.attr);
}

function saveShape(canvas, path) {
    canvas.clear();
    if (path) {
        DRAWING.path_list.push(path + "z");
    }
    drawSVG(canvas, DRAWING.path_list, null, DRAWING.attr);
    saveDrawing(DRAWING);
    LAST_MOVE = null;
    FIRST_X = null;
    FIRST_Y = null;
    PATH = "";
}

function saveDrawing(drawing) {
    descaled_paths = descalePaths(drawing.path_list, drawing.transform, CANVAS_HEIGHT, CANVAS_WIDTH);
    d = { 'paths':descaled_paths };
    url = 'http://' + DOMAIN + '/screen_data/';
    t = DUMMY_TOKEN;
    data = { 'd':d, 't':t, 'district_code':document.getElementById('district_code').value }
    $.post(url, data, function(data) {
        displaySaved('josh', DUMMY_TOKEN);
    }, "json");
}

function clearPath(canvas) {
    DRAWING.path_list = [];
    PATH = "";
    LAST_MOVE = null;
    canvas.clear();
}

function undo(canvas) {
    DRAWING.path_list.pop();
    drawSVG(canvas, DRAWING.path_list, null, DRAWING.attr);
    saveDrawing(DRAWING);
}

function scalePaths(paths, x_factor, y_factor, x_offset, y_offset, scale, canvas_height, canvas_width) {
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
            coord_array[j].x = ((coord_array[j].x - (canvas_width / 2)) * factor * scale) + (canvas_width / 2);
            coord_array[j].y = ((coord_array[j].y - (canvas_height / 2)) * factor * scale) + (canvas_height / 2);
        }
        scaled_paths.push(arrayToPath(coord_array));
    }
    return({'attr':{'factor':factor, 'x_offset':x_offset, 'y_offset':y_offset, 'scale':scale}, 'paths':scaled_paths});
}

function descalePaths(scaled_paths, transform, canvas_height, canvas_width) {
    //descale
    refactor = 1/(transform.factor * transform.scale)
    var descaled_paths = [];
    for (i in scaled_paths) {
        coord_array = pathToArray(scaled_paths[i]);
        for (j in coord_array) {
            coord_array[j].x = parseInt(((coord_array[j].x - (canvas_width / 2)) * refactor) + (canvas_width / 2));
            coord_array[j].y = parseInt(((coord_array[j].y - (canvas_height / 2)) * refactor) + (canvas_height / 2));
        }
        descaled_paths.push(coord_array);
    }
    
    var positioned_paths = [];
    for (i in descaled_paths) {
        coord_array = descaled_paths[i];
        for (j in coord_array) {
            coord_array[j].x = parseInt(coord_array[j].x - transform.x_offset);
            coord_array[j].y = parseInt(coord_array[j].y - transform.y_offset);
        }
        positioned_paths.push(arrayToPath(coord_array));
    }
    return(positioned_paths);
}

function drawDistrict(district_string, target_name) {
    state_id = district_string[0] + district_string[1];
    district_id = district_string;
    
    target_height = $('#'+target_name).height();
    target_width = $('#'+target_name).width();
    
    target_x_mid = parseInt(target_width/2);
    target_y_mid = parseInt(target_height/2);
    
    //district = STATES.features[state_id.toString()].attributes.districts
    bounds = DISTRICTS.features[district_id.toString()].bounds;
    paths = DISTRICTS.features[district_id.toString()].paths;
    mid_x = (bounds.minX + bounds.maxX) / 2;
    mid_y = (bounds.minY + bounds.maxY) / 2;
    x_offset = target_x_mid - mid_x;
    y_offset = target_y_mid - mid_y;
    width = bounds.maxX - bounds.minX;
    height = bounds.maxY - bounds.minY;
    x_factor = target_width / width;
    y_factor = target_height / height;
    
    var new_paths = scalePaths(paths, x_factor, y_factor, x_offset, y_offset, 0.6, target_height, target_width);
    DRAWING.transform = new_paths.attr;
    drawSVG(MAP_CANVAS, new_paths.paths, null, {fill:'#CCCCFF', opacity:0.6 });
}

function drawSVG(canvas, paths, path, attr) {
    canvas.clear();
    for (i in paths) {
        drawPath(canvas, paths[i], attr);
    }
    if (path) {
        drawPath(canvas, path, attr);
    }
}

function drawPath(canvas, path, attr) {
    m = canvas.path(path);
    m.attr(attr);
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
        path_string = path_string + path_array[i].command + path_array[i].x + " " + path_array[i].y;
    }
    path_string = path_string + "z";
    return path_string;
}

function displaySaved(target_name, token) {

}