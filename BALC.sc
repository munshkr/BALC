BALC {
     classvar s;

     *init{ |name|
           s = Server.default;

           if(name == "xi"){
                "Loading xi".postln;
           };
           if(name == "superdirt"){
                "Loading SuperDirt".postln;
                SuperDirt.start;
           };
           if(name == "superdirt2ch"){
                "Loading SuperDirt".postln;

                s.options.numBuffers = 1024 * 64;
                s.options.memSize = 8192 * 256;
                s.options.maxNodes = 1024 * 32;
                s.options.sampleRate= 44100;
                s.options.numOutputBusChannels = 2;
                s.recSampleFormat = "int24";
                s.options.numInputBusChannels = 2;
                s.waitForBoot {
                              ~dirt = SuperDirt(2, s);
                              ~dirt.loadSoundFiles;
                              s.sync;
                              ~dirt.start(57120, [0, 0, 0, 0]);
                              s.latency = 0.6;
                };
           };
           if(name == "superdirt8ch"){
                "Loading SuperDirt".postln;

                s.options.numBuffers = 1024 * 64;
                s.options.memSize = 8192 * 256;
                s.options.maxNodes = 1024 * 32;
                s.options.sampleRate= 44100;
                s.options.numOutputBusChannels = 8;
                s.recSampleFormat = "int24";
                s.options.numInputBusChannels = 2;
                s.waitForBoot {
                              ~dirt = SuperDirt(2, s);
                              ~dirt.loadSoundFiles;
                              s.sync;
                              ~dirt.start(57120, [0, 2, 4, 6]);
                              s.latency = 0.6;
                };
           };

           if (name == "foxdot"){
                "Loading FoxDot".postln;
                FoxDot.start;
           }
     }

     *loadSynthDefs{|name|
        var curDir = this.class.filenameSymbol.asString.dirname;
        load(curDir ++ "/SynthDefs/" ++ name ++ ".scd");
     }
}
