set -x

# bazel clean --expunge
path=$(bazel test --run_under=echo --spawn_strategy=standalone --genrule_strategy=standalone $1 -c dbg --run_under=echo --test_output=all|grep 'Test output' -A1|tail -n1|cut -d' ' -f1)
pushd bazel-bin/$(dirname $path)
  dsymutil $(basename $path) -o $(basename $path).dSYM
popd

rm -f /tmp/vscode-bazel-symbolized-binary
rm -f /tmp/vscode-bazel-symbolized-binary
rm -f /tmp/vscode-bazel-symbolized-binary.dSYM
ln -s  $(pwd)/bazel-bin/$path /tmp/vscode-bazel-symbolized-binary
ln -s  $(pwd)/bazel-bin/$path.dSYM /tmp/vscode-bazel-symbolized-binary.dSYM
