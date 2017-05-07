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
  sig = CrossoverDistortion.ar(In.ar(out, ~dirt.numChannels), 0.5, (1.0 -distort));
  ReplaceOut.ar(out, sig);
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
      wahf: ~wahf,
      out: ~out
    ]
	)
}, { ~wah.notNil or: { ~wahf.notNil } });
SynthDef("dirt_wah" ++ ~dirt.numChannels, {
  |out, wah, wahf=1|
  var sig;
  sig = In.ar(out, ~dirt.numChannels);
  sig = LPF.ar(sig, LinExp.ar(SinOsc.ar(wahf.min(50)), -1, 1, 100, 19500), mul: wah);
  ReplaceOut.ar(out, sig);
}, metadata: (credit: "http://github.com/lvm/balc")).add;


~dirt.addModule('eco', {
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
}, metadata: (credit: "http://github.com/lvm/balc + tedthetrumpet: http://sccode.org/1-56x")).add;
)