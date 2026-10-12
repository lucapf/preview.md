#!/bin/zsh

set -euo pipefail

extension=${1##*.}
filename=${1%.*}
full_file_name=${1}

echo "start: file: ${1} full_file_name: ${full_file_name}"

# Open a file with the OS default viewer: `open` on macOS, `xdg-open` on Linux.
open_file() {
  if [[ "$(uname)" == "Darwin" ]]; then
    open "$1"
  else
    # Detach so the viewer doesn't keep Neovim's vim.system():wait() blocked
    nohup xdg-open "$1" >/dev/null 2>&1 &
  fi
}

render_plantum() {
  echo "render plantuml"
  plantuml ${full_file_name} --png
  clear
  open_file "${filename}.png"
}

render_marp() {
  tmp_file="/tmp/marp.pdf"
  basedir=$(pwd)
  #  parent_dir=$(dirname $full_file_name)
  #  cd $parent_dir
  if marp --pdf --allow-local-files -o "$tmp_file" "${full_file_name}"; then
    cd $basedir
    open_file "$tmp_file"
  else
    exit 1
  fi
}

render_pandoc() {
  tmp_file="/tmp/marp.pdf"
  echo "render pandoc"
  parent_dir=$(dirname $full_file_name)
  cd $parent_dir
  pandoc ${filename}.${extension} -o ${tmp_file} &&
    open_file "${tmp_file}"
}

render_openapi() {
  echo "render opanapi"
  if [[ -f ${full_file_name} ]]; then
    basedir=$(pwd)
    cp $1 /tmp
    cd /tmp
    open_file /tmp/docs/index.html
    openapi-generate $1
    return
  else
    echo "cannot find the file $1, abort"
    return
  fi
  if [[ $? -eq 0 ]]; then
    echo " done, pls open inde.html file or refresh in the browser"
  else
    echo "error during the rendering, pls check the output."
  fi
}

case $full_file_name in
*.puml)
  render_plantum
  ;;
*.md)
  echo "render md"
  if [ ! -z "$(head -15 $1 | grep '^marp: true')" ]; then
    render_marp
  else
    render_pandoc
  fi
  ;;
*)
  echo "$extension not supported! pls check "
  ;;
esac
