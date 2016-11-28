{[SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)]}.play;

({
	var ampOsc;
	ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
	SinOsc.ar(440, 0, ampOsc);
}.play;
)

{SinOsc.ar([440, 442], 0, 0.2)}.scope;

{Mix.new([SinOsc.ar(440, 0, 0.2), Saw.ar(660, 0.2)])}.plot;

// help - ctrl+D
// play - ctrl+Enter
// stop - ctrl+.

s.quit;
s.boot;