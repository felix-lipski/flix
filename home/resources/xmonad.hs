import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

keyBindings :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keyBindings conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ [ 
      ((modm, xK_comma), sendMessage Shrink)
    , ((modm, xK_period), sendMessage Expand)
    , ((modm, xK_j), windows W.focusDown)
    , ((modm, xK_k), windows W.focusUp)
    , ((modm, xK_q), kill)
    , ((modm, xK_l), sendMessage NextLayout)
    , ((modm, xK_s), spawn "qutebrowser")
    , ((modm, xK_m), windows $ W.greedyView "3")
    , ((modm, xK_space), windows $ \ssp -> 
        if W.currentTag ssp == "0" 
           then W.greedyView "1" ssp 
           else W.greedyView "0" ssp)
    , ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_j), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k), windows W.swapUp    )
    , ((modm .|. shiftMask, xK_c), io (exitWith ExitSuccess))
    , ((modm, xK_c), spawn "xmonad --restart")
    , ((modm, xK_d), spawn 
        "dmenu_run -fn \"#fontFace\":bold:pixelsize=#fontSize -nb '#black' -nf '#white' -sb '#green' -sf '#white'")
    ] ++ [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_u, xK_i, xK_o, xK_p]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myLayout = avoidStruts (noBorders Full) ||| (spacingRaw False (Border 4 4 4 4) True (Border 4 4 4 4) True $ tiled) 
  where
     tiled = Tall 1 (3/100) (1/2)

main :: IO ()
main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey defaults where
    toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myPP = xmobarPP {
      ppCurrent = xmobarColor "#blue"   "" . showWorkspace
    , ppVisible = xmobarColor "#yellow" "" . const "·"
    , ppHidden  = xmobarColor "#white"  "" . const "·"
    , ppUrgent  = xmobarColor "#red"    "" . const "!"
    , ppTitle   = xmobarColor "#white"  "" . shorten 120
    , ppHiddenNoWindows = xmobarColor "#grey" "" . const "·"
    , ppSep     =  "<fc=#white>  </fc>"
    , ppWsSep   = "  "
    , ppOrder   = \(ws:l:t:ex) -> [ws]++ex++[t]
    }

showWorkspace :: String -> String
showWorkspace i = ["α", "β", "τ", "μ"] !! (read i)

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
    , mouseBindings      = const $ M.fromList []
    , layoutHook         = myLayout
    , manageHook         = fullscreenManageHook
    , handleEventHook    = fullscreenEventHook
    , logHook            = return ()
    , startupHook        = spawn "nitrogen --set-auto ~/wallpaper.png"
    }
