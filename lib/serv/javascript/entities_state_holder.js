var EntitiesStateHolder = function() {
    this.all_entities = [];
    this.pending_states = [];
};

var AvatarEntity = function() {
    this.a_id = null;
    this.curr_x = 0;
    this.curr_y = 0;
    this.curr_a = 0;
    this.my_sprite = null;

    this.set_sprite_instance = function(spr) {
        this.my_sprite = spr;
    };

    this.proceed_redraw = function(updated_state_data, ctx, indx) {
        //console.log(updated_state_data);
        this.my_sprite.x = parseInt(updated_state_data.x);
        this.my_sprite.y = parseInt(updated_state_data.y);
        this.my_sprite.angle = parseInt(updated_state_data.a);
        ctx.del_from_pendings(indx);
    };

};

EntitiesStateHolder.prototype = {
    update_state: function () {

    },

    add_entitiy: function (entity_data) {
        //console.log("adding_entity");
        var a_ent = new AvatarEntity();
        a_ent.a_id = entity_data.a_id;
        a_ent.cur_x = entity_data.x;
        a_ent.cur_y = entity_data.y;
        a_ent.cur_a = entity_data.a;
        this.all_entities.push(a_ent);
    },

    update_states: function (entities_mapping, ctx) {

        if (this.all_entities.length > 0) {

            for(var i=0; i <= this.all_entities.length - 1; i++) {
                ent_state = this.all_entities[i];

                if (!(ent_state.a_id.toString() in entities_mapping)) {
                    console.log("Drawing new entitiy", ent_state.a_id);
                    var new_spr = ctx.add.sprite(ent_state.curr_x, ent_state.curr_y, 'ship');
                    entities_mapping[ent_state.a_id.toString()] = new_spr;
                    ent_state.set_sprite_instance(new_spr);
                    if (current_a_id.toString() == ent_state.a_id.toString()) {
                        sprite = new_spr;
                    }
                }

                if (this.get_pending().length > 0) {
                    var p_values = this.get_pending();
                    for (var a = 0; a <= p_values.length - 1; a++) {

                        var curr_p_value = p_values[a];
                        //console.log(p_values);
                        //console.log(ent_state);
                        //console.log("CURR VAL", curr_p_value);
                        if (curr_p_value.a_id.toString() == ent_state.a_id.toString()) {
                            ent_state.proceed_redraw(curr_p_value, this, a);
                        }
                    }
                }
            }
        }
    },

    get_state: function() {

    },

    get_pending: function() {
        return this.pending_states;
    },

    del_from_pendings: function(indx) {
        delete this.pending_states[indx];
        this.pending_states = this.pending_states.filter(function(n){ return n != undefined });
        return;
    },

    add_to_pending: function(data) {
        this.pending_states.push(data);
    },
};

var entities_state_holder = new EntitiesStateHolder();