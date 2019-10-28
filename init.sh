img=$(docker build -q .)
pushd ~/Development/envoy
  docker run --name envoy-build --cap-add sys_ptrace -idv $(pwd):/source -w /source $img sh
popd
pushd /Users/snowp/Development/go/src/git.sqcorp.co/sq/square-envoy
  docker run --name sq-envoy-build --cap-add sys_ptrace -idv $(pwd):/source -w /source $img sh
popd

