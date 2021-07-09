#!/bin/sh
mame=/usr/lib/wolfmame/mame

mame_first_run() {
  echo "Creating an ini file for MAME at $HOME/.wolfmame/mame.ini"
  echo "Modify this file for permanent changes to your MAME"
  echo "options and paths before running MAME again."

  cd -- ~/.wolfmame || exit

  if [ -e mame.ini ]; then
    mv mame.ini mameini.bak || exit
    echo "Your old ini file has been renamed to mameini.bak"
  fi

  # Note: the single quotes here are not a mistake; MAME will save these
  # strings verbatim into its configuration file, and expand the variables when
  # it is run in future.
  "$mame" \
    -artpath '$HOME/.wolfmame/artwork;/usr/lib/mame/artwork' \
    -bgfx_path '$HOME/.wolfmame/bgfx;/usr/lib/mame/bgfx' \
    -ctrlrpath '$HOME/.wolfmame/ctrlr;/usr/lib/mame/ctrlr' \
    -hashpath '$HOME/.wolfmame/hash;/usr/lib/mame/hash' \
    -languagepath '$HOME/.wolfmame/language;/usr/lib/mame/language' \
    -pluginspath '/usr/lib/mame/plugins' \
    -inipath '$HOME/.wolfmame/ini' \
    -rompath '$HOME/.wolfmame/roms' \
    -samplepath '$HOME/.wolfmame/samples' \
    -cfg_directory '$HOME/.wolfmame/cfg' \
    -comment_directory '$HOME/.wolfmame/comments' \
    -diff_directory '$HOME/.wolfmame/diff' \
    -input_directory '$HOME/.wolfmame/inp' \
    -nvram_directory '$HOME/.wolfmame/nvram' \
    -snapshot_directory '$HOME/.wolfmame/snap' \
    -state_directory '$HOME/.wolfmame/sta' \
    -video opengl \
    -createconfig
}

if [ "$1" = "--newini" ]; then
  mame_first_run
  exit
elif ! [ -e ~/.wolfmame ]; then
  echo "Running WolfMAME for the first time..."

  mkdir -- ~/.wolfmame
  (
    cd -- ~/.wolfmame || exit
    mkdir artwork bgfx cfg comments ctrlr diff hash ini inp language nvram samples snap sta roms

    mame_first_run
  ) || exit
fi

exec "$mame" "$@"
