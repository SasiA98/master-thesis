from os import listdir, remove, rmdir, makedirs
import random
import numpy as np
from tensorflow.keras.utils import load_img, save_img
import cv2
import shutil


DATASET_PATH = '/Users/salvatoreamodio/Desktop/thesis-project/task_2/modified_dataset/hk_norm_unenhanced_iris_dataset_64x240_cv2_HQ_png/'
PROCESSED_DATASET_PATH = 'hk_norm_unenhanced_iris_dataset_64x240_cv2_HQ_png/'
TRAIN_DIR = 'train/'
TEST_DIR = 'test/'
NIR_DIR = 'NIR/'
VIS_DIR = 'VIS/'

N_SUBJECTS_TRAINING_SET = 150 
N_INSTANCES_PER_EYE = 15

N_SUBJECTS = 209
IMG_HEIGHT = 64
IMG_WIDTH = 240

ext = '.png'

def dataset_preprocessing():

    print("dataset_preprocessing started")
    
    SET_DIR = TRAIN_DIR

    for i in range(N_SUBJECTS) :
        for j in range(N_INSTANCES_PER_EYE) :

            if i >= N_SUBJECTS_TRAINING_SET : 
                SET_DIR = TEST_DIR

            imVL_path = DATASET_PATH + SET_DIR + VIS_DIR + str(i+1).zfill(3) + '_L_VIS_' + str(j) + ext
            imNL_path = DATASET_PATH + SET_DIR + NIR_DIR + str(i+1).zfill(3) + '_L_NIR_' + str(j) + ext

            imVR_path = DATASET_PATH + SET_DIR + VIS_DIR + str(i+1).zfill(3) + '_R_VIS_' + str(j) + ext
            imNR_path = DATASET_PATH + SET_DIR + NIR_DIR + str(i+1).zfill(3) + '_R_NIR_' + str(j) + ext
                            
            imNL = cv2.imread(imNL_path)
            #imNL = cv2.resize(imNL, [IMG_WIDTH, IMG_HEIGHT])

            imVL = cv2.imread(imVL_path)
            #imVL = cv2.resize(imVL, [IMG_WIDTH, IMG_HEIGHT])

            imNR = cv2.imread(imNR_path)
            #imNR = imNR[:, ::-1, :]

            #imNR = cv2.resize(imNR, [IMG_WIDTH, IMG_HEIGHT])

            imVR = cv2.imread(imVR_path)
            #imVR = imVR[:, ::-1, :]

            #imVR = cv2.resize(imVR, [IMG_WIDTH, IMG_HEIGHT])

            im_hL_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_L_' + str(j) + '.png'
            im_hL = cv2.hconcat([imVL, imNL])
            
            cv2.imwrite(im_hL_path, im_hL,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])
            #cv2.imwrite(im_hL_path, im_hL)

            im_hR_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_R_' + str(j) + '.png'
            im_hR = cv2.hconcat([imVR, imNR])
            
            cv2.imwrite(im_hR_path, im_hR,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])
            #cv2.imwrite(im_hR_path, im_hR)


    print("preprocessing completed")


if __name__ == "__main__" :

    makedirs(PROCESSED_DATASET_PATH)
    makedirs(PROCESSED_DATASET_PATH + TRAIN_DIR)
    makedirs(PROCESSED_DATASET_PATH + TEST_DIR)   
    dataset_preprocessing()
