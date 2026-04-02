# diff two conda-lock files, first old, then new
import yaml, sys

def parse_lock(path):
    with open(path) as f:
        data = yaml.safe_load(f)
    return {pkg["name"]: pkg["version"] for pkg in data["package"]}

old = parse_lock(sys.argv[1])
new = parse_lock(sys.argv[2])

all_keys = sorted(set(old) | set(new))

added, removed, changed, same = [], [], [], []
for k in all_keys:
    if k not in old:
        added.append(f"  + {k}  {new[k]}")
    elif k not in new:
        removed.append(f"  - {k}  {old[k]}")
    elif old[k] != new[k]:
        changed.append(f"  ~ {k}  {old[k]} -> {new[k]}")

print(f"ADDED ({len(added)}):")
print("\n".join(added) or "  none")
print(f"\nREMOVED ({len(removed)}):")
print("\n".join(removed) or "  none")
print(f"\nCHANGED ({len(changed)}):")
print("\n".join(changed) or "  none")
