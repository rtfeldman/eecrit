module IV.Types exposing (..)

import Time exposing (second)

type DropsPerSecond = DropsPerSecond Float
type Level = Level Float
type Hours = Hours Float
  
asDuration : DropsPerSecond -> Float
asDuration (DropsPerSecond perSecond) = 
  if perSecond == 0.0 then
    10000.0 * second   -- a really slow leak...
  else
    (1 / perSecond) * second


