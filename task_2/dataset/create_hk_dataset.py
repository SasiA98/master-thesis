from os import listdir, makedirs
import random
import cv2
import numpy as np
import shutil
from tensorflow.keras.utils import load_img, save_img
import tensorflow as tf

# ------------------ PolyU_Cross_Session_1/PolyU_Cross_Norm_Unenhanced ------------------ #

PATH = '/Users/salvatoreamodio/Desktop/thesis-project/dataset/HK_dataset/PolyU_Cross_Session_1/PolyU_Cross_Norm_Unenhanced/'

DATASET_DIR = 'hk_norm_unenhanced_aug_iris_dataset_64x240_cv2_png/'
TRAIN_DIR = DATASET_DIR + 'train/'
TEST_DIR = DATASET_DIR + 'test/'
TMP_DIR = 'tmp/'
NIR_DIR = 'nir/'
VIS_DIR = 'vis/'

img_width = 240
img_heigth = 64

N_SUBJECTS_PER_TRAINING_SET = 150 
N_INSTANCES_PER_EYE = 15

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
            img = cv2.resize(img, [img_width,img_heigth])
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
            img = cv2.resize(img, [img_width,img_heigth])
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
            img = cv2.resize(img, [img_width,img_heigth])
            cv2.imwrite(main_dir + VIS_DIR + str(subdir) + '_L_VIS_' + str(n_instance) + ".png", img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])

            # COPY FILES
            #shutil.copyfile(subpath + filename, main_dir + VIS_DIR + str(subdir) + '_L_VIS_' + str(n_instance) + ".png")

            n_instance = n_instance + 1 

        subpath = PATH + subdir + '/R/VIS/'
        filenames_tmp = listdir(subpath)
        filenames_tmp.sort()
        n_instance = 0
        
        for filename in filenames_tmp[0:N_INSTANCES_PER_EYE] :

            img = cv2.imread(subpath + filename)
            img = cv2.resize(img, [img_width,img_heigth])
            cv2.imwrite(main_dir + VIS_DIR + str(subdir) + '_R_VIS_' + str(n_instance) + ".png", img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])

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
    makedirs(TRAIN_DIR + NIR_DIR)
    makedirs(TEST_DIR + NIR_DIR)
    makedirs(TRAIN_DIR + VIS_DIR)
    makedirs(TEST_DIR + VIS_DIR)

    create_dataset()

