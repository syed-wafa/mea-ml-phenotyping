import os
import numpy as np
import pickle
import tphate
from scipy.io import loadmat

os.chdir(r"/Users/swafa/Documents/MEA/Saved Data/T-PHATE inputs")

with open('tphate_input.pkl', 'rb') as fin:
    data = pickle.load(fin)

tphate_op = tphate.TPHATE(n_components=3)
# tphate_op = tphate.TPHATE()
data_tphate = tphate_op.fit_transform(data)

np.savetxt("tphate_output.csv", data_tphate, delimiter=",")

################### Q2-01

with open('q201_xe_tphate_input.pkl', 'rb') as fin:
    q201_xe = pickle.load(fin)
q201_xe_tphate = tphate_op.transform(q201_xe)
np.savetxt("q201_xe_tphate_output.csv", q201_xe_tphate, delimiter=",")

with open('q201_ret_tphate_input.pkl', 'rb') as fin:
    q201_ret = pickle.load(fin)
q201_ret_tphate = tphate_op.transform(q201_ret)
np.savetxt("q201_ret_tphate_output.csv", q201_ret_tphate, delimiter=",")

################### Q2-03

with open('q203_xe_tphate_input.pkl', 'rb') as fin:
    q203_xe = pickle.load(fin)
q203_xe_tphate = tphate_op.transform(q203_xe)
np.savetxt("q203_xe_tphate_output.csv", q203_xe_tphate, delimiter=",")

with open('q203_ret_tphate_input.pkl', 'rb') as fin:
    q203_ret = pickle.load(fin)
q203_ret_tphate = tphate_op.transform(q203_ret)
np.savetxt("q203_ret_tphate_output.csv", q203_ret_tphate, delimiter=",")

with open('q203_control_tphate_input.pkl', 'rb') as fin:
    q203_control = pickle.load(fin)
q203_control_tphate = tphate_op.transform(q203_control)
np.savetxt("q203_control_tphate_output.csv", q203_control_tphate, delimiter=",")

with open('q203_disease_tphate_input.pkl', 'rb') as fin:
    q203_disease = pickle.load(fin)
q203_disease_tphate = tphate_op.transform(q203_disease)
np.savetxt("q203_disease_tphate_output.csv", q203_disease_tphate, delimiter=",")

################### Q2-04

with open('q204_xe_tphate_input.pkl', 'rb') as fin:
    q204_xe = pickle.load(fin)
q204_xe_tphate = tphate_op.transform(q204_xe)
np.savetxt("q204_xe_tphate_output.csv", q204_xe_tphate, delimiter=",")

with open('q204_ret_tphate_input.pkl', 'rb') as fin:
    q204_ret = pickle.load(fin)
q204_ret_tphate = tphate_op.transform(q204_ret)
np.savetxt("q204_ret_tphate_output.csv", q204_ret_tphate, delimiter=",")

################### Q2-07

with open('q207_xe_tphate_input.pkl', 'rb') as fin:
    q207_xe = pickle.load(fin)
q207_xe_tphate = tphate_op.transform(q207_xe)
np.savetxt("q207_xe_tphate_output.csv", q207_xe_tphate, delimiter=",")

with open('q207_ret_tphate_input.pkl', 'rb') as fin:
    q207_ret = pickle.load(fin)
q207_ret_tphate = tphate_op.transform(q207_ret)
np.savetxt("q207_ret_tphate_output.csv", q207_ret_tphate, delimiter=",")

with open('q207_control_tphate_input.pkl', 'rb') as fin:
    q207_control = pickle.load(fin)
q207_control_tphate = tphate_op.transform(q207_control)
np.savetxt("q207_control_tphate_output.csv", q207_control_tphate, delimiter=",")

with open('q207_disease_tphate_input.pkl', 'rb') as fin:
    q207_disease = pickle.load(fin)
q207_disease_tphate = tphate_op.transform(q207_disease)
np.savetxt("q207_disease_tphate_output.csv", q207_disease_tphate, delimiter=",")

################### Q2-17

# with open('q217_xe_tphate_input.pkl', 'rb') as fin:
#     q217_xe = pickle.load(fin)
q217_xe = np.loadtxt('q217_xe_tphate_input.csv', delimiter=',')
q217_xe_tphate = tphate_op.transform(q217_xe)
np.savetxt("q217_xe_tphate_output.csv", q217_xe_tphate, delimiter=",")

# with open('q217_ret_tphate_input.pkl', 'rb') as fin:
#     q217_ret = pickle.load(fin)
q217_ret = np.loadtxt('q217_ret_tphate_input.csv', delimiter=',')
q217_ret_tphate = tphate_op.transform(q217_ret)
np.savetxt("q217_ret_tphate_output.csv", q217_ret_tphate, delimiter=",")

# with open('q217_control_tphate_input.pkl', 'rb') as fin:
#     q217_control = pickle.load(fin)
q217_control = np.loadtxt('q217_control_tphate_input.csv', delimiter=',')
q217_control_tphate = tphate_op.transform(q217_control)
np.savetxt("q217_control_tphate_output.csv", q217_control_tphate, delimiter=",")

# with open('q217_disease_tphate_input.pkl', 'rb') as fin:
#     q217_disease = pickle.load(fin)
q217_disease = np.loadtxt('q217_disease_tphate_input.csv', delimiter=',')
q217_disease_tphate = tphate_op.transform(q217_disease)
np.savetxt("q217_disease_tphate_output.csv", q217_disease_tphate, delimiter=",")

with open('q201_4AP_tphate_input.pkl', 'rb') as fin:
    q201_4AP = pickle.load(fin)
q201_4AP_tphate = tphate_op.transform(q201_4AP)
#np.savetxt("q201_4AP_tphate_output.csv", q201_4AP_tphate, delimiter=",")

with open('q204_4AP_tphate_input.pkl', 'rb') as fin:
    q204_4AP = pickle.load(fin)
q204_4AP_tphate = tphate_op.transform(q204_4AP)
#np.savetxt("q204_4AP_tphate_output.csv", q204_4AP_tphate, delimiter=",")