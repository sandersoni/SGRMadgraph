import math
import sys

import matplotlib.pyplot as pyplot
import numpy as np
import pandas as pd


def main():
    intparticles = []
    finalparticles = []
    print(sys.argv)
    # program requires two inputs; the name of the file being read, and the label on the output file. For example:
    # python read.py pythiaoutputfile energyspectrum
    # will read the file pythiaoutputfile and then output a file energyspectrum

    i = 0

    with open("{}".format(sys.argv[1]), "r") as f:
        for line in f:
            if line[0] != "P":
                continue
            data = line.split()[1:]
            if i == 0:
                datap = data

            pdg_id = int(data[1])
            pdg_idp = int(datap[1])

            if pdg_id < 0 and pdg_id == -pdg_idp:
                intparticles.append({"pdg": int(data[1]), "energy": float(data[5])})
                intparticles.append({"pdg": -int(data[1]), "energy": float(data[5])})
            datap = data
            i += 1

            vtx_id = int(data[10])
            if vtx_id == 0:
                finalparticles.append({"pdg": int(data[1]), "energy": float(data[5])})
    intparticlespd = pd.DataFrame(intparticles)
    finalparticlespd = pd.DataFrame(finalparticles)
    print("intermediate lepton PDGs:\n", intparticlespd["pdg"].value_counts())
    print("final particle PDGs:\n", finalparticlespd["pdg"].value_counts())
    # particles.query('pdg == 100001')['energy'].hist(bins=[0,500,1600,5000,15700,50000,158100],log=True)

    # particles.query('pdg == -11')['energy'].hist(log=True)
    lep = [
        p["energy"]
        for p in intparticles
        if p["pdg"] == -11 or p["pdg"] == 11 or p["pdg"] == -13 or p["pdg"] == 13
    ]
    # dp = [p["energy"] for p in finalparticles if p["pdg"] == 22]
    # pyplot.hist(lep, alpha=0.5)
    # pyplot.hist(dp, alpha=0.5)
    # pyplot.xscale("log")
    # pyplot.savefig("spectrum.png")
    # pyplot.show()

    dpl = [math.log(p["energy"], 10) for p in finalparticles if p["pdg"] == 22]
    bins = np.linspace()
    pyplot.hist(dpl)
    pyplot.savefig("photonE2.png")


if __name__ == "__main__":
    main()
