(
// filters
SynthDef.new(\lpf,{
  |in, out=0, amp=0.9, rq=1, freq=19000|
  var sig;
  sig = In.ar(in, 2);
  sig = LPF.ar(sig, freq:freq, mul:amp);
  OffsetOut.ar(out, sig);
}).add;

SynthDef.new(\hpf,{
  |in, out=0, amp=0.9, rq=1, freq=10|
  var sig;
  sig = In.ar(in, 2);
  sig = HPF.ar(sig, freq:freq, mul:amp);
  OffsetOut.ar(out, sig);
}).add;

// fx

SynthDef.new(\reverb,{
  |in, out=0, amp=0.9, mix=0.33, room=0.5, damp=0.5|
  var rev;
  rev = In.ar(in, 2);
  rev = FreeVerb.ar(rev, mix, room, damp, amp);
  OffsetOut.ar(out, rev);
}).add;

SynthDef(\delay, {
  |in, out=0, delay=0.0625, decay=0.25, wet=0.5|
  var sig;
	sig = In.ar(in,2);
  sig = AllpassL.ar(sig, delay, delay, decay, add:sig);
	Out.ar(out, sig);
}).add;

SynthDef.new(\distort,{
  |in, out=0, amp=0.125, smooth=0.75|
  var dst;
  dst = In.ar(in, 2);
  dst = CrossoverDistortion.ar(dst, amp, smooth);
  OffsetOut.ar(out, dst);
}).add;


// others

// tedthetrumpet: http://sccode.org/1-56x
SynthDef(\echo, { |out = 0, in = 0, max = 1.0, delay = 0.5, decay = 3, amp = 0.5, bypass = 0|
	var sig, insig;
	insig = In.ar(in, 2);
	sig = CombL.ar(insig, max, delay, decay, amp, add: insig) * EnvGate();
	Out.ar(out, bypass * insig + ((1 - bypass) * sig));
}).add;
)