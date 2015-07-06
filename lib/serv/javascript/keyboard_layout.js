var KeyboardLayout = (function () {
    function KeyboardLayout() {
        this.messages_buffer = [];
    }
    KeyboardLayout.prototype.push_to_buffer = function (message_data) {
        if (this.messages_buffer.length < KeyboardLayout.buffer_max_size) {
            this.messages_buffer.push(message_data);
        }
        return this.messages_buffer;
    };
    KeyboardLayout.prototype.clean_buffer = function () {
        this.messages_buffer = [];
        return;
    };
    KeyboardLayout.prototype.commit_buffer = function () {
        if (this.messages_buffer.length > 0) {
            for (var i = 0; i <= this.messages_buffer.length - 1; i++) {
                console.log("Pushing", this.messages_buffer[i]);
                window.ws.send(this.messages_buffer[i]);
            }
        }
        this.clean_buffer();
    };
    KeyboardLayout.buffer_max_size = 5;
    return KeyboardLayout;
})();
var keyboard_dispatcher = new KeyboardLayout();
//# sourceMappingURL=keyboard_layout.js.map