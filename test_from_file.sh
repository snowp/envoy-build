set -x
filepath=$(realpath --relative-to=$(pwd) $1)
if [ "$2" = "all" ]; then
  filter_arg=""
else
  filter_arg="--test_filter=$2"
fi

if [ "$3" == "all" ]; then
  filter="echo"
elif [ "$3" == "unit" ]; then
  filter="grep -v //test/integration"
else
  filter="grep //test/integration"
fi

bazel test -c dbg $(bazel query "rdeps('//test/...', $filepath)"|grep -v extensions|grep -v exe|grep -v server|grep -v coverage|$filter) $filter_arg --test_output=streamed
