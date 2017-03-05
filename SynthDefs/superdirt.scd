(
// balc
SynthDef(\kick, {|out=0, attack=0.001, release=0.125, detune=0.01, pan=0.5, freq|
  var sound, env, xl;
  xl = XLine.ar(1, 1/4, 1/16, doneAction:2);
  sound = HPF.ar(SinOsc.ar([freq * xl, freq+detune * xl]), 100);
  env = EnvGen.ar(Env.perc(attack, release, 1, -4), doneAction:2);
  sound = sound * 2 * env;
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;


SynthDef(\snare, {
  |out=0, attack=0.01, release=0.125, amp=1, pan=0, freq|
  var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
  var sound = HPF.ar(WhiteNoise.ar(1) * env, [freq, freq]) * env;
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan))
}).add;


SynthDef(\sn_brown, {
  |out=0, attack=0.01, release=0.125, amp=1, pan=0, freq|
  var sound = HPF.ar(BrownNoise.ar(1), [freq, freq]) * EnvGen.ar(Env.perc(attack, release), doneAction:2);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan))
}).add;


SynthDef(\sn_pink, {
  |out=0, attack=0.01, release=0.125, amp=1, pan=0, freq|
  var sound = HPF.ar(PinkNoise.ar(1), [freq, freq]) * EnvGen.ar(Env.perc(attack, release), doneAction:2);
  OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan))
}).add;

SynthDef(\hihat, {|out=0, amp = 1, attack = 0.01, release = 0.1, pan = 0.5, freq|
  var snd, env;
	env = Env.perc(attack, release).ar(doneAction: 2);
	snd = RHPF.ar(WhiteNoise.ar(1) * env, 10000, 0.1) * env * amp * 1.2;
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
    }).add;

SynthDef(\hihat1, {|out=0, amp = 1, attack = 0.01, release = 0.1, pan = 0.5, freq|
  var snd, env;
	env = Env.perc(attack, release).kr(doneAction: 2);
	snd = RHPF.ar(WhiteNoise.ar(amp) * env, freq, 0.1) * env * amp;
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
    }).add;

SynthDef(\bassy1, {|out=0, freq=440, ctf=1000, rq = 0.5, attack=0.001, release=1, lpcutoff=5000, amp=0.1, mul=1, pan=0.5|
	var sig = Saw.ar(freq);
	var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
	sig = mul * BHiPass.ar(RLPF.ar(sig, lpcutoff*env, rq), ctf, rq);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\bassy1p, {|out=0, lctf=1200, hctf=200, rq = 0.5, attack=0.001, release=1, sustain=1, pan=0.5, detune=0.01, coef=0.5, lag=0, accelerate, freq|
  var saw, env;
	env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
  saw = BHiPass.ar(RLPF.ar(Saw.ar([Lag.kr(freq, lag), Lag.kr(freq+detune, lag)] * Line.kr(1,1+accelerate, sustain),1), lctf*env, rq), hctf, 1);
  saw = OnePole.ar(saw, coef) * env;
	OffsetOut.ar(out, DirtPan.ar(saw, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\bassy, {|out=0, lctf=1200, hctf=200, rq = 0.5, attack=0.001, release=1, sustain=1, pan=0.5, detune=0.01, accelerate, freq|
  var saw, env;
	env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
  saw = BHiPass.ar(RLPF.ar(Saw.ar([freq, freq+detune] * Line.kr(1,1+accelerate, sustain),1), lctf*env, rq), hctf, 1);
  saw = saw * env;
	OffsetOut.ar(out, DirtPan.ar(saw, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\sin, {|out, attack=0.001, release=1, sustain=1, pan, accelerate, freq, detune=0.1|
	var env = EnvGen.ar(Env.perc(attack, release, 1, -4), timeScale: sustain / 2, doneAction: 2);
	var sound = SinOsc.ar([freq, freq+detune] * Line.kr(1,1+accelerate, sustain));
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\fm, {|out, attack=0.001, sustain=1, pan, accelerate, freq, carPartial=1, modPartial=1, index=3, mul=0.25, detune=0.1|
  var env = EnvGen.ar(Env.perc(attack, 0.999, 1, -3), timeScale: sustain / 2, doneAction:2);
  var mod = SinOsc.ar(freq * modPartial * Line.kr(1,1+accelerate, sustain), 0, freq * index * LFNoise1.kr(5.reciprocal).abs);
  var car = SinOsc.ar(([freq, freq+detune] * carPartial) + mod,	0, mul);
  OffsetOut.ar(out, DirtPan.ar(car, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\saw, {|out, attack=0.001, sustain=1, pan, accelerate, freq, detune=0.1|
	var env = EnvGen.ar(Env.perc(attack, 0.999, 1, -4), timeScale: sustain / 2, doneAction:2);
	var sound = Saw.ar([freq, freq+detune] * Line.kr(1,1+accelerate, sustain));
	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

// foxdot
SynthDef.new(\varsaw,
  {|vib=0, out=0, slide=0, rate=1, sustain=1, slidefrom=1, fmod=0, amp=1, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
    freq = Vibrato.kr(freq, rate: vib);
    osc=VarSaw.ar([freq, (freq * 1.005)], mul: (amp), width: rate);
    env=EnvGen.ar(Env(levels: [amp/4, amp, amp/4], curve: 'lin', times: (sustain / 2)), doneAction: 2);
    osc=(osc * env);
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));

  }).add;
)