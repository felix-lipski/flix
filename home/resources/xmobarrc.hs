Config { 
     -- font =         "xft:Terminus:size=12:bold:antialias=true"
     font =         "xft:#fontFace:size=#fontSize:bold:antialias=true"
   , bgColor =      "#black"
   , fgColor =      "#white"
   , position =     Top
   , border =       BottomB
   , borderColor =  "#white"
   , borderWidth =  1
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = "%StdinReader% │ %battery% %multicpu% %coretemp% %memory% %dynnetwork% }{ %RJTT% │ %date%"
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)
   , commands = 
        [ Run Weather "RJTT" [ "--template", "<fc=#blue><skyCondition></fc> │ <fc=#blue><tempC></fc>°C"
                             ] 36000
        , Run DynNetwork     [ "--template" , "<tx>kB/s│<rx>kB/s"
                             , "--Low"      , "1000"       -- units: B/s
                             , "--High"     , "5000"       -- units: B/s
                             , "--low"      , "#green"
                             , "--normal"   , "#yelllow"
                             , "--high"     , "#red"
                             ] 10
        , Run MultiCpu       [ "--template" , "<total0>%"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#green"
                             , "--normal"   , "#yelllow"
                             , "--high"     , "#red"
                             ] 10
        , Run CoreTemp       [ "--template" , "<core0>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#green"
                             , "--normal"   , "#yelllow"
                             , "--high"     , "#red"
                             ] 50
        , Run Memory         [ "--template" , "<usedratio>%"
                             , "--Low"      , "20"        -- units: %
                             , "--High"     , "90"        -- units: %
                             , "--low"      , "#green"
                             , "--normal"   , "#yellow"
                             , "--high"     , "#red"
                             ] 10
        , Run Battery        [ "--template" , "<acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "#red"
                             , "--normal"   , "#yellow"
                             , "--high"     , "#green"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#yellow>Charging</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#green>Charged</fc>"
                             ] 50
        , Run Date           "<fc=#green>%F</fc> ⟨%a⟩ <fc=#green>%T</fc>" "date" 10
        , Run Kbd            [ ("us(dvorak)" , "<fc=#blue>DV</fc>")
                             , ("us"         , "<fc=#blue>US</fc>")
                             ]
	, Run StdinReader
        ]
   }
