// init
(
"Loading SuperDirt".postln;
s.options.numBuffers = 1024 * 64;
s.options.memSize = 8192 * 16;
s.options.maxNodes = 1024 * 32;
s.options.sampleRate = 44100;
s.options.numOutputBusChannels = 18;
s.options.numInputBusChannels = 2;
s.waitForBoot {
  StageLimiter.activate;
  ~dirt = SuperDirt(2, s);
  s.sync;
  ~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12, 14, 16]);
  3.wait;
  SuperDirt.default = ~dirt;
  TempoClock.default.tempo = 2;
  1.wait;
  "SuperDirt Loaded".postln;
  s.plotTree;
};
)

(
p = ProxySpace.push(s);
p.clock = TempoClock.default;
p.clock.tempo = 2.0;
p.fadeTime = 0.05;
p.quant = 4;
)

(
ProxyMixer.new(p);
)

// algorave mastering
// https://mccormick.cx/news/entries/heuristic-for-algorave-mastering
(
Ndef(\mix, {
	var level = 0.5;
	var distortion = 1;
	var reverbFeedback = 0.1;
	var all = ~chan.collect { |each| InBus.ar(each, each.numChannels) };
	var mix = all.sum { |x|
		var d = { 0.01.rand } ! x.size;
		DelayN.ar(x, d, d)
	};
	var loop = LocalIn.ar(2);
	5.do { loop = AllpassL.ar(loop, 0.15, { ExpRand(0.03, 0.15) } ! 2, 3) };
	mix = loop * reverbFeedback + mix;
	mix = LeakDC.ar(mix);
	LocalOut.ar(mix);
	mix = Compander.ar(mix, mix, 0.3, slopeBelow:1, slopeAbove:0.5, clampTime:0.01, relaxTime:0.01);
  mix = (mix * distortion).tanh * (level / distortion.max(1));
	mix
}).play;
)

// clear all
(
Ndef(\mix).clear;
~chan.do { |x| x.free };
);
