find . -type f -name Chart.yaml | while read -r file; do
  echo $(dirname $file)
  cd $(dirname $file)
  helm dep up
  cd -
done
