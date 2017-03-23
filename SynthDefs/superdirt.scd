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

SynthDef(\hat, {|out=0, amp = 1, attack = 0.01, release = 0.1, pan = 0.5, freq|
  var snd, env;
	env = Env.perc(attack, release).ar(doneAction: 2);
	snd = RHPF.ar(WhiteNoise.ar(1) * env, 10000, 0.1) * env * amp * 1.2;
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
    }).add;

SynthDef(\hat1, {|out=0, amp = 1, attack = 0.01, release = 0.1, pan = 0.5, freq|
  var snd, env;
	env = Env.perc(attack, release).kr(doneAction: 2);
	snd = RHPF.ar(WhiteNoise.ar(amp) * env, freq, 0.1) * env * amp;
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
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
    osc=(osc * env) * 1.25;
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));

  }).add;

SynthDef.new(\pluck, {|vib=0, out=0, slide=0, rate=1, sustain=1, slidefrom=1, fmod=0, amp=1, freq, bits=0, pan=0.5|
  var osc, env;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
  freq = Vibrato.kr(freq, rate: vib);
  freq=[freq, (freq + LFNoise2.ar(50).range(-2, 2))];
  osc=(SinOsc.ar((freq * 1.002), phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) + (SinOsc.ar(freq, phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) ));
  osc=osc * XLine.ar(amp, (amp / 10000), (sustain * 4), doneAction: 2);
  OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;

SynthDef.new(\soprano,
  {|out=0, vib=5, slide=0, rate=1, verb=0.5, sustain=1, slidefrom=1, fmod=0, bits=0, amp=1, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
    freq = Vibrato.kr(freq, rate: vib);
    osc=(SinOsc.ar((freq * 3), mul: amp) + SinOscFB.ar((freq * 3), mul: (amp / 2)));
    env=EnvGen.ar(Env(levels: [amp/4, amp, amp/4], curve: 'lin', times: (sustain / 2)), doneAction: 2);
    osc=(osc * env) * 6;
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;

SynthDef.new(\marimba,
  {|out=0, vib=0, slide=0, rate=1, sus=1, sustain=0.1, slidefrom=1, fmod=0, bits=0, amp=1, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sus);
    freq = Vibrato.kr(freq, rate: vib);
    osc=Klank.ar(`[[0.5, 1, 4, 9], [0.5, 1, 1, 1], [1, 1, 1, 1]], PinkNoise.ar([0.007, 0.007]), [freq, freq], [0, 2]);
    env=EnvGen.ar(Env.perc(level: amp*3,curve: -6,attackTime: 0.001,releaseTime: sus+sustain), doneAction: 0);
    osc=(osc * env) * 4;
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;


SynthDef.new(\pulse,
  {|vib=0, out=0, slide=0, rate=1, sus=1, slidefrom=1, fmod=0, amp=1, bits=0, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sus);
    freq = Vibrato.kr(freq, rate: vib);
    amp=(amp / 4);
    osc=Pulse.ar(freq);
    env=EnvGen.ar(Env(levels: [0, 1, 1, 0],curve: 'lin',times: [0.01, (sus - 0.01), 0.01]), doneAction: 0);
    osc=(osc * env);
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;


SynthDef.new(\blip,
  {|out=0, vib=0, slide=0, rate=1, sustain=1, slidefrom=1, fmod=0, amp=1, bits=0, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
    freq = Vibrato.kr(freq, rate: vib);
    amp=(amp + 1e-05);
    freq=[freq, (freq + LFNoise2.ar(50).range(-2, 2))];
    osc=((LFCub.ar((freq * 1.002), iphase: 1.5) + (LFTri.ar(freq, iphase: Line.ar(2, 0, 0, 2)) * 0.3)) * Blip.ar((freq / 2), rate));
    osc=((osc * XLine.ar(amp, (amp / 10000), (sustain * 2))) );
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;

SynthDef.new(\noise,
  {|out=0, vib=0, slide=0, rate=1, sustain=1, slidefrom=1, fmod=0, amp=1, bits=0, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
    freq = Vibrato.kr(freq, rate: vib);
    osc=LFNoise0.ar(freq, amp);
    env=EnvGen.ar(Env(levels: [0, amp, 0],curve: 'lin',times: [(sustain / 2), (sustain / 2)]), doneAction: 2);
    osc=(osc * env)*4;
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;

SynthDef.new(\charm,
  {|vib=0, out=0, slide=0, rate=1, sustain=1, slidefrom=1, fmod=0, amp=1, bits=0, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
    freq = Vibrato.kr(freq, rate: vib);
    osc=(SinOsc.ar([freq, (freq + 4)], mul: amp) + VarSaw.ar((freq * 8), 10, mul: (amp / 8)));
    osc=LPF.ar(osc, SinOsc.ar(Line.ar(1, (rate * 4), (sustain / 8)), 0, (freq * 2), ((freq * 2) + 10)));
    env=EnvGen.ar(Env.perc(level: amp,curve: 0,attackTime: 0.01,releaseTime: sustain), doneAction: 0);
    osc=(osc * env)*8;
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;

SynthDef.new(\pads,
  {|out=0, vib=0, slide=0, rate=1, sus=1, slidefrom=1, fmod=0, amp=1, bits=0, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sus);
    freq = Vibrato.kr(freq, rate: vib);
    osc=SinOsc.ar([freq, (freq + 2)], mul: amp);
    env=EnvGen.ar(Env.perc(level: amp,curve: 0,attackTime: 0.01,releaseTime: sus), doneAction: 0);
    osc=(osc * env)*4;
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;

SynthDef.new(\crunch,
  {|vib=0, out=0, slide=0, rate=1, sustain=1, slidefrom=1, fmod=0, amp=1, bits=0, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
    freq = Vibrato.kr(freq, rate: vib);
    //amp=(amp * 0.5);
    osc=LFNoise0.ar(((Crackle.kr(1.75) * freq) * 30), mul: amp);
    env=EnvGen.ar(Env.perc(level: (amp),curve: 0,attackTime: 0.01,releaseTime: 0.1+sustain), doneAction: 0);
    osc=(osc * env)*8;
    OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}).add;

)