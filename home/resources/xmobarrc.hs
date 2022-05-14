Config { 
     font               = "xft:#fontFace:size=#fontSize:bold:antialias=true"
   , bgColor            = "#black"
   , fgColor            = "#white"
   , position           = Top
   , border             = BottomB
   , borderColor        = "#black"
   , borderWidth        = 1
   , sepChar            = "%"
   , alignSep           = "}{"
   , template           = "  %StdinReader% }{ %battery%  %date%  "
   , lowerOnStart       = True
   , hideOnStart        = False
   , allDesktops        = True
   , pickBroadest       = False
   , persistent         = True
   , overrideRedirect   = True
   , commands = 
        [ Run StdinReader
        , Run Battery
            [ "--template"  , "<acstatus>"
            , "--Low"       , "10"
            , "--High"      , "80"
            , "--low"       , "#red"
            , "--normal"    , "#yellow"
            , "--high"      , "#green"
            , "--"
            , "-o"	        , "<left>% (<timeleft>)"
            , "-O"	        , "<fc=#yellow>Charging</fc>"
            , "-i"	        , "<fc=#green>Charged</fc>" ] 50
        , Run Date           "<fc=#blue>%F</fc>  %a  <fc=#green>%T</fc>" "date" 10 ] }
