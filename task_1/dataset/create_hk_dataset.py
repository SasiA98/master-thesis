#
#
# The database of iris images has been acquired under simultaneous bi-spectral imaging, from both right and left eyes. 
# The dataset has 209 subjects, and for each subject 30 acquisitions have been made (15 for the left eye and 15 for the right eye).
# Since we want a training set of about 1k and a test set of about 3/400, we can split subjects in this way:
#   - first 150 subjects for the training set
#   - last   59 subjests for the test set
# For each subject we can consider only the first 6 instances (3 left eye images and 3 right eye images). 
# Therefore, we have 6 * 150 = 900 samples for the training set and 6 * 62 =  354 samples for the test set.
# The new dataset has 1254 samples; thus the relationship is 71.8% training set - 28,2% test set
#
#
# NB: images will be kept in their original size (640x480)
#

from os import listdir, makedirs
import random
import shutil
import cv2
import numpy as np
from tensorflow.keras.utils import load_img, save_img
import tensorflow as tf


PATH = 'HK_dataset/PolyU_Cross_Session_1/PolyU_Cross_Iris/'

DATASET_DIR = 'hk_dataset/'
TRAIN_DIR = DATASET_DIR + 'train/'
TEST_DIR = DATASET_DIR + 'test/'
TMP_DIR = 'tmp/'
NIR_DIR = 'nir/'
VIS_DIR = 'vis/'

N_SUBJECTS_PER_TRAINING_SET = 150 
N_INSTANCES_PER_EYE = 4

def create_dataset():

    print("create_dataset started")

    subdirs = listdir(PATH)
    subdirs.sort()

    subject = 0 
    main_dir = TRAIN_DIR 
    
    for subdir in subdirs:

        if subject >= N_SUBJECTS_PER_TRAINING_SET :
            main_dir = TEST_DIR


        subpath = PATH + subdir + '/L/NIR/'
        filenames_tmp = listdir(subpath)
        filenames_tmp.sort()
        n_instance = 0

        for filename in filenames_tmp[0:N_INSTANCES_PER_EYE] :
  
            img = cv2.imread(subpath + filename)
            cv2.imwrite(main_dir + NIR_DIR + str(subdir) + '_L_NIR_' + str(n_instance) + ".png", img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])

            # COPY FILES
            #shutil.copyfile(subpath + filename, main_dir + NIR_DIR + str(subdir) + '_L_NIR_' + str(n_instance) + ".png")

            n_instance = n_instance + 1 

        subpath = PATH + subdir + '/R/NIR/'   
        filenames_tmp = listdir(subpath)
        filenames_tmp.sort()
        n_instance = 0

        for filename in filenames_tmp[0:N_INSTANCES_PER_EYE] :

            img = cv2.imread(subpath + filename)
            cv2.imwrite(main_dir + NIR_DIR + str(subdir) + '_R_NIR_' + str(n_instance) + ".png", img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])

            # COPY FILES
            #shutil.copyfile(subpath + filename, main_dir + NIR_DIR + str(subdir) + '_R_NIR_' + str(n_instance) + ".png")

            n_instance = n_instance + 1 

    
        subpath = PATH + subdir + '/L/VIS/'
        filenames_tmp = listdir(subpath)
        filenames_tmp.sort()
        n_instance = 0

        for filename in filenames_tmp[0:N_INSTANCES_PER_EYE] :
             
            img = cv2.imread(subpath + filename)
            cv2.imwrite(main_dir + VIS_DIR + str(subdir) + '_L_VIS_' + str(n_instance) +  ".png", img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])

            # COPY FILES
            #shutil.copyfile(subpath + filename, main_dir + VIS_DIR + str(subdir) + '_L_VIS_' + str(n_instance) + ".png")

            n_instance = n_instance + 1 

        subpath = PATH + subdir + '/R/VIS/'
        filenames_tmp = listdir(subpath)
        filenames_tmp.sort()
        n_instance = 0
        
        for filename in filenames_tmp[0:N_INSTANCES_PER_EYE] :

            img = cv2.imread(subpath + filename)
            cv2.imwrite(main_dir + VIS_DIR + str(subdir) + '_R_VIS_' + str(n_instance) +  ".png", img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])

            # COPY FILES 
            #shutil.copyfile(subpath + filename, main_dir + VIS_DIR + str(subdir) + '_R_VIS_' + str(n_instance) + ".png")

            n_instance = n_instance + 1 

        subject = subject + 1

    print("create_dataset completed")

    return

if __name__ == "__main__" :
    makedirs(DATASET_DIR)
    makedirs(TRAIN_DIR)
    makedirs(TEST_DIR)
    makedirs(TRAIN_DIR + VIS_DIR)
    makedirs(TRAIN_DIR + NIR_DIR)
    makedirs(TEST_DIR + VIS_DIR)
    makedirs(TEST_DIR + NIR_DIR)

    create_dataset()

