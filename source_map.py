import re
import lldb

to_lldb_str = lambda s: s.encode('utf8', 'backslashreplace') if isinstance(s, unicode) else s

mappings = {
        re.compile("/private/var/tmp/_bazel_snowp/5a2a4ebb675ed133ed4ac215d9beab6e/sandbox/darwin-sandbox/.*/execroot/envoy"): "/Users/snowp/Development/envoy"
        }

source_mapping = []

debugger_id = lldb.debugger_unique_id
debugger_name = lldb.debugger.FindDebuggerWithID(debugger_id).GetInstanceName()

m = lldb.debugger.GetSelectedTarget().GetModuleAtIndex(0)

print("units: {}".format(m.GetNumCompileUnits()))
print("module path: {}".format(m.GetFileSpec().GetDirectory()))
for idx in range(m.GetNumCompileUnits()):
    dir_path = m.GetCompileUnitAtIndex(idx).GetFileSpec().GetDirectory()
    for k, v in mappings.items():
        result = k.match(dir_path)
        if result is None:
            continue
        source_mapping.append(result.group(0))
        source_mapping.append(v)

source_mapping = '"' + '" "'.join([v.replace('\\', '\\\\').replace('"', '\\"') for v in source_mapping]) + '"'
print("sm: " + source_mapping)
lldb.SBDebugger.SetInternalVariable('target.source-map', to_lldb_str(source_mapping), debugger_name)
