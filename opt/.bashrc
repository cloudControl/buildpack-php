for i in ~/.profile.d/*.sh; do
  if [ -r $i ]; then
    . $i
  fi
done
unset i
