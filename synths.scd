(
// drum
SynthDef(\kick, {
  |out=0, amp=0.9, atk=0.01, sus=1, rel=0.5, accel=0.01, pan=0, freq=80|
  var sig, env, xl;
  amp = amp*0.9;
  xl = XLine.kr(start:freq, end:freq*accel, dur:rel, mul: amp, doneAction:2);
	env = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: rel, level: amp, curve: -8), timeScale: sus, doneAction: 2);
  sig = HPF.ar(SinOsc.ar(xl), 20);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\kick8, {
  |out=0, amp=0.9, atk=0.01, dec=0.5, sus=1, rel=0.5, accel=0.01, pan=0, freq=80|
  var sig, env, xl;
  amp = amp*0.9;
  xl = XLine.kr(start:freq, end:freq*accel, dur:rel, mul: amp, doneAction:2);
	env = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: rel, level: amp, curve: -8), timeScale: sus, doneAction: 2);
  sig = LPF.ar(Ringz.ar(Impulse.ar(1), freq, dec, amp), 800)  *env;
  sig = sig * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\snare, {
  |out=0, amp=0.9, atk=0.01, sus=1, rel=0.5, pan=0, freq=1250|
  var sig, env;
  amp = amp*0.9;
  env = EnvGen.ar(Env.perc(attackTime:atk, releaseTime:rel, level: amp), timeScale: sus, doneAction:2);
  sig = HPF.ar(WhiteNoise.ar(1) * env, freq);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\hat, {
  |out=0, amp=0.9, atk=0.01, sus=1, rel=0.05, rq=0.25, pan=0, freq=0|
  var sig, env;
	amp = amp*0.9;
  env = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: rel, level: amp), timeScale: sus, doneAction: 2);
  sig = RHPF.ar(WhiteNoise.ar(1) * env, (freq+10000), rq);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

// strings

SynthDef(\bassy, {
  |out=0, amp=0.9, atk=0.01, sus=0.5, rel=2, lctf=1200, hctf=200, rq = 0.5, detune=0.01, accel=0.01, pan=0, freq|
  var sig, env;
	amp = amp*0.9;
  env = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: rel, level: amp), timeScale: sus, doneAction: 2);
  sig = BHPF.ar(RLPF.ar(SawDPW.ar(freq * Line.kr(1,1+accel, sus+rel),1), lctf*env, rq), freq:hctf);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\bassy3, {
  |out=0, amp=0.9, atk=0.01, sus=0.5, rel=2, ffreq=1200, rq = 0.5, dist=0, detune=0.01, accel=0.01, pan=0, freq|
  var sig, env;
	amp = amp*0.9;
  env = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: rel, level: amp), timeScale: sus, doneAction: 2);
  sig = RLPFD.ar(SawDPW.ar(freq * Line.kr(1,1+accel, sus+rel),1), ffreq:ffreq, res:rq, dist:dist, mul:amp*2);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\piano, {
  |out=0, amp=0.9, atk=0.01, dec=0.5, sus=1, rel=0.25, gate=0.5, stretch=0.1, tune=0.5, feed=0.5, pan=0, freq|
  var sig, env;
  amp = amp*0.9;
  env = EnvGen.ar(Env.perc(atk, rel), timeScale: sus, doneAction:2);
  sig = MdaPiano.ar(freq, gate:gate, stretch:stretch, tune:tune, decay:dec, sustain: sus, release:rel, stereo:pan, mul:amp);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;


// other

SynthDef.new(\kell,{
  |out, amp=0.9, atk=0.01, dec=0.5, sus=1, rel=0.25, gate=1, pan=0, freq|
  var sig, env;
  amp = amp * 0.9;
  env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate:gate, doneAction: 2);
  sig = Klang.ar(`[
    [243.76316562296.rand, 173.56766553642.rand, 85.131794236476.rand]+freq,
    0.5.rand!3,
    pi.rand!3], 1, 0)*0.5;
  sig = sig * amp * env;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\dust, {
  |out=0, amp=0.9, atk=0.01, sus=1, rel=0.25, rq=0.25, detune=1, pan=0, freq|
  var sig, env;
  amp = amp*0.9;
  env = EnvGen.ar(Env.perc(atk, rel), timeScale: sus, doneAction:2);
  sig = LPF.ar(Ringz.ar(Dust.ar(freq), freq*2.rand.max(9000)), 8000)*0.5;
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\pulse, {
  |out, amp=0.9, atk=0.001, sus=1, rel=0.5, accel=0.01, detune=0.1, ffreq=1250, pan=0, freq|
  var sig, env;
  amp = amp*0.9;
	env = EnvGen.ar(Env.perc(atk, rel), timeScale: sus/ 2, doneAction:2);
	sig = RLPF.ar(LFPulse.ar([freq, freq],0.5), freq:ffreq, rq:1, mul:amp);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\can, {
  |out=0, amp=0.9, atk=0.01, sus=1, rel=0.25, vib=10, phase=0.5, pan=0, freq|
  var sig, env;
	amp = amp*0.9;
  env = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: rel, level: amp), timeScale: sus, doneAction: 2);
  sig = Vibrato.ar(FreqShift.ar(LFTri.ar(freq, phase), freq/2), rate:vib);
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\sin, {
  |out, amp=0.9, atk=0.001, sus=1, rel=1, accel=0, detune=0.1, pan=0, freq|
  var sig, env;
  amp = amp*0.9;
	env = EnvGen.ar(Env.perc(atk, rel), timeScale: sus / 2, doneAction: 2);
	sig = SinOsc.ar([freq, freq+detune] * Line.kr(1,1+accel, sus));
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

SynthDef(\saw, {
  |out, amp=0.9, atk=0.001, sus=1, rel=0.5, accel=0.01, detune=0.1, pan=0, freq|
  var sig, env;
  amp = amp*0.9;
	env = EnvGen.ar(Env.perc(atk, rel), timeScale: sus/ 2, doneAction:2);
	sig = SawDPW.ar([freq, freq+detune] * Line.kr(1,1+accel, sus));
  sig = sig * env * amp;
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add;

// foxdot

SynthDef.new(\soprano,
  {|out=0, amp=0.9, atk=0.01, sus=1, rel=0.5, vib=5, slide=0, rate=1, verb=0.5, slidefrom=1, fmod=0, pan=0, freq|
  var osc, env;
  amp = amp * 0.9;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sus);
  freq = Vibrato.kr(freq, rate: vib);
  env = EnvGen.ar(Env.perc(attackTime: atk, releaseTime: rel, level: amp), timeScale: sus, doneAction: 2);
  osc = (SinOsc.ar((freq * 3), mul: amp) + SinOscFB.ar((freq * 3), mul: (amp / 2)));
  osc = osc * env * amp;
  OffsetOut.ar(out, Pan2.ar(osc, pan));
}).add;


SynthDef.new(\varsaw,
  {|vib=0, out=0, slide=0, rate=1, sustain=1, slidefrom=1, fmod=0, amp=1, pan=0.5, freq|
  var osc, env;
  amp = amp * 0.9;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
  freq = Vibrato.kr(freq, rate: vib);
  osc=VarSaw.ar([freq, (freq * 1.005)], mul: (amp), width: rate);
  env=EnvGen.ar(Env(levels: [amp, amp, amp], curve: 'lin', times: (sustain / 2)), doneAction: 2);
  osc = osc * env * amp;
  OffsetOut.ar(out, Pan2.ar(osc, pan));

  }).add;

/*SynthDef.new(\pluck, {|vib=0, out=0, slide=0, sustain=1, slidefrom=1, fmod=0, amp=0.9, rate=1, bits=0, pan=0.5, freq|
  var osc, env;
  amp = amp * 0.9;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sustain);
  freq = Vibrato.kr(freq, rate: vib);
  freq=[freq, (freq + LFNoise2.ar(50).range(-2, 2))];
  osc=(SinOsc.ar((freq * 1.002), phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) + (SinOsc.ar(freq*rate, phase: VarSaw.ar(freq, width: Line.ar(1, 0.2, 2))) ));
  osc=osc * XLine.ar(amp, (amp / 10000), (sustain * 4), doneAction: 2)*0.75;
  osc = osc * env * amp;
  OffsetOut.ar(out, Pan2.ar(osc, pan));
}).add;*/

// noise

SynthDef.new(\crunch,
  {|out=0, amp=0.9, vib=0, slide=0, rate=1, sus=1, slidefrom=1, fmod=0, pan=0, freq|
  var osc, env;
  freq = freq + fmod;
  freq = Line.ar(freq * slidefrom, freq * (1 + slide), sus);
  freq = Vibrato.kr(freq, rate: vib);
  env = EnvGen.ar(Env.perc(level: (amp),curve: 0,attackTime: 0.01,releaseTime: 0.1+sus), doneAction: 2);
  osc = LFNoise0.ar(((Crackle.kr(1.75) * freq) * 30), mul: amp);
  osc = osc * env * amp;
  OffsetOut.ar(out, Pan2.ar(osc, pan));
}).add;

SynthDef.new(\noise,
  {|out=0, amp=0.9, atk=0.01, dec=0.5, sus=1, rel=0.5, vib=0, slide=0, rate=1,  slidefrom=1, fmod=0, rq=1, lctf=800, pan=0, freq|
    var osc, env;
    freq = freq + fmod;
    freq = Line.ar(freq * slidefrom, freq * (1 + slide), sus);
    freq = Vibrato.kr(freq, rate: vib);
    osc = RLPF.ar(LFNoise0.ar(freq, amp), lctf, rq, amp);
    env=EnvGen.ar(Env.adsr(attackTime: atk, decayTime:dec, sustainLevel:sus, releaseTime:rel), doneAction:2);
  osc = osc * env * amp;
  OffsetOut.ar(out, Pan2.ar(osc, pan));
}).add;

// samples
SynthDef(\break,
  {|out, bufnum=0, sample=0, pan=0|
    var pb, brk, env, sr;
    sr = 44100;
    env = EnvGen.ar(Env.perc, doneAction:2);
    pb = PlayBuf.ar(1, sample, loop:0);
    brk = Breakcore.ar(bufnum, pb, Impulse.kr(LFNoise0.kr(4,10,12)), Rand(sr/4, sr), 0) * env;
    OffsetOut.ar(out, Pan2.ar(brk, pan));
}).add;

SynthDef(\sampler,
  {|out, amp=0.9, atk=0.01, rel=1, pos=0, sample=0, rate=1, pan=0|
    var sig, env, begin, sr;
    sr = 44100;
    begin = BufDur.kr(sample)*sr * pos;
    env = EnvGen.ar(Env.linen(0.0,rel,0.0,1));
    sig = PlayBuf.ar(1, sample, rate:BufRateScale.ir(sample) * rate, trigger:1, startPos:begin, loop:0, doneAction:2);
    sig = sig * env * amp;
    OffsetOut.ar(out,Pan2.ar(sig, pan));
}).add;
)