import XMonad
import System.IO
import XMonad.Hooks.ManageDocks
import Data.Maybe (fromJust)
import qualified Data.Map        as M
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce

myStartupHook = do
  spawn "picom"
  -- spawnOnce "xargs xwallpaper --stretch < ~/.cache/wall"
  -- spawnOnce "~/.fehbg &"  -- set last saved feh wallpaper
  spawn "feh --randomize --bg-fill ~/Pictures/wallpapers/*"  -- feh set random wallpaper
  -- spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh


myTerminal    = "kitty"
myModMask     = mod4Mask -- Win key or Super_L
myBorderWidth = 3

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices


main = do
  xmproc <- spawnPipe "xmobar /home/thefwboy/.config/xmobar/xmobarrc"
  xmonad $ def
    { terminal    = myTerminal
    , modMask     = myModMask
    , startupHook = myStartupHook
    , borderWidth = myBorderWidth
    , manageHook  = manageDocks <+> manageHook defaultConfig 
    , layoutHook  = avoidStruts  $  layoutHook defaultConfig
    , handleEventHook    = docksEventHook
    , workspaces  = myWorkspaces
    , logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
            , ppCurrent = wrap "<" ">"
            , ppVisible = wrap "" ""
            , ppHidden  = wrap "" ""
            , ppHiddenNoWindows = wrap "" ""
            , ppSep = "   "
      }
    }

