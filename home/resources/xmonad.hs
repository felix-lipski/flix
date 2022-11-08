import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

scratchpads = [ 
    NS "termscratchpad" "alacritty -t 'Scratchpad'" (title =? "Scratchpad") (customFloating $ W.RationalRect (2/3) (1/2) (11/36) (7/16)) ,
    NS "help" "alacritty -t 'Help Pad' -e 'nvim' '-R' '/home/felix/help.md'" (title =? "Help Pad") (customFloating $ W.RationalRect (2/7) (1/6) (3/7) (1/3)) ]

keyBindings :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keyBindings conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [ 
      ((modm, xK_q), kill)
    , ((modm, xK_w), spawn "qutebrowser")
    , ((modm, xK_e), spawn "emacsclient -c -a 'emacs'")
    , ((modm, xK_r), spawn "xmonad --restart")
    , ((modm, xK_a), spawn $ XMonad.terminal conf)
    , ((modm, xK_s), namedScratchpadAction scratchpads "termscratchpad")
    , ((modm, xK_d), spawn dmenu)
    , ((modm, xK_z), sendMessage NextLayout)
    , ((modm, xK_c), spawn "scrot")
    , ((modm .|. shiftMask, xK_c), spawn "scrot -s")
    , ((modm, xK_slash), namedScratchpadAction scratchpads "help")

    , ((modm, xK_j), windows W.focusDown)
    , ((modm, xK_k), windows W.focusUp)
    , ((modm .|. shiftMask, xK_j), windows W.swapDown)
    , ((modm .|. shiftMask, xK_k), windows W.swapUp)

    , ((modm, xK_m), windows $ W.greedyView "3")
    , ((modm, xK_space), windows $ \ssp -> 
        if W.currentTag ssp == "0" 
           then W.greedyView "1" ssp 
           else W.greedyView "0" ssp)
    , ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))
    , ((modm, xK_comma), sendMessage Shrink)
    , ((modm, xK_period), sendMessage Expand)
    ] ++ [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_u, xK_i, xK_o, xK_p]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]


dmenu = "dmenu_run -fn \"#fontFace\":bold:pixelsize=#fontSize -nb '#black' -nf '#white' -sb '#green' -sf '#white'"

myLayout = avoidStruts (noBorders Full) ||| (spacingRaw False (Border 4 4 4 4) True (Border 4 4 4 4) True $ tiled) 
  where
     tiled = Tall 1 (3/100) (1/2)

main :: IO ()
-- main = xmonad =<< statusBar "while read line; do echo $line >> /tmp/bar.log; done" myPP toggleStrutsKey defaults where
--     toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey defaults where
    toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- myPP = namedScratchpadFilterOutWorkspacePP $ xmobarPP {
--       ppCurrent = showWorkspace
--     , ppVisible = const "·"
--     , ppHidden  = const "·"
--     , ppHiddenNoWindows = xmobarColor "#grey" ""    . const "·"
--     , ppUrgent  = xmobarColor "#red"    ""          . const "!"
--     , ppTitle   = xmobarColor "#white"  "" . shorten 120            
--     , ppSep     =  "<fc=#white>  </fc>"
--     , ppWsSep   = "  "
--     , ppOrder   = \(ws:l:t:ex) -> [ws]++ex
--     -- , ppOrder   = \(ws:l:t:ex) -> [ws]++ex++[t]
--     }
myPP = namedScratchpadFilterOutWorkspacePP $ xmobarPP {
      ppCurrent = xmobarColor "#green"   ""          . showWorkspace
    , ppVisible = xmobarColor "#yellow" ""          . const "·"
    , ppHidden  = xmobarColor "#cyan"  ""          . const "·"
    , ppHiddenNoWindows = xmobarColor "#grey" ""    . const "·"
    , ppUrgent  = xmobarColor "#red"    ""          . const "!"
    , ppTitle   = xmobarColor "#white"  "" . shorten 120            
    , ppSep     =  "<fc=#white>  </fc>"
    , ppWsSep   = "  "
    , ppOrder   = \(ws:l:t:ex) -> [ws]++ex
    -- , ppOrder   = \(ws:l:t:ex) -> [ws]++ex++[t]
    }

showWorkspace :: String -> String
showWorkspace i = ["∅", "≡", "∀", "∓"] !! (read i)
-- showWorkspace i = ["α", "β", "τ", "μ"] !! (read i)

defaults = def {
      terminal           = "alacritty"
    , focusFollowsMouse  = True
    , clickJustFocuses   = False
    , borderWidth        = 1
    , modMask            = mod4Mask
    , workspaces         = (map show [0..3])
    , normalBorderColor  = "#grey"
    , focusedBorderColor = "#white"
    , keys               = keyBindings
    , mouseBindings      = myMouseBindings
    , layoutHook         = myLayout
    , manageHook         = fullscreenManageHook <+> namedScratchpadManageHook scratchpads
    , handleEventHook    = fullscreenEventHook
    , logHook            = return ()
    , startupHook        = spawn "nitrogen --set-auto ~/wallpaper.png"
    }
