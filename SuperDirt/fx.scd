(
/**
 * SuperDirt
 */


~dirt.addModule('noisy', {
  |dirtEvent|
  dirtEvent.sendSynth('dirt_noisy' ++ ~dirt.numChannels,
    [
      noisy: ~noisy,
      out: ~out
    ]
	)
}, { ~noisy.notNil });
SynthDef("dirt_noisy" ++ ~dirt.numChannels, {
  |out, noisy=0.5|
  var sig;
  noisy = noisy.clip(0.01, 1.0); //max(0.01).min(1.0);
  sig = CrossoverDistortion.ar(In.ar(out, ~dirt.numChannels), 0.25, (1.0 - noisy));
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
  sig = In.ar(out, ~dirt.numChannels) * SinOsc.ar(tremolo.min(50));
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
  sig = LPF.ar(sig, LinExp.ar(SinOsc.ar(wah.clip(0.01, 50)), -1, 1, 40, 19500));
  ReplaceOut.ar(out, sig);
}, metadata: (credit: "http://github.com/lvm/balc")).add;

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

~dirt.addModule('krush', { |dirtEvent|
  dirtEvent.sendSynth("dirt_krush" ++ ~dirt.numChannels,
    [krush: ~krush, kcutoff: ~kcutoff, out: ~out]
  )
}, { ~krush.notNil});
SynthDef("dirt_krush" ++ ~dirt.numChannels, {|out, krush, kcutoff|
  var orig, signal, freq;
  freq = Select.kr(kcutoff > 0, [DC.kr(4000), kcutoff]);
  orig = In.ar(out, ~dirt.numChannels);
  signal = (orig.squared + (krush*orig)) / (orig.squared + (orig.abs * (krush-1.0)) + 1.0);
  signal = RLPF.ar(signal, clip(freq, 20, 10000), 1);
  signal = SelectX.ar(krush*2.0, [orig, signal]);
  ReplaceOut.ar(out, signal);
}, metadata: (credit: "bgold: https://gist.github.com/bgold-cosmos/e5fbf14f8c179f5576f8c12af001ad20")).add;

~dirt.addModule('ring', { |dirtEvent|
  dirtEvent.sendSynth("dirt_ring" ++ ~dirt.numChannels,
    [ring: ~ring, ringf: ~ringf, out: ~out]
  )
}, { ~ring.notNil});
SynthDef("dirt_ring" ++ ~dirt.numChannels, {|out, ring=0, ringf=0|
  var signal, mod;
  signal = In.ar(out, ~dirt.numChannels);
  mod = ring * SinOsc.ar(clip(ringf, 2, 20000));
  signal = ring1(signal, mod);
  ReplaceOut.ar(out, signal);
}, metadata: (credit: "bgold: https://gist.github.com/bgold-cosmos/e5fbf14f8c179f5576f8c12af001ad20")).add;

~dirt.addModule('octer', { |dirtEvent|
  dirtEvent.sendSynth("dirt_octer" ++ ~dirt.numChannels,
    [octer: ~octer, octersub: ~octersub, octersubsub: ~octersubsub, out: ~out]
  )
}, { ~octer.notNil or: {~octersub.notNil } or: {~osctersubsub.notNil}});
SynthDef("dirt_octer" ++ ~dirt.numChannels, {|out, octer, octersub, octersubsub|
  var signal, oct1, oct2, oct3, sub;
  signal = In.ar(out, ~dirt.numChannels);
  oct1 = 2.0 * LeakDC.ar( abs(signal) );
  sub = LPF.ar(signal, 440);
  oct2 = ToggleFF.ar(sub);
  oct3 = ToggleFF.ar(oct2);
  signal = SelectX.ar(octer, [signal, octer.clip(0.01, 0.9)*oct1, DC.ar(0)]);
  signal = signal + (octersub * oct2 * sub) + (octersubsub * oct3 * sub);
  ReplaceOut.ar(out, signal);
}, metadata: (credit: "bgold: https://gist.github.com/bgold-cosmos/e5fbf14f8c179f5576f8c12af001ad20")).add;

~dirt.addModule('distort', { |dirtEvent| dirtEvent.sendSynth("dirt_distort" ++ ~dirt.numChannels,
			[distort: ~distort, out: ~out])}, { ~distort.notNil});
SynthDef("dirt_distort" ++ ~dirt.numChannels, {|out, distort=0|
	var signal, mod ;
	signal = In.ar(out, ~dirt.numChannels);
	mod = CrossoverDistortion.ar(signal, amp:0.2, smooth:0.01);
	mod = mod + (0.1 * distort * DynKlank.ar(`[[60,61,240,3000+SinOsc.ar(62,mul:100)],nil,[0.1, 0.1, 0.05, 0.01]], signal));
	mod = (mod.cubed * 8).softclip * 0.5;
	mod = SelectX.ar(distort, [signal, mod]);
	ReplaceOut.ar(out, mod);
}, metadata: (credit: "bgold: https://gist.github.com/bgold-cosmos/e5fbf14f8c179f5576f8c12af001ad20")).add;
)