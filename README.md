# BALC

For the SuperDirt/FoxDot helpers see `other-systems` branch. I don't think I'll maintaint those anymore since I'll focus on SuperCollider only.  
There are three files:

## `setup.scd`

My current SuperCollider configuration plus a *mastering* `Ndef` (see [here](https://github.com/musikinformatik/SuperDirt/blob/master/hacks/filtering-dirt-output.scd) and [here](https://mccormick.cx/news/entries/heuristic-for-algorave-mastering) for reference) and an "Amen" samples loader.

## `synths.scd`

A list of `SynthDef`s written by me except when noted.  
Here's a template for creating new `SynthDef`s
```
SynthDef(\name, {
  |out, amp=0.9, [...], pan=0, freq|
  var sig, env;
  amp = amp * 0.9;
  [...]
  OffsetOut.ar(out, Pan2.ar(sig, pan));
}).add
```

## `fx.scd`

Just a list of various effects.

## Why BALC?

In Argentina, during late 80's, early 90's there was a _scene_ of hardcore and punk bands called **Buenos Aires Hardcore** [0] [1]. So, basically, this is a play on words: **Buenos Aires Livecode** (read: a joke. i don't know, it started with a file called `balc.scd`, so that.)

[0] https://en.wikipedia.org/wiki/Buenos_Aires_Hardcore  
[1] https://www.youtube.com/watch?v=rtZjKpKjznM

## License

[![CC0](http://mirrors.creativecommons.org/presskit/buttons/88x31/svg/cc-zero.svg)](https://creativecommons.org/publicdomain/zero/1.0/)  
This work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/). 
