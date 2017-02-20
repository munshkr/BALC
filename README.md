# BALC

A very simple SuperCollider Quark to start `SuperDirt` or `FoxDot`.

```
Quarks.install("http://github.com/lvm/BALCQuark")
// and go to `Language -> Recompile Class Library` in the main menu.

BALC.init("superdirt");
// or
BALC.init("foxdot");
// or
BALC.init("superdirt2ch");
// or
BALC.init("superdirt8ch");


BALC.loadSynthDefs("superdirt");
// or
BALC.loadSynthDefs("foxdot");
```

## SynthDefs

It contains a list of _custom_ SynthDefs in addition to the stock SynthDefs provided by both languages.

### SuperDirt

* kick
* snare
* snare1
* hihat
* hihat1
* bassy
* bassy1
* sin
* fm
* saw
* varsaw (a slight modification from the FoxDot's SynthDef)

### FoxDot

* kick8
* kick
* snare
* bassy


## Why BALC?

In Argentina, during late 80's, early 90's there was a _scene_ of hardcore and punk bands called **Buenos Aires Hardcore** [0] [1]. So, basically, this is a play on words: **Buenos Aires Livecode** (read: a joke. i don't know, it started with a file called `balc.scd`, so that.)

[0] https://en.wikipedia.org/wiki/Buenos_Aires_Hardcore  
[1] https://www.youtube.com/watch?v=rtZjKpKjznM

## License

[![CC0](http://mirrors.creativecommons.org/presskit/buttons/88x31/svg/cc-zero.svg)](https://creativecommons.org/publicdomain/zero/1.0/)  
This work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/). 
