import numpy as np

def expan_perc(group):
    expand_type = group['expand_type']
    num_expan = (expand_type == 'expan').sum()
    return num_expan/len(expand_type)

def num_B(group):
    gt = group['fou_gt_chr13']
    num_B = (gt == 'B').sum()
    return num_B

def num_D(group):
    gt = group['fou_gt_chr13']
    num_D = (gt == 'D').sum()
    return num_D

def num_B_founder(group):
    gt = group['founder']
    num_B = (gt == 'B').sum()
    return num_B

def num_D_founder(group):
    gt = group['founder']
    num_D = (gt == 'D').sum()
    return num_D

def num_BD_founder_gt13(group):
    gt = group['founder']
    gt13 = group['fou_gt_chr13']
    num_BD = ((gt == 'B')&(gt13 =='D')).sum()
    return num_BD

def num_DD_founder_gt13(group):
    gt = group['founder']
    gt13 = group['fou_gt_chr13']
    num_DD = ((gt == 'D')&(gt13 =='D')).sum()
    return num_DD

def num_BB_founder_gt13(group):
    gt = group['founder']
    gt13 = group['fou_gt_chr13']
    num_BB = ((gt == 'B')&(gt13 =='B')).sum()
    return num_BB

def num_DB_founder_gt13(group):
    gt = group['founder']
    gt13 = group['fou_gt_chr13']
    num_DB = ((gt == 'D')&(gt13 =='B')).sum()
    return num_DB

def num_expan(group):
    expand_type = group['expand_type']
    num_expan = (expand_type == 'expan').sum()
    return num_expan

def num_contr(group):
    expand_type = group['expand_type']
    num_contr = (expand_type == 'contr').sum()
    return num_contr

def GetFounderCall(fcall):
    if "," not in str(fcall) and "/" not in str(fcall): return np.nan
    if "," in str(fcall):
        a1, a2 = fcall.split(",")
    else:
        a1, a2 = fcall.split("/")
    a1 = int(a1)
    a2 = int(a2)
    if a1 != a2: return np.nan
    return int(a1)