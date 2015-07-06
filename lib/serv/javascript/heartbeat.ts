class Heartbeat {
    current_beat_index: number = 0;
    beats_per_second: number = 30;
    timer_instanse: any;
    constructor() {

    }
    run_heart_beat():void {
        var curr_instanse: Heartbeat = this;
        this.timer_instanse = setInterval(this.timer_tick, (1000*(1/this.beats_per_second))/1, curr_instanse);
        return;
    }

    timer_tick(ctx):void {
        ctx.current_beat_index += 1;
        if (ctx.current_beat_index >= ctx.beats_per_second) {
            ctx.current_beat_index = 0;
        }
        //console.log("Current beat", ctx.current_beat_index);
        return;
    }

    stop_heartbeat(): void {
        return clearInterval(this.timer_instanse);
    }

}

var system_heartbeat = new Heartbeat();
//system_heartbeat.run_heart_beat();