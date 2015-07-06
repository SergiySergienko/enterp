var game = new Phaser.Game(400, 300, Phaser.AUTO, 'phaser-example');
game.config.forceSetTimeOut = true;

var sprite;
var speed = 4;
var current_a_id = 0;
var go = false;
var i=0;

var PhaserGame = function () {
    this.entites_mapping = [];
};

PhaserGame.prototype = {

    init: function () {
        this.stage.disableVisibilityChange = true;
        this.game.renderer.renderSession.roundPixels = true;
        this.physics.startSystem(Phaser.Physics.ARCADE);

    },

    preload: function () {


        this.load.image('ship', 'sprites/ufo.png');

    },

    create: function () {

        //sprite = this.add.sprite(150, 150, 'ship');

    },

    update: function () {
        var deltaTime = game.time.elapsed / 1000;


        //console.log(deltaTime);
        if (go) {

            if (i % 3 == 0) {
                var msg_data;
                var dest_x;
                var dest_y;
                var dest_a;
                if (game.input.keyboard.isDown(Phaser.Keyboard.LEFT)) {
                    dest_x = (-speed);
                    dest_y = 0;
                    dest_a = 0;
                    //msg_data = "5:" + dest_x.toString() + "," + dest_a.toString();
                    //keyboard_dispatcher.push_to_buffer(msg_data);
                    ws.send("5:" + dest_x.toString() + "," + dest_y.toString() + "," + dest_a.toString());
                    sprite.x += dest_x;
                    sprite.y += dest_y;
                    //sprite.angle = -15;
                }
                else if (game.input.keyboard.isDown(Phaser.Keyboard.RIGHT)) {
                    dest_x = (+speed);
                    dest_y = 0;
                    dest_a = 0;
                    //msg_data = "5:" + dest_x.toString() + "," + dest_a.toString();
                    //keyboard_dispatcher.push_to_buffer(msg_data);

                    ws.send("5:" + dest_x.toString() + "," + dest_y.toString() + "," + dest_a.toString());

                    sprite.x += dest_x;
                    sprite.y += dest_y;
                    //sprite.angle = 15;
                }
                else if (game.input.keyboard.isDown(Phaser.Keyboard.DOWN)) {
                    dest_x = (0);
                    dest_y = speed;
                    dest_a = 0;
                    //msg_data = "5:" + dest_x.toString() + "," + dest_a.toString();
                    //keyboard_dispatcher.push_to_buffer(msg_data);

                    ws.send("5:" + dest_x.toString() + "," + dest_y.toString() + "," + dest_a.toString());

                    sprite.x += dest_x;
                    sprite.y += dest_y;
                    //sprite.angle = 15;
                }
                else if (game.input.keyboard.isDown(Phaser.Keyboard.UP)) {
                    dest_x = (0);
                    dest_y = (-speed);
                    dest_a = 0;
                    //msg_data = "5:" + dest_x.toString() + "," + dest_a.toString();
                    //keyboard_dispatcher.push_to_buffer(msg_data);

                    ws.send("5:" + dest_x.toString() + "," + dest_y.toString() + "," + dest_a.toString());

                    sprite.x += dest_x;
                    sprite.y += dest_y;
                    //sprite.angle = 15;
                }
            }
            else {
                entities_state_holder.update_states(this.entites_mapping, this);
            }
        }
        i += 1;
        if (i == 100) {
            i=0;
        }
    }

};

game.state.add('Game', PhaserGame, true);