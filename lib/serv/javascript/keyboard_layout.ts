class KeyboardLayout
{
    static buffer_max_size: Number = 5;
    messages_buffer:Array<string> = [];

    push_to_buffer(message_data: string) {
        if (this.messages_buffer.length < KeyboardLayout.buffer_max_size) {
            this.messages_buffer.push(message_data);
        }
        return this.messages_buffer;
    }
    clean_buffer() {
        this.messages_buffer = [];
        return;
    }
    commit_buffer() {
        if (this.messages_buffer.length > 0) {
            for(var i:number = 0; i<=this.messages_buffer.length-1;i++) {
                console.log("Pushing", this.messages_buffer[i]);
                window.ws.send(this.messages_buffer[i]);
            }
        }
        this.clean_buffer();
    }

}

var keyboard_dispatcher:KeyboardLayout = new KeyboardLayout();