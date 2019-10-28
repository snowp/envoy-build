set -x
filepath=$(realpath --relative-to=$(pwd) $1)
if [ "$2" = "all" ]; then
  filter_arg=""
else
  filter_arg="--test_filter=$2"
fi

if [ "$4" = "debug" ]; then
  bazel_cmd="tools/bazel-test-gdb"
  cfg_flag="-c dbg"
else
  bazel_cmd="bazel test"
  cfg_flag=""
fi

targets=$(bazel query "rdeps('//test/...', $filepath, 2)" --output=label_kind|grep cc_test|cut -d' ' -f3)
$(dirname "${BASH_SOURCE[0]}")/bin/eb $bazel_cmd $targets $cfg_flag $filter_arg --test_output=streamed --test_env=ENVOY_IP_TEST_VERSIONS=v4only --jobs 3
