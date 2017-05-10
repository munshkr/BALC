(
// simple patch cord
SynthDef.new(\patch,{
  |in, out, amp=0.9|
  OffsetOut.ar(out, In.ar(in, 2) * (amp*0.9));
}, metadata: (credit: "http://github.com/lvm/balc")).add;


~dirt.addModule('distort', {
  |dirtEvent|
  dirtEvent.sendSynth('dirt_distort' ++ ~dirt.numChannels,
    [
      distort: ~distort,
      out: ~out
    ]
	)
}, { ~distort.notNil });
SynthDef("dirt_distort" ++ ~dirt.numChannels, {
  |out, distort=0.5|
  var sig;
  distort = distort.clip(0.01, 1.0); //max(0.01).min(1.0);
  sig = CrossoverDistortion.ar(In.ar(out, ~dirt.numChannels), 0.9, (1.0 - distort));
  ReplaceOut.ar(out, LeakDC.ar(sig));
}, metadata: (credit: "http://github.com/lvm/balc")).add;


~dirt.addModule('tremolo', {
  |dirtEvent|
  dirtEvent.sendSynth('dirt_tremolo' ++ ~dirt.numChannels,
    [
      tremolo: ~tremolo,
      out: ~out
    ]
	)
}, { ~tremolo.notNil });
SynthDef("dirt_tremolo" ++ ~dirt.numChannels, {
  |out, tremolo=0.5|
  var sig;
  sig = In.ar(out, ~dirt.numChannels) * SinOsc.ar(tremolo.min(50), 0, 0.9);
  ReplaceOut.ar(out, sig);
}, metadata: (credit: "http://github.com/lvm/balc")).add;


~dirt.addModule('wah', {
  |dirtEvent|
  dirtEvent.sendSynth('dirt_wah' ++ ~dirt.numChannels,
    [
      wah: ~wah,
      out: ~out
    ]
	)
}, { ~wah.notNil });
SynthDef("dirt_wah" ++ ~dirt.numChannels, {
  |out, wah|
  var sig;
  sig = In.ar(out, ~dirt.numChannels);
  sig = LPF.ar(sig, LinExp.ar(SinOsc.ar(wah.min(50)), -1, 1, 40, 19500));
  ReplaceOut.ar(out, sig);
}, metadata: (credit: "http://github.com/lvm/balc")).add;


/*~dirt.addModule('eco', {
  |dirtEvent|
  dirtEvent.sendSynth('dirt_eco' ++ ~dirt.numChannels,
    [
      eco: ~eco,
      gain: ~gain,
      ecodelay: ~ecodelay,
      ecodecay: ~ecodecay,
      out: ~out
    ]
	)
}, { ~eco.notNil });
SynthDef("dirt_eco" ++ ~dirt.numChannels, {
  |out, gain, eco, ecodelay/*=0.125*/, ecodecay/*=3*/|
  var in, sig;
  in = In.ar(out, ~dirt.numChannels);
	sig = CombL.ar(in, 1.0, ecodelay, ecodecay, gain, add: in);
  ReplaceOut.ar(out, sig);
}, metadata: (credit: "http://github.com/lvm/balc + tedthetrumpet: http://sccode.org/1-56x")).add;*/

~dirt.addModule('fm', { |dirtEvent|
	dirtEvent.sendSynth('dirt_fm' ++ ~dirt.numChannels,
		[fm: ~fm,	fmf: ~fmf,  out: ~out	]
	)
}, { ~fm.notNil or: { ~fmf.notNil } }); // play synth only if at least one of the two was given
SynthDef("dirt_fm" ++ ~dirt.numChannels, { |out, fm, fmf |
	var signal, mod;
	signal = In.ar(out, ~dirt.numChannels);
	mod = SinOsc.ar(fmf * (1.0 + fm * signal), mul:fm);
	ReplaceOut.ar(out, mod + (1.0-fm)*signal);
}, metadata: (credit: "bgold: https://gist.github.com/bgold-cosmos/e5fbf14f8c179f5576f8c12af001ad20")).add;
)