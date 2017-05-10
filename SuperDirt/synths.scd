(
SynthDef(\kick, {
  |out=0, attack, sustain, release, accel=0.01, pan=0.5, freq=80|
  var sig, env, xl;
  xl = XLine.kr(start:freq, end:freq*accel, dur:attack+release+0.1, doneAction:2);
  env = EnvGen.ar(Env.perc(attackTime: attack, releaseTime: release, curve: -4), timeScale: sustain, doneAction: 2);
  sig = HPF.ar(SinOsc.ar(xl), 60);
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\snare, {
  |out=0, attack, sustain, release, pan=0.5, freq|
  var sig, env;
  env = EnvGen.ar(Env.perc(attackTime:attack, releaseTime:release), timeScale: sustain, doneAction:2);
  sig = HPF.ar(WhiteNoise.ar(1) * env, freq);
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\clap, {
  |out=0, attack, sustain, release, rq=1, pan=0.5, freq|
  var sig, env, sigs, envs, sigl, envl;
  env = EnvGen.ar(Env.perc(attack, release), timeScale: sustain, doneAction:2);
  envs = EnvGen.ar(Env.new(
    [0,         1, 0,   0.9, 0,  0.7, 0,  0.5, 0.1],
    [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03, 0.1],
    [0,        -3, 0,    -3, 0,   -3, 0,   -4,  -4]
  ),  doneAction:2);
  sigs = BPF.ar(LPF.ar(HPF.ar(WhiteNoise.ar(envs), 600), XLine.kr(8000,4000,0.5)), 1500, rq, 3);
  envl = EnvGen.ar(Env.new(
    [0,   1, 0],
    [0, 0.5, 0],
    [0,  -4, 0]
  ), doneAction:2);
  sigl = BPF.ar(LPF.ar(HPF.ar(WhiteNoise.ar(envl), 1250), 8000), 1250, 0.125, 2);

  sig = (sigl + sigs) * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc + http://sccode.org/1-523")).add;

SynthDef(\hat, {
  |out=0, attack, sustain, release, rq=0.25, pan=0.5, freq|
  var sig, env;
  env = EnvGen.ar(Env.perc(attackTime: attack, releaseTime: release), timeScale: sustain, doneAction: 2);
  sig = RHPF.ar(WhiteNoise.ar(1) * env, (freq+10000), rq);
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\bassy, {
  |out=0, attack, sustain, release, lctf=1200, hctf=200, rq=0.5, detune=0.01, accel=0.01, pan=0.5, freq|
  var sig, env;
  env = EnvGen.ar(Env.perc(attackTime: attack, releaseTime: release), timeScale: sustain, doneAction: 2);
  sig = BHPF.ar(RLPF.ar(SawDPW.ar(freq * Line.kr(1,1+accel, sustain+release),1), lctf*env, rq), freq:hctf);
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

// uncomplete
SynthDef(\bacid, {
  |out=0, gain, pitch=50, rq=0.5, pan=0.5, freq|
	var env1, env2, sig, env, gate;
  gate = 1;
  pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
  env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, gain);
  env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);
  sig = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);
  sig  = RLPF.ar(sig, (pitch + env2).midicps, 0.3);

  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env1));

}, metadata: (credit: "https://github.com/miguel-negrao/SuperCollider/blob/master/examples/pieces/acid_otophilia.scd")).add;

SynthDef(\piano, {
  |out=0, attack, decay, sustain, release, stretch=0.1, tune=0.5, feed=0.5, pan=0, freq|
  var sig, env;
  env = EnvGen.ar(Env.perc(attack, release), timeScale: sustain, doneAction:2);
  sig = MdaPiano.ar(freq, stretch:stretch, tune:tune, decay:decay, sustain: sustain, release:release);
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\23, {
  |out, gain, attack, sustain, release, fb=0, detune=1.01, pan=0.5, freq|
  var par, tri, sig, env;
	env = EnvGen.ar(Env.linen(attackTime:attack, sustainTime:sustain, releaseTime:release), timeScale:sustain, doneAction:2);
  par = LFPar.ar(XLine.kr(freq/2,freq, sustain*10, doneAction:2), mul:gain); // 2
  tri = LFTri.ar(freq:freq*((detune/100)+1), mul: gain); // 3
  sig = SinOscFB.ar(freq+tri, feedback:par, mul: gain);
	sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(LeakDC.ar(sig), ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef.new(\kell,{
  |out=0, attack, decay, sustain, release, pan=0.5, freq|
  var sig, env;
  env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), doneAction: 2);
  sig = Klang.ar(`[
    freq*[0.5,0.5],
    0.25!2,
    pi.rand!2], 1, 0)*0.25;
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(LeakDC.ar(sig), ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\dust, {
  |out=0, attack, sustain, release, rq=0.25, detune=1, pan=0.5, freq|
  var sig, env;
  env = EnvGen.ar(Env.perc(attack, release), timeScale: sustain, doneAction:2);
  sig = LPF.ar(Ringz.ar(Dust.ar(freq), freq*2.rand.max(9000)), 8000)*0.5;
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\pulse, {
  |out=0, attack, sustain, release, accel=0.01, detune=0.1, ffreq=1250, pan=0.5, freq|
  var sig, env;
	env = EnvGen.ar(Env.perc(attack, release), timeScale: sustain*0.5, doneAction:2);
	sig = RLPF.ar(LFPulse.ar([freq, freq],0.5), freq:ffreq, rq:1);
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\can, {
  |out=0, attack, sustain, release, vib=10, phase=0.5, pan=0, freq|
  var sig, env;
  env = EnvGen.ar(Env.perc(attackTime: attack, releaseTime: release), timeScale: sustain, doneAction: 2);
  sig = Vibrato.ar(FreqShift.ar(LFTri.ar(freq, phase), freq/2), rate:vib);
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "http://github.com/lvm/balc")).add;

SynthDef(\fm, {
  |out, attack, sustain, accel, carPartial=1, modPartial=1, index=3, mul=0.25, detune=0.1, pan=0.5, freq|
  var env, mod, car, sig;
  env = EnvGen.ar(Env.perc(attack, 0.999, 1, -3), timeScale: sustain*0.5, doneAction:2);
  mod = SinOsc.ar(freq * modPartial * Line.kr(1,1+accel, sustain), 0, freq * index * LFNoise1.kr(5.reciprocal).abs);
  car = SinOsc.ar(([freq, freq+detune] * carPartial) + mod,	0, mul);
  sig = (car*2) * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "@munshkr")).add;

SynthDef(\sin, {
  |out, attack, sustain, release, accel=0, detune=0.1, pan=0.5, freq|
  var sig, env;
	env = EnvGen.ar(Env.perc(attack, release), timeScale: sustain*0.5, doneAction: 2);
	sig = SinOsc.ar([freq, freq+detune] * Line.kr(1,1+accel, sustain));
  sig = sig * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "@munshkr")).add;

SynthDef(\saw, {
  |out, attack, sustain, release, accel=0.01, detune=0.1, pan=0.5, freq|
  var sig, env;
	env = EnvGen.ar(Env.perc(attack, release), timeScale: sustain*0.5, doneAction:2);
	sig = SawDPW.ar([freq, freq+detune] * Line.kr(1,1+accel, sustain)) * env;
  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}, metadata: (credit: "@munshkr")).add;

SynthDef.new(\soprano,
  {|out=0, attack, sustain, release, vib=5, slide=0, rate=1, verb=0.5, slidefrom=1, fmod=0, pan=0.5, freq|
  var osc, env;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
  freq = Vibrato.kr(freq, rate: vib);
  env = EnvGen.ar(Env.perc(attackTime: attack, releaseTime: release), timeScale: sustain, doneAction: 2);
  osc = (SinOsc.ar((freq * 3)) + SinOscFB.ar((freq * 3), mul: 0.5));
  osc = osc * env;
  OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}, metadata: (credit: "https://github.com/Qirky/FoxDot")).add;

SynthDef.new(\varsaw,
  {|out=0, gain, attack, sustain, vib=0, slide=0, rate=1, slidefrom=1, fmod=0, pan=0, freq|
  var osc, env;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
  freq = Vibrato.kr(freq, rate: vib);
  osc=VarSaw.ar([freq, (freq * 1.005)], mul: (gain), width: rate);
  env=EnvGen.ar(Env(levels: [gain, gain, gain], curve: \lin, times: sustain*0.5), doneAction: 2);
  osc = osc * env;
  OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}, metadata: (credit: "https://github.com/Qirky/FoxDot")).add;

SynthDef.new(\pluck, {
  |out=0, gain, attack, sustain, vib=0, slide=0, slidefrom=1, fmod=0, rate=1, bits=0, pan=0.5, freq|
  var osc, env;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
  freq = Vibrato.kr(freq, rate: vib);
  freq=[freq, (freq + LFNoise2.ar(50).range(-2, 2))];
  osc=(SinOsc.ar((freq * 1.002), phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) + (SinOsc.ar(freq*rate, phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) ));
  osc=osc * XLine.ar(gain, (gain/ 10000), (sustain * 4), doneAction: 2)*0.25;
  osc = osc * EnvGen.ar(Env.perc(attack,sustain), doneAction:2);
  OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}, metadata: (credit: "https://github.com/Qirky/FoxDot")).add;

SynthDef.new(\crunch,
  {|out=0, gain, sustain vib=0, slide=0, rate=1, slidefrom=1, fmod=0, pan=0.5, freq|
  var osc, env;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
  freq = Vibrato.kr(freq, rate: vib);
  env = EnvGen.ar(Env.perc(level: (gain),curve: 0,attackTime: 0.01,releaseTime: 0.1+sustain), doneAction: 2);
  osc = LFNoise0.ar(((Crackle.kr(1.75) * freq) * 30), mul: gain);
  osc = osc * env;
  OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}, metadata: (credit: "https://github.com/Qirky/FoxDot")).add;

SynthDef.new(\noise,
  {|out=0, gain, attack, decay, sustain, release, vib=0, slide=0, rate=1,  slidefrom=1, fmod=0, rq=1, lctf=800, pan=0.5, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
    freq = Vibrato.kr(freq, rate: vib);
    osc = RLPF.ar(LFNoise0.ar(freq, gain), lctf, rq, gain);
    env = EnvGen.ar(Env.adsr(attackTime: attack, decayTime: decay, sustainLevel: sustain, releaseTime: release), doneAction:2);
  osc = osc * env;
  OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env));
}, metadata: (credit: "https://github.com/Qirky/FoxDot")).add;
)
