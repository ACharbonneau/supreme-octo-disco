import sys
import re

sys_input = sys.argv

#sys_input = "Overlap.py Bn26a.txt-10_f.forparse"
#     NoRACoNo-2_f
#sys_input = sys_input.split()

file_input = open(sys_input[1], "r")

rm_end = r"(.*-\d+_f)\.forparse"

add_end = r"\1.parsed"

out_name = re.sub(rm_end, add_end, sys_input[1])

file_output = open(out_name, "w")

open_file = file_input.readlines()

para = r"\((\d+)\)"
fixpara = r"\1"

for line in open_file:
    line = line.strip()
    line = line.split()
    if len(line) < 6:
        line = ""
    else:
        line[2] = re.sub(para, fixpara, line[2])
        del line[4]
        for col in range(0, len(line)):
            file_output.write(line[col])
            if col < len(line)-1:
                file_output.write(",")
        file_output.write("\n")
            

file_input.close()
file_output.close()
