#!/usr/bin/env python2

import sys
import xml.etree.ElementTree as ET

filename = sys.argv[1]
package = sys.argv[2]

tree = ET.parse(filename)
root = tree.iter('{http://linux.duke.edu/metadata/common}package')
for pkg in root:
    name = pkg.find('{http://linux.duke.edu/metadata/common}name')
    if name.text == package:
        version = pkg.find('{http://linux.duke.edu/metadata/common}version')
        print version.attrib["ver"]
        sys.exit(0)

sys.exit(1)
