#!/usr/bin/env bats

# usage
# $ bats unit_test.sh

@test "Check if pass.md works" {
  result="$(tldrl pass.md)"
  [ "$result" == "" ]
}

@test "Check if fail.md works" {
  run tldrl fail.md
  [ $status -eq 1 ]
}

@test "lint fail" {
  run bash ../new_command.sh fail.md
  [ $status -eq 1 ]
  [[ $(git ls-remote --heads origin fail) == "" ]]
}

@test "lint pass" {
  run bash ../new_command.sh pass.md
  [ $status -eq 0 ]
  [[ $(git ls-remote --heads origin pass) != "" ]]
}


teardown() {
  # clean up the mess git makes
  pass=$(git ls-remote --heads origin pass)
  if [[ $pass != "" ]]; then
    git checkout master
    git branch -d pass
    git push origin --delete pass
    cp pass.md.bak pass.md
  fi

  fail=$(git ls-remote --heads origin fail)
  if [[ $pass != "" ]]; then
    git checkout master
    git branch -d fail
    git push origin --delete fail
    cp fail.md.bak fail.md
  fi
}