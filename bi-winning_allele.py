#!/usr/bin/env python 
#David Tack
#Same as biallele, except our two variants are spread across lines rather than by columns.

#Imports
import argparse
from collections import Counter

def read_in_data(data_file,header_prefix):
    '''Description'''
    sub_dict, SSR,unique_codes = {},{},{}
    datastream = ['','0','NA','Na','na','.',' ']
    with open(data_file,'r') as f:
        for line in f:
            if line.startswith(header_prefix):
                all_keys = [x for x in line.strip().split(',')[1:]]
            else:
                bits = line.strip().split(',')
                name = bits[0]
                if name in sub_dict:
                    part_a,part_b = bits[1:], sub_dict[name][1:]
                    sub_lyst = [[part_a[i],part_b[i]] for i in range(0,len(part_a))]
                    for x, b in zip(all_keys, sub_lyst):
                        locus, copies = x, [int(q) for q in b if q not in datastream]
                        SSR.setdefault(name, {})[locus] = Counter(copies)
                        for modifier in copies:
                            unique_codes['*'.join([locus,str(modifier)])] = ''
                    del sub_dict[name]#clean up a bit, save memory incase this gets seriously out of hand. 
                else:
                    sub_dict[name] = bits
    return SSR,sorted(unique_codes.keys())

def file_dumper( SSR_dict, SSR_index,outfyle):
  '''Id don't even know'''
  with open( outfyle, 'w' ) as f:
    col_names = ['SSR']+SSR_index
    f.write(','.join(col_names)+'\n')
    for k, v in SSR_dict.items():
      values = [str(SSR_dict[k][locus][int(count)]) for locus, count in [zed.split('*') for zed in SSR_index]]
      f.write(','.join([k]+values)+'\n')

if __name__ == '__main__':
    print ''
    parser = argparse.ArgumentParser(description='cleans up a crappy file format')
    parser.add_argument("in_file", type=str, help="The input file")
    parser.add_argument('-s',type=str, default='SSR', help='<str> [default = SSR] prefix of header line',dest='prefix')
    parser.add_argument('-o',type=str, default='out_file.csv', help='<str> [default = out_file.csv] output file ',dest='out')
    args = parser.parse_args()
    data, index_list = read_in_data(args.in_file,args.prefix)
    file_dumper(data,index_list,args.out)
