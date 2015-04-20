$(document).keypress(function (e){
    window.ws.send(JSON.stringify({ player_id: "client1", command: "key_pressed", key_code: e.keyCode}));

});

function parse_inc_mess(data) {
    var x = parseInt($('#box').css('top')) || 0;
    var y = parseInt($('#box').css('left')) || 0;
    obj = JSON.parse(data);
    obj = JSON.parse(obj);

    switch(parseInt(obj.key_code)) {

        case 119:   // Up
            console.log("dwdqwdq");
            $("#box").css({ top: (y-1) + 'px' });
            break;
        case 97:   // right
            $("#box").css({ left: (x-1) + 'px' });
            break;
        //case 38: // Up Arrow
        case 100:   // left
            $("#box").css({ left: (x+1) + 'px' });
            break;
        case 115:   // Down
            $("#box").css({ top: (y+1) + 'px' });
            break;
        //case 40: // Down Arrow
    }
}