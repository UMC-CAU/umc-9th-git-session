if [[ \"$(git branch --show-current)\" == \"main\" ]]; then
  echo "커밋 개수가 1개입니다."
else
  echo "커밋 개수가 1개가 아닙니다."
fi