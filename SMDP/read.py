import matplotlib.pyplot as pyplot
import pandas as pd
import csv
import sys

particles = []

print(sys.argv)
#program requires two inputs; the name of the file being read, and the label on the output file. For example:
#python read.py pythiaoutputfile energyspectrum
#will read the file pythiaoutputfile and then output a file energyspectrum

with open("{}".format(sys.argv[1]),"r") as f:
    for line in f:
        if line[0] != "P":
            continue
        data = line.split()[1:]

        vtx_id = int(data[10])
        if vtx_id == 0:
            particles.append({
                'pdg': int(data[1]),
                'energy': float(data[5])
                })
            # pdg_id = int(data[1])
            # if pdg_id == -13:
            #     muons.append(float(data[5]))
            # elif

particlespd = pd.DataFrame(particles)
print("Final particle PDGs:\n", particlespd['pdg'].value_counts())
#particles.query('pdg == 100001')['energy'].hist(bins=[0,500,1600,5000,15700,50000,158100],log=True)
#particles.query('pdg == 100001')['energy'].hist(log=True)
#dp = [p['energy'] for p in particles if p['pdg'] == 100001]
#pyplot.hist(dp)
# pyplot.xscale('log')
#pyplot.show()



#photonsE is energy of photons for bins 0-0.5, 0.5-1.6, 1.6-5, 5-15.7, 15.7-50, and 50-158.1 TeV
photons = [p['energy'] for p in particles if p['pdg'] == 22]
# print('{} final state photons'.format(len(photons)))
photonsE = []
photonsE.append((1.6 + 0.5)/2 * sum([e for e in photons if 500 < e < 1600])*0.001/(1.600 - 0.500))
photonsE.append((5. + 1.6)/2 * sum([e for e in photons if  1600  < e < 5000])*0.001/(5. - 1.6))
photonsE.append((15.7 + 5.)/2 * sum([e for e in photons if  5000  < e < 15700])*0.001/(15.7 - 5.))
photonsE.append((50. + 15.7)/2 * sum([e for e in photons if  15700  < e < 50000])*0.001/(50. - 15.7))
photonsE.append((158.1 + 50.)/2 * sum([e for e in photons if  50000  < e < 158100])*0.001/(158.1 - 50.))
#print(photonsE)
outstr =  sys.argv[2]
resultsFile = open(outstr,'w')
for l in photonsE:
    resultsFile.write("{}\n".format(l))
resultsFile.close()
