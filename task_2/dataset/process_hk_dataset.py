from os import listdir, remove, rmdir, makedirs
import random
import numpy as np
from tensorflow.keras.utils import load_img, save_img
import cv2
import shutil


DATASET_PATH = '/Users/salvatoreamodio/Desktop/thesis-project/task_2/modified_dataset/hk_norm_enhanced_iris_dataset/'
PROCESSED_DATASET_PATH = 'processed_hk_norm_unenhanced_aug_iris_dataset_64x240_cv2_png/'
TRAIN_DIR = 'train/'
TEST_DIR = 'test/'
NIR_DIR = 'NIR/'
VIS_DIR = 'VIS/'

N_SUBJECTS_TRAINING_SET = 150 
N_INSTANCES_PER_EYE = 15

N_SUBJECTS = 209
IMG_HEIGHT = 64
IMG_WIDTH = 240

# Define the circular shift amount (adjust as needed)
shift_amount_y = 120


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

            imVL = cv2.imread(imVL_path)

            imNR = cv2.imread(imNR_path)

            imVR = cv2.imread(imVR_path)

            im_hL_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_L_' + str(j) + '.png'
            im_hL = cv2.hconcat([imVL, imNL])
            
            cv2.imwrite(im_hL_path, im_hL,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])

            im_hR_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_R_' + str(j) + '.png'
            im_hR = cv2.hconcat([imVR, imNR])
            
            cv2.imwrite(im_hR_path, im_hR,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])

            # data augmentation
            if i < N_SUBJECTS_TRAINING_SET : 

                # Effettua il flipping orizzontale
                flipped_h_imNL = cv2.flip(imNL, 1)
                flipped_h_imVL = cv2.flip(imVL, 1)
                flipped_h_imNR = cv2.flip(imNR, 1)
                flipped_h_imVR = cv2.flip(imVR, 1)

                im_h_flipped_hL_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_L_' + str(j) + '_h_flipped_' + '.png'
                im_h_flipped_hR_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_R_' + str(j) + '_h_flipped_' +'.png'

                im_h_flipped_hL = cv2.hconcat([flipped_h_imVL, flipped_h_imNL])
                im_h_flipped_hR = cv2.hconcat([flipped_h_imVR, flipped_h_imNR])

                cv2.imwrite(im_h_flipped_hL_path, im_h_flipped_hL,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])
                cv2.imwrite(im_h_flipped_hR_path, im_h_flipped_hR,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])

                # Effettua il flipping verticale

                flipped_v_imNL = cv2.flip(imNL, 0)
                flipped_v_imVL = cv2.flip(imVL, 0)
                flipped_v_imNR = cv2.flip(imNR, 0)
                flipped_v_imVR = cv2.flip(imVR, 0)
    
                im_v_flipped_hL_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_L_' + str(j) + '_v_flipped_' + '.png'
                im_v_flipped_hR_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_R_' + str(j) + '_v_flipped_' +'.png'

                im_v_flipped_hL = cv2.hconcat([flipped_v_imVL, flipped_v_imNL])
                im_v_flipped_hR = cv2.hconcat([flipped_v_imVR, flipped_v_imNR])

                cv2.imwrite(im_v_flipped_hL_path, im_v_flipped_hL,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])
                cv2.imwrite(im_v_flipped_hR_path, im_v_flipped_hR,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])

                # Perform circular shift along the y-axis

                shifted_imNL = np.roll(imNL, shift_amount_y, axis=1)
                shifted_imVL = np.roll(imVL, shift_amount_y, axis=1)
                shifted_imNR = np.roll(imNR, shift_amount_y, axis=1)
                shifted_imVR = np.roll(imVR, shift_amount_y, axis=1)

                im_shifted_hL_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_L_' + str(j) + '_shifted_' + '.png'
                im_shifted_hR_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_R_' + str(j) + '_shifted_' +'.png'

                im_shifted_hL = cv2.hconcat([shifted_imVL, shifted_imNL])
                im_shifted_hR = cv2.hconcat([shifted_imVR, shifted_imNR])

                cv2.imwrite(im_shifted_hL_path, im_shifted_hL,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])
                cv2.imwrite(im_shifted_hR_path, im_shifted_hR,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])

                # Perform circular shift along the y-axis
                
                #hv_flipped_shifted_imNL= cv2.flip(shifted_imNL, -1)
                #hv_flipped_shifted_imVL = cv2.flip(shifted_imVL, -1)
                #hv_flipped_shifted_imNR = cv2.flip(shifted_imNR, -1)
                #hv_flipped_shifted_imVR = cv2.flip(shifted_imVR, -1)

                #im_hv_flipped_shifted_hL_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_L_' + str(j) + '_hv_flipped_shifted_' + '.png'
                #im_hv_flipped_shifted_hR_path = PROCESSED_DATASET_PATH + SET_DIR + str(i+1).zfill(3) + '_R_' + str(j) + '_hv_flipped_shifted_' +'.png'

                #im_hv_flipped_shifted_hL = cv2.hconcat([hv_flipped_shifted_imVL, hv_flipped_shifted_imNL])
                #im_hv_flipped_shifted_hR = cv2.hconcat([hv_flipped_shifted_imVR, hv_flipped_shifted_imNR])

                #cv2.imwrite(im_hv_flipped_shifted_hL_path, im_hv_flipped_shifted_hL,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])
                #cv2.imwrite(im_hv_flipped_shifted_hR_path, im_hv_flipped_shifted_hR,[int(cv2.IMWRITE_PNG_COMPRESSION), 0])

    print("preprocessing completed")


if __name__ == "__main__" :

    makedirs(PROCESSED_DATASET_PATH)
    makedirs(PROCESSED_DATASET_PATH + TRAIN_DIR)
    makedirs(PROCESSED_DATASET_PATH + TEST_DIR)   
    dataset_preprocessing()
