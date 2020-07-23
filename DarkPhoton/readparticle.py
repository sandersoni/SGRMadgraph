import csv
import sys

import numpy as np
import matplotlib.pyplot as pyplot
import pandas as pd

finalparticleid = []
initparticleid = []

print(sys.argv)
# program requires two inputs; the name of the file being read, and the label on the output file. For example:
# python read.py pythiaoutputfile energyspectrum
# will read the file pythiaoutputfile and then output a file energyspectrum

with open("{}".format(sys.argv[1]), "r") as f:
    for line in f:
        if line[0] != "P":
            continue
        data = line.split()[1:]

        final_vtx_id = int(data[10])
        init_vtx_id = int(data[0])
        # energy.append(float(data[5]))
        if init_vtx_id == 7:
            initparticleid.append(int(data[1]))

        if final_vtx_id == 0:
            finalparticleid.append(int(data[1]))


init_counts = np.unique(initparticleid,return_counts=True) #final state particle IDs and counts
for i in range(0,len(init_counts[0])):
    print("ID: %(ID)d, Initial Decays: %(COUNT)d" % {'ID': init_counts[0][i], 'COUNT': init_counts[1][i]})

final_counts = np.unique(finalparticleid,return_counts=True) #final state particle IDs and counts
for i in range(0,len(final_counts[0])):
    print("ID: %(ID)d, Final Products: %(COUNT)d" % {'ID': final_counts[0][i], 'COUNT': final_counts[1][i]})
