(
SynthDef(\kick8, {|out=0, attack=0.01, sus=0.25, pan=0, amp=1, speed=1, voice=0, freq |
	var env, sound;
	sound = RLPF.ar(SinOsc.ar(XLine.ar(freq.expexp(100, 4000, 1000, 5000), freq, 0.025/speed), voice), 9000);
  sound = RHPF.ar(sound, 60, 1);
  env = EnvGen.ar(Env.perc(attack, sus), doneAction:0);
  sound = sound * 0.5;
  sound = sound * [min(1, (1-pan)/2), min(1, (pan+1)/2)];
  Out.ar(out, sound);
},metadata: (credit: "taken from SuperDirt")).add;

SynthDef.new(\kick, {|out=0, attack=0.001, sus=0.125, amp=1, pan=0, freq|
  var osc = SinOsc.ar(freq * XLine.ar(0.5, 0.125, 0.0125));
  var env = EnvGen.ar(Env.perc(attack, sus), doneAction:2);
  osc = osc * env;
  osc = osc * [min(1, (1-pan)/2), min(1, (pan+1)/2)];
  Out.ar(out, osc*amp);
}).add;

SynthDef.new(\hat, {|out=0, hctf=7500, amp = 0.5, attack = 0.01, sus = 0.1, rq=1, pan = 1, freq|
	var pnk = PinkNoise.ar(1);
	var env = EnvGen.ar(Env.perc(attack, sus), doneAction: 0);
  pnk= RHPF.ar(pnk, hctf+freq, 1);
  pnk = pnk * env;
  pnk = pnk * [min(1, (1-pan)/2), min(1, (pan+1)/2)];
	Out.ar(out, pnk*amp);
}).add;

SynthDef.new(\snare, {|out=0, lctf=3500, hctf=200, amp = 1, attack = 0.01, sus = 0.5, pan = 1, freq|
	var pnk = BrownNoise.ar(1);
	var env = EnvGen.ar(Env.perc(attack, sus), doneAction: 0);
  pnk= RHPF.ar(RLPF.ar(pnk, lctf), hctf+freq, 1);
  pnk = pnk * env;
  pnk = pnk * [min(1, (1-pan)/2), min(1, (pan+1)/2)];
	Out.ar(out, pnk*amp);
}).add;

SynthDef(\bassy, {|out=0, lctf=1200, hctf=200, rq=0.5, attack=0.001, sus=1, amp=1, pan=1, freq|
	var saw = Saw.ar(freq,0.5);
	var env = EnvGen.ar(Env.perc(attack, sus), doneAction:2);
	saw = BHiPass.ar(RLPF.ar(saw, lctf*env, rq), hctf, 1);
  saw = saw * env;
  saw = saw * amp;
  saw = saw * [min(1, (1-pan)/2), min(1, (pan+1)/2)];
  Out.ar(out, saw);
}).add;
)