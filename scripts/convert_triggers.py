# coding=latin-1

# IMPORTANT:  Don't forget to replace 'í' with 'Ae' in the output file.
# IMPORTANT:  Don't forget to replace 'Ç' with 'e' in the output file.
print "IMPORTANT:  Don't forget to make character replacements (see source of this file)"

import pdb, csv

# Open the input file and set up the output file.
lines = csv.reader(open('triggers.csv'))

out = open('triggers.array', 'w')
out.write('<?xml version="1.0" encoding="UTF-8"?>\n')
out.write('<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n')
out.write('<plist version="1.0">\n')
out.write('<array>\n')

# For each line in the file
for i, line in enumerate(lines):
    
    # Make sure line isn't empty
    if len(line) == 0:
        continue
        
    # Skip the header line
    if i == 0:
        continue
        
    # Get rid of some weird characters
    for i, part in enumerate(line):
        line[i] = part.replace('í', 'Ae')
        
    #if line[0] == 'Huntmaster of the Fells':
    #    pdb.set_trace()
    
    # Iterate through each of the 4 trigger fields and see if there's anything there.
    triggers = []
    for index in range(99, 103):
        try:
            part = line[index]
        except:
            pdb.set_trace()
        if len(part) > 0:
            triggers.append(part)
    
    # If there's something there for triggers, add it to the output file.
    if len(triggers) > 0:
        out.write('\t<array>\n')
        out.write('\t\t<string>' + line[0] + '</string>\n')
        for trigger in triggers:
            out.write('\t\t<string>' + trigger + '</string>\n')
        out.write('\t</array>\n')

out.write('</array>')
out.write('</plist>')
out.close()