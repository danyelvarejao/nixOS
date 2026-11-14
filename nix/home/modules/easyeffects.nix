{ ... }:
let
  # Voice EQ for a Shure SM7B close-miked: tames proximity-effect boom,
  # adds presence and a little air. Values come from analysing a test recording.
  voiceEqBands = {
    band0 = {
      type = "Hi-pass";
      mode = "RLC (BT)";
      slope = "x2"; # 24 dB/oct
      frequency = 70.0;
      q = 0.707;
      gain = 0.0;
      width = 4.0;
      solo = false;
      mute = false;
    };
    band1 = {
      type = "Bell";
      mode = "RLC (BT)";
      slope = "x1";
      frequency = 300.0; # boxy low-mids, measured ~+9 dB over 1 kHz
      q = 1.0;
      gain = -2.5;
      width = 4.0;
      solo = false;
      mute = false;
    };
    band4 = {
      type = "Bell";
      mode = "RLC (BT)";
      slope = "x1";
      frequency = 110.0; # chest/body for a deeper voice
      q = 0.9;
      gain = 3.0;
      width = 4.0;
      solo = false;
      mute = false;
    };
    band2 = {
      type = "Bell";
      mode = "RLC (BT)";
      slope = "x1";
      frequency = 3000.0; # presence/intelligibility, kept below the 4.6 kHz sibilance peak
      q = 1.0;
      gain = 3.0;
      width = 4.0;
      solo = false;
      mute = false;
    };
    band3 = {
      type = "Hi-shelf";
      mode = "RLC (BT)";
      slope = "x1";
      frequency = 10000.0; # air; the SM7B is dark up here, but 8-9.5 kHz carries sibilance
      q = 0.707;
      gain = 1.5;
      width = 4.0;
      solo = false;
      mute = false;
    };
  };
in
{
  # PipeWire audio effects; runs as a background user service.
  services.easyeffects = {
    enable = true;
    preset = {
      input = "voz";
      output = "bass";
    };

    extraPresets.bass.output = {
      blocklist = [ ];
      plugins_order = [ "bass_enhancer#0" ];
      "bass_enhancer#0" = {
        bypass = false;
        amount = 6.0; # dB of synthesized harmonics; raise for more bass
        harmonics = 8.5;
        scope = 100.0; # Hz: frequencies below this are enhanced
        floor = 20.0;
        floor-active = false;
        blend = 0.0;
        input-gain = 0.0;
        output-gain = 0.0;
      };
    };

    # Microphone chain, tuned for the RØDECaster Duo at ~32 dB gain with a
    # Cloudlifter, a fan in the room and the Duo's own processing turned off.
    extraPresets.voz.input = {
      blocklist = [ ];
      plugins_order = [
        "deepfilternet#0"
        "gate#0"
        "equalizer#0"
        "bass_enhancer#0"
        "deesser#0"
        "limiter#0"
      ];

      # Removes the fan; capped so the voice doesn't turn metallic.
      "deepfilternet#0" = {
        bypass = false;
        model = "DeepFilterNet";
        mono-processing = true; # both Duo channels carry the same mic
        attenuation-limit = 30.0;
        post-filter-beta = 0.02;
        input-gain = 0.0;
        output-gain = 0.0;
      };

      # Gentle gate for what DeepFilterNet leaves between phrases.
      "gate#0" = {
        bypass = false;
        mode = "Downward";
        curve-threshold = -50.0;
        curve-zone = -6.0;
        reduction = -15.0;
        attack = 5.0;
        release = 250.0;
        makeup = 0.0;
        dry = -80.01;
        wet = 0.0;
        input-gain = 0.0;
        output-gain = 0.0;
      };

      "equalizer#0" = {
        bypass = false;
        mode = "IIR";
        num-bands = 5;
        split-channels = false;
        input-gain = 0.0;
        output-gain = 0.0;
        left = voiceEqBands;
        right = voiceEqBands;
      };

      # Deeper voice: low harmonics around the fundamental, like APHEX Big Bottom.
      "bass_enhancer#0" = {
        bypass = false;
        amount = 2.0;
        harmonics = 6.0;
        scope = 120.0;
        floor = 60.0;
        floor-active = true; # leave sub-rumble alone
        blend = 0.0;
        input-gain = 0.0;
        output-gain = 0.0;
      };

      # Basic, light de-esser: only touches harshness above 6 kHz, and only on loud S.
      # Stronger settings made the S sound muffled.
      "deesser#0" = {
        bypass = false;
        mode = "Split";
        detection = "RMS";
        threshold = -20.0;
        ratio = 2.0;
        laxity = 15;
        makeup = 0.0;
        f1-freq = 6000.0;
        f2-freq = 8000.0;
        f1-level = 0.0;
        f2-level = 0.0; # no extra sidechain emphasis
        f2-q = 1.0;
        input-gain = 0.0;
        output-gain = 0.0;
      };

      "limiter#0" = {
        bypass = false;
        mode = "Herm Thin";
        threshold = -1.0;
        lookahead = 5.0;
        attack = 5.0;
        release = 10.0;
        gain-boost = false;
        input-gain = 0.0;
        output-gain = 0.0;
      };
    };
  };
}
