import sys
import json

palette = json.loads(sys.argv[1])

for key, value in palette.items():
    print("#" + key + " " + value)
