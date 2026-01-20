export def _screenshot_handle [imgpath: string, --save] {
  if $save {
    let outdir = ($env.HOME | path join 'Pictures/Screenshots')
    mkdir $outdir
    let outfile = ($outdir | path join
      $"screenshot_(date now | format date '%Y%m%d_%H%M%S').png")
    mv $imgpath $outfile
    print $"Saved screenshot to: ($outfile)"
  } else {
    open $imgpath | wl-copy --type image/png
    print "Screenshot copied to clipboard."
    rm $imgpath
  }
}

export def main [--save] {
  let tmp = (mktemp --tmpdir screenshot_XXXXXX.png)
  grim $tmp
  _screenshot_handle $tmp --save=$save
}

export def 'region' [--save] {
  let tmp = (mktemp --tmpdir screenshot_XXXXXX.png)
  let region = (slurp)
  grim -g $region $tmp
  _screenshot_handle $tmp --save=$save
  echo $region | save --force ~/.cache/last_region.txt
}

export def 'repeat' [--save] {
  let tmp = (mktemp --tmpdir screenshot_XXXXXX.png)
  if ('~/.cache/last_region.txt' | path exists) {
    let region = (open ~/.cache/last_region.txt)
    grim -g $region $tmp
    _screenshot_handle $tmp --save=$save
  } else {
    print "No previous region found."
  }
}
