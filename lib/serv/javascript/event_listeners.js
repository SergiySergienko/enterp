var EventListeners = function() {
    this.proceed_received_message = function (data) {
        var mess_data = MessageParser.do_parse(data);
        
        //if (mess_data.cmd.toString() == "99") {
            //current_a_id = mess_data.a_id;
            //entities_state_holder.add_entitiy(mess_data.a_id, mess_data.cmd_data);
            //go = true;
        //} else
        if (mess_data.cmd.toString() == "99") {
            go = true;

            //console.log(mess_data);
            var exists_keys = [];
            entities_state_holder.all_entities.forEach(function(e_element, e_index, e_array){
                exists_keys.push(e_element.a_id);
            });
            //console.log(exists_keys);

            mess_data.avatars.forEach(function(element, index, array) {
                if (!(element.a_id in exists_keys)) {
                    console.log("add_new_entity", element);
                    entities_state_holder.add_entitiy(element);
                } else {
                    entities_state_holder.add_to_pending(element);
                }
            });
            //entities_state_holder.all_entities
            //    add_entitiy(mess_data.a_id, mess_data.cmd_data);
            //go = true;
        }
        else {
            entities_state_holder.add_to_pending(mess_data);
        }
        //console.log(mess_data);
    };
};

var event_listener_dispatcher = new EventListeners();