# This script only fixes some of the Oracle problems", "a lot still has to be done manually (see the Readme)
import pdb

cards = ["Butcher's Cleaver", "Memory's Journey", "Stitcher's Apprentice", "Altar's Reap", "Avacyn's Pilgrim", "Curse of Death's Hold", "Devil's Play", "Full Moon's Rise", "Geistcatcher's Rig", "Ghoulcaller's Bell", "Ghoulcaller's Chant", "Heretic's Punishment", "Inquisitor's Flail", "Ludevic's Abomination", "Ludevic's Test Subject", "Nightbird's Clutches", "Ranger's Guile", "Runechanter's Pike", "Traveler's Amulet"]

files = [open("oracle_names_only.array").read().split('\n')]
for i in range(26):
    files.append(open("oracle_" + str(i) + ".array").read().split('\n'))

for card in cards:
    for i, f in enumerate(files):
        for j, line in enumerate(f):
            if (card + ' (' + card + ')') in line:
                line = line.replace((card + ' (' + card + ')'), card)
                files[i][j] = line

for i in range(27):
    if i == 0:
        name = "oracle_names_only.array"
    else:
        name = "oracle_" + str(i-1) + ".array"
    
    f = open(name, "w")
    f.write("\n".join(files[i]))
    f.close()
