var Heartbeat = (function () {
    function Heartbeat() {
        this.current_beat_index = 0;
        this.beats_per_second = 30;
    }
    Heartbeat.prototype.run_heart_beat = function () {
        var curr_instanse = this;
        this.timer_instanse = setInterval(this.timer_tick, (1000 * (1 / this.beats_per_second)) / 1, curr_instanse);
        return;
    };
    Heartbeat.prototype.timer_tick = function (ctx) {
        ctx.current_beat_index += 1;
        if (ctx.current_beat_index >= ctx.beats_per_second) {
            ctx.current_beat_index = 0;
        }
        //console.log("Current beat", ctx.current_beat_index);
        return;
    };
    Heartbeat.prototype.stop_heartbeat = function () {
        return clearInterval(this.timer_instanse);
    };
    return Heartbeat;
})();
var system_heartbeat = new Heartbeat();
//system_heartbeat.run_heart_beat(); 
//# sourceMappingURL=heartbeat.js.map