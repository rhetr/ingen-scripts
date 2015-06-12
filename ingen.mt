#!/bin/bash
# requres 1 input arg

[ -z "$1" ] && echo "no track specified" && exit 1
TRACK=track_$1

## create graph
echo 'making graph'
ingenish put /$TRACK 'a ingen:Graph ; a lv2:Plugin' > /dev/null
echo 'making inputs'
ingenish put /$TRACK/left_in 'a lv2:InputPort ; a lv2:AudioPort ; lv2:name "Left In"' > /dev/null
ingenish put /$TRACK/right_in 'a lv2:InputPort ; a lv2:AudioPort ; lv2:name "Right In"' > /dev/null
echo 'making outputs'
ingenish put /$TRACK/left_out 'a lv2:OutputPort ; a lv2:AudioPort ; lv2:name "Left Out"' > /dev/null
ingenish put /$TRACK/right_out 'a lv2:OutputPort ; a lv2:AudioPort ; lv2:name "Right Out"' > /dev/null
echo 'making control input'
ingenish put /$TRACK/control_in 'a lv2:InputPort ; a atom:AtomPort ; lv2:name "Control In" ; atom:bufferType atom:Sequence ; atom:supports midi:MidiEvent ; lv2:portProperty lv2:connectionOptional ; <http://lv2plug.in/ns/ext/resize-port#minimumSize> 4096' > /dev/null
echo 'making controller'

## add eq and compressor
ingenish put /$TRACK/cntrlr 'a ingen:Block ; lv2:prototype <http://drobilla.net/ns/ingen-internals#Controller>' > /dev/null
#ingenish set /$TRACK/cntrlr/controller 'ingen:value 9'
#ingenish set /$TRACK/cntrlr/minimum 'ingen:value -70'
#ingenish set /$TRACK/cntrlr/maximum 'ingen:value 70'

echo 'making fader'
ingenish put /$TRACK/faderL 'a ingen:Block ; lv2:prototype <http://plugin.org.uk/swh-plugins/amp>' > /dev/null
ingenish put /$TRACK/faderR 'a ingen:Block ; lv2:prototype <http://plugin.org.uk/swh-plugins/amp>' > /dev/null

echo 'connecting'
ingenish connect /$TRACK/left_out  /left_out > /dev/null
ingenish connect /$TRACK/right_out /right_out > /dev/null
ingenish connect /control_in /$TRACK/control_in > /dev/null
ingenish connect /$TRACK/control_in /$TRACK/cntrlr/input > /dev/null
ingenish connect /$TRACK/cntrlr/output /$TRACK/faderL/gain > /dev/null
ingenish connect /$TRACK/cntrlr/output /$TRACK/faderR/gain > /dev/null
ingenish connect /$TRACK/faderL/output /$TRACK/left_out > /dev/null
ingenish connect /$TRACK/faderR/output /$TRACK/right_out > /dev/null

#ingenish put /$TRACK/meter 'a ingen:Block ; lv2:prototype <http://gareus.org/oss/lv2/meters#K20stereo>'
#ingenish connect /$TRACK/meter/outL /$TRACK/left_out
#ingenish connect /$TRACK/meter/outR /$TRACK/right_out
