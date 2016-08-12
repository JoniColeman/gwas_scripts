#!/usr/bin/python -tt

##Basic build identifier
##Run as ID_Build.py PLINK_CHROMSOME_6_FILE.bim
##Recommendation - run binary through plink before using this script - sets A1 as minor allele

import sys
import numpy as np
import pandas as pd

# Define a main() function
def main():
    if len(sys.argv) >= 2:
        with open(sys.argv[1]) as bim_6_file:
            Ref_hg18_dict = {'24979336' : 'C',
                             '32537182' : 'T',
                             '32647698' : 'A',
                             '24871357' : 'X',
                             '32429204' : 'X',
                             '32539620' : 'X',
                             '24871129' : 'X',
                             '32461427' : 'X',
                             '32571843' : 'X',
                             '168465326' : 'T',
                             '134105573' : 'T',
                             '116083117' : 'T',
                             '17839694' : 'T',
                             '11943869' : 'G',
                             '105624138' : 't',
                             '130013753' : 'G',
                             '168776041' : 'T',
                             '168722477' : 'X',
                             '134063880' : 'X',
                             '115976424' : 'X',
                             '17731715' : 'X',
                             '11834883' : 'X',
                             '105517445' : 'X',
                             '129972060' : 'X',
                             '169034116' : 'X',
                             '168321797' : 'X',
                             '133742742' : 'X',
                             '115655260' : 'X',
                             '17731484' : 'X',
                             '11834650' : 'X',
                             '105069570' : 'X',
                             '129650915' : 'X',
                             '168633436' : 'X'}
            Ref_hg19_dict = {'24979336' : 'X',
                             '32537182' : 'X',
                             '32647698' : 'A',
                             '24871357' : 'C',
                             '32429204' : 'T',
                             '32539620' : 'A',
                             '24871129' : 'X',
                             '32461427' : 'X',
                             '32571843' : 'X',
                             '168465326' : 'X',
                             '134105573' : 'X',
                             '116083117' : 'A',
                             '17839694' : 'X',
                             '11943869' : 'X',
                             '105624138' : 'X',
                             '130013753' : 'X',
                             '168776041' : 'X',
                             '168722477' : 'T',
                             '134063880' : 'T',
                             '115976424' : 'T',
                             '17731715' : 'T',
                             '11834883' : 'G',
                             '105517445' : 'T',
                             '129972060' : 'G',
                             '169034116' : 'T',
                             '168321797' : 'X',
                             '133742742' : 'X',
                             '115655260' : 'X',
                             '17731484' : 'X',
                             '11834650' : 'X',
                             '105069570' : 'X',
                             '129650915' : 'X',
                             '168633436' : 'X'}
            Ref_hg38_dict = {'24979336' : 'X',
                             '32537182' : 'X',
                             '32647698' : 'X',
                             '24871357' : 'X',
                             '32429204' : 'X',
                             '32539620' : 'X',
                             '24871129' : 'C',
                             '32461427' : 'T',
                             '32571843' : 'A',
                             '168465326' : 'X',
                             '134105573' : 'X',
                             '116083117' : 'X',
                             '17839694' : 'X',
                             '11943869' : 'X',
                             '105624138' : 'X',
                             '130013753' : 'X',
                             '168776041' : 'X',
                             '168722477' : 'X',
                             '134063880' : 'X',
                             '115976424' : 'X',
                             '17731715' : 'X',
                             '11834883' : 'X',
                             '105517445' : 'X',
                             '129972060' : 'X',
                             '169034116' : 'X',
                             '168321797' : 'T',
                             '133742742' : 'T',
                             '115655260' : 'T',
                             '17731484' : 'T',
                             '11834650' : 'G',
                             '105069570' : 'T',
                             '129650915' : 'G',
                             '168633436' : 'T'}
            bim_6_df = pd.read_table(bim_6_file, delim_whitespace=True, header=None, prefix='V', index_col=0, usecols=[3,4])
            if np.sum(bim_6_df.index.isin([24979336])) == 1:
                bim_6_dict = {'24979336' : bim_6_df.loc[24979336,'V4']}
            else:
                bim_6_dict = {'24979336' : 'X'}
            if np.sum(bim_6_df.index.isin([32537182])) == 1:
                bim_6_dict['32537182'] = bim_6_df.loc[32537182,'V4']
            else:
                bim_6_dict['32537182'] = 'X'
            if np.sum(bim_6_df.index.isin([32647698])) == 1:
                bim_6_dict['32647698'] = bim_6_df.loc[32647698, 'V4']
            else:
                bim_6_dict['32647698'] = 'X'
            if np.sum(bim_6_df.index.isin([24871357])) == 1:
                bim_6_dict['24871357'] = bim_6_df.loc[24871357, 'V4']
            else:
                bim_6_dict['24871357'] = 'X'
            if np.sum(bim_6_df.index.isin([32429204])) == 1:
                bim_6_dict['32429204'] = bim_6_df.loc[32429204, 'V4']
            else:
                bim_6_dict['32429204'] = 'X'
            if np.sum(bim_6_df.index.isin([32539620])) == 1:
                bim_6_dict['32539620'] = bim_6_df.loc[32539620, 'V4']
            else:
                bim_6_dict['32539620'] = 'X'
            if np.sum(bim_6_df.index.isin([24871129])) == 1:
                bim_6_dict['24871129'] = bim_6_df.loc[24871129, 'V4']
            else:
                bim_6_dict['24871129'] = 'X'
            if np.sum(bim_6_df.index.isin([32461427])) == 1:
                bim_6_dict['32461427'] = bim_6_df.loc[32461427, 'V4']
            else:
                bim_6_dict['32461427'] = 'X'
            if np.sum(bim_6_df.index.isin([32571843])) == 1:
                bim_6_dict['32571843'] = bim_6_df.loc[32571843, 'V4']
            else:
                bim_6_dict['32571843'] = 'X'
            if np.sum(bim_6_df.index.isin([168465326])) == 1:
                bim_6_dict['168465326'] = bim_6_df.loc[168465326, 'V4']
            else:
                bim_6_dict['168465326'] = 'X'
            if np.sum(bim_6_df.index.isin([134105573])) == 1:
                bim_6_dict['134105573'] = bim_6_df.loc[134105573, 'V4']
            else:
                bim_6_dict['134105573'] = 'X'
            if np.sum(bim_6_df.index.isin([116083117])) == 1:
                bim_6_dict['116083117'] = bim_6_df.loc[116083117, 'V4']
            else:
                bim_6_dict['116083117'] = 'X'
            if np.sum(bim_6_df.index.isin([17839694])) == 1:
                bim_6_dict['17839694'] = bim_6_df.loc[17839694, 'V4']
            else:
                bim_6_dict['17839694'] = 'X'
            if np.sum(bim_6_df.index.isin([11943869])) == 1:
                bim_6_dict['11943869'] = bim_6_df.loc[11943869, 'V4']
            else:
                bim_6_dict['11943869'] = 'X'
            if np.sum(bim_6_df.index.isin([105624138])) == 1:
                bim_6_dict['105624138'] = bim_6_df.loc[105624138, 'V4']
            else:
                bim_6_dict['105624138'] = 'X'
            if np.sum(bim_6_df.index.isin([130013753])) == 1:
                bim_6_dict['130013753'] = bim_6_df.loc[130013753, 'V4']
            else:
                bim_6_dict['130013753'] = 'X'
            if np.sum(bim_6_df.index.isin([168776041])) == 1:
                bim_6_dict['168776041'] = bim_6_df.loc[168776041, 'V4']
            else:
                bim_6_dict['168776041'] = 'X'
            if np.sum(bim_6_df.index.isin([168722477])) == 1:
                bim_6_dict['168722477'] = bim_6_df.loc[168722477, 'V4']
            else:
                bim_6_dict['168722477'] = 'X'
            if np.sum(bim_6_df.index.isin([134063880])) == 1:
                bim_6_dict['134063880'] = bim_6_df.loc[134063880, 'V4']
            else:
                bim_6_dict['134063880'] = 'X'
            if np.sum(bim_6_df.index.isin([115976424])) == 1:
                bim_6_dict['115976424'] = bim_6_df.loc[115976424, 'V4']
            else:
                bim_6_dict['115976424'] = 'X'
            if np.sum(bim_6_df.index.isin([17731715])) == 1:
                bim_6_dict['17731715'] = bim_6_df.loc[17731715, 'V4']
            else:
                bim_6_dict['17731715'] = 'X'
            if np.sum(bim_6_df.index.isin([11834883])) == 1:
                bim_6_dict['11834883'] = bim_6_df.loc[11834883, 'V4']
            else:
                bim_6_dict['11834883'] = 'X'
            if np.sum(bim_6_df.index.isin([105517445])) == 1:
                bim_6_dict['105517445'] = bim_6_df.loc[105517445, 'V4']
            else:
                bim_6_dict['105517445'] = 'X'
            if np.sum(bim_6_df.index.isin([129972060])) == 1:
                bim_6_dict['129972060'] = bim_6_df.loc[129972060, 'V4']
            else:
                bim_6_dict['129972060'] = 'X'
            if np.sum(bim_6_df.index.isin([169034116])) == 1:
                bim_6_dict['169034116'] = bim_6_df.loc[169034116, 'V4']
            else:
                bim_6_dict['169034116'] = 'X'
            if np.sum(bim_6_df.index.isin([168321797])) == 1:
                bim_6_dict['168321797'] = bim_6_df.loc[168321797, 'V4']
            else:
                bim_6_dict['168321797'] = 'X'
            if np.sum(bim_6_df.index.isin([133742742])) == 1:
                bim_6_dict['133742742'] = bim_6_df.loc[133742742, 'V4']
            else:
                bim_6_dict['133742742'] = 'X'
            if np.sum(bim_6_df.index.isin([115655260])) == 1:
                bim_6_dict['115655260'] = bim_6_df.loc[115655260, 'V4']
            else:
                bim_6_dict['115655260'] = 'X'
            if np.sum(bim_6_df.index.isin([17731484])) == 1:
                bim_6_dict['17731484'] = bim_6_df.loc[17731484, 'V4']
            else:
                bim_6_dict['17731484'] = 'X'
            if np.sum(bim_6_df.index.isin([11834650])) == 1:
                bim_6_dict['11834650'] = bim_6_df.loc[11834650, 'V4']
            else:
                bim_6_dict['11834650'] = 'X'
            if np.sum(bim_6_df.index.isin([105069570])) == 1:
                bim_6_dict['105069570'] = bim_6_df.loc[105069570, 'V4']
            else:
                bim_6_dict['105069570'] = 'X'
            if np.sum(bim_6_df.index.isin([129650915])) == 1:
                bim_6_dict['129650915'] = bim_6_df.loc[129650915, 'V4']
            else:
                bim_6_dict['129650915'] = 'X'
            if np.sum(bim_6_df.index.isin([168633436])) == 1:
                bim_6_dict['168633436'] = bim_6_df.loc[168633436, 'V4']
            else:
                bim_6_dict['168633436'] = 'X'
            hg_18_score = 0
            hg_19_score = 0
            hg_38_score = 0
            Test = ''.join('{}'.format(val) for key, val in sorted(bim_6_dict.items()))
            hg_18_ref = ''.join('{}'.format(val) for key, val in sorted(Ref_hg18_dict.items()))
            hg_19_ref = ''.join('{}'.format(val) for key, val in sorted(Ref_hg19_dict.items()))
            hg_38_ref = ''.join('{}'.format(val) for key, val in sorted(Ref_hg38_dict.items()))
            for i in range(len(Test)):
                if Test[i] == 'X':
                    continue
                if Test[i] != 'X':
                    if hg_18_ref[i] == Test[i]:
                        hg_18_score += 1
                    if hg_19_ref[i] == Test[i]:
                        hg_19_score += 1
                    if hg_38_ref[i] == Test[i]:
                        hg_38_score += 1
            hg_18_length = 0
            hg_19_length = 0
            hg_38_length = 0
            for i in range(len(hg_18_ref)):
                if hg_18_ref[i] == 'X':
                    continue
                if hg_18_ref[i] != 'X':
                    hg_18_length += 1
            for i in range(len(hg_19_ref)):
                if hg_19_ref[i] == 'X':
                    continue
                if hg_19_ref[i] != 'X':
                    hg_19_length += 1
            for i in range(len(hg_38_ref)):
                if hg_38_ref[i] == 'X':
                    continue
                if hg_38_ref[i] != 'X':
                    hg_38_length += 1
            print '\n'
            if hg_18_score > hg_19_score:
                if hg_18_score > hg_38_score:
                    print 'Probable build is hg18'
                if hg_18_score < hg_38_score:
                    print 'Probable build is hg38'
                if hg_18_score == hg_38_score:
                    print 'Cannot determine build'
            if hg_18_score < hg_19_score:
                if hg_19_score > hg_38_score:
                    print 'Probable build is hg19'
                if hg_19_score < hg_38_score:
                    print 'Probable build is hg38'
                if hg_19_score == hg_38_score:
                    print 'Cannot determine build'
            if hg_18_score == hg_19_score:
                if hg_18_score < hg_38_score:
                    print 'Probable build is hg38'
                if hg_18_score >= hg_38_score:
                    print 'Cannot determine build'
            print '\nhg18 reference:'
            print hg_18_ref
            print 'Test:'
            print Test
            print 'Match:'
            print hg_18_score, 'out of', hg_18_length
            print '\nhg19 reference:'
            print hg_19_ref
            print 'Test:'
            print Test
            print 'Match:'
            print hg_19_score, 'out of', hg_19_length
            print '\nhg38 reference:'
            print hg_38_ref
            print 'Test:'
            print Test
            print 'Match:'
            print hg_38_score, 'out of', hg_38_length
    else:
        print 'Give me a PLINK .bim file please. Chromosome 6, not pruned for preference'

# This is the standard boilerplate that calls the main() function.
if __name__ == '__main__':
    main()
