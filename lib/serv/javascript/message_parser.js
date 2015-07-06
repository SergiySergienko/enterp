var MessageParser = function() {

};
MessageParser.do_parse = function (data) {
    var result = {};
    var data_arr = data.split("|");
    var a_id = data_arr[0];
    var cmd;

    if (a_id == "999") { // This is master avatar
        if (data_arr[1].substring(0, 2) == "99") { // sync avatars command
            cmd = "99";
            data_arr[1] = data_arr[1].substring(3, data_arr[1].length-1);
            var tmp_data = data_arr[1].split(".");

            //var cmd = tmp_data[0];
            //var cmd_data = tmp_data[1];

            result["avatars"] = [];
            tmp_data.forEach(function(elem, index, arr) {
                var tmp = elem.split(":");
                var tmp_a_data = tmp[1].split(",");
                var tmp_h = {"a_id": tmp[0], "x": tmp_a_data[0], "y": tmp_a_data[1], "a": tmp_a_data[2]}
                result["avatars"].push(tmp_h);
            });

            //if (cmd == "99") { //Sync all avatars
            //    var cmd_data_arr = cmd_data.split(",");
            //    result["avatars"] = cmd_data_arr;
            //}
        }
        else {
            console.log("Another command", data_arr[1]);
        }



    } else {
        console.log("auth message received", data);
        current_a_id = data_arr[0];
    }
    //var tmp_data = data_arr[1].split(":");
    //var cmd = tmp_data[0];
    //var cmd_data = tmp_data[1];
    //if (cmd == "91") { //Sync all avatars
    //    var cmd_data_arr = cmd_data.split(",");
    //    result["avatars"] = cmd_data_arr;
    //}
    //else {
    //    if (cmd_data) {
    //        var cmd_data_arr = cmd_data.split(",");
    //        if (cmd_data_arr[0]) {
    //            result["next_x"] = cmd_data_arr[0];
    //        }
    //        if (cmd_data_arr[1]) {
    //            result["next_y"] = cmd_data_arr[1];
    //        }
    //        if (cmd_data_arr[2]) {
    //            result["next_a"] = cmd_data_arr[2];
    //        }
    //    }
    //}

    result["a_id"] = a_id;
    result["cmd"] = cmd;
    //result["cmd_data"] = cmd_data;
    //console.log("SHIT", result);
    return result;
}