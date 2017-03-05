// live audio input
(
SynthDef(\in, { |out, attack = 0.01, release = 1, lrq = 2, hrq = 2, lctf = 19000, hctf = 100, pan = 0, amp = 1|
	var in, env, snd;
  env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
  snd = RHPF.ar(RLPF.ar(SoundIn.ar([0,1]), lctf, lrq), hctf, hrq);
  OffsetOut.ar(out, Pan2.ar(snd*env, pan, amp));
}).add;
)
