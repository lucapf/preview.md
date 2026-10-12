#!/bin/bash

set -euo pipefail

extension=${1##*.}
filename=${1%.*}
full_file_name=${1}

echo "start: file: ${1} full_file_name: ${full_file_name}"
render_plantum() {
  echo "render plantuml"
  plantuml ${full_file_name} --png
  clear
  open ${filename}.png
}

render_marp() {
  tmp_file="/tmp/marp.pdf"
  basedir=$(pwd)
  #  parent_dir=$(dirname $full_file_name)
  #  cd $parent_dir
  marp --pdf --allow-local-files -o "$tmp_file" "${full_file_name}"
  cd $basedir
  [[ $? -eq 0 ]] && open $tmp_file || exit 1
}

render_pandoc() {
  tmp_file="/tmp/marp.pdf"
  echo "render pandoc"
  parent_dir=$(dirname $full_file_name)
  cd $parent_dir
  pandoc ${filename}.${extension} -o ${tmp_file} &&
    open ${tmp_file}
}

render_openapi() {
  echo "render opanapi"
  if [[ -f ${full_file_name} ]]; then
    basedir=$(pwd)
    cp $1 /tmp
    cd /tmp
    open /tmp/docs/index.html
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
