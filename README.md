# CNN-Transcoding Model from VIS to NIR Iris Images

## Abstract

This thesis project introduces an innovative deep-learning approach to enhance image quality within the iris recognition pipeline operating in the visible (VIS) spectrum. The study leverages the inherent correlation between visible and near-infrared (NIR) spectra, proposing two transcoding models with the purpose of:

1. Mitigating noise factors in iris images, such as reflection and glare, to improve iris segmentation.
2. Refining normalized (segmented) iris images for finely detailed texture representation, resulting in more discriminating features.

In its concluding phase, the study introduces a novel feature extraction method that generates high-quality features by exploiting the VIS-NIR spectra relationship, similar to the transcoding techniques outlined. The convolutional neural network (CNN) architectures draw inspiration from U-Net and Pix2pix, well-known in Image-to-Image (I2I) translation tasks. This work attempts to contribute to the research of effective methods to improve the critical steps involved in iris recognition systems by exploiting the benefits of the NIR domain without directly using near-infrared cameras.

&nbsp;

<p align="center">
  <img width="834" alt="image" src="https://github.com/user-attachments/assets/c9cc34ae-a687-41d4-ba0b-485aa5bf5099" />
</p>

## General structure

The **`task1/`** directory contains a **`dataset/`** subdirectory, which includes both the preprocessing scripts and the dataset itself. In contrast, the **`transcoding/`** subdirectory holds the models generated from the training phase. These models are designed to transcode visible iris images into a form that enhances segmentation accuracy by mitigating noise and improving image quality.

Similarly, the **`task2/`** directory also includes a **`dataset/`** subdirectory with the necessary preprocessing scripts and the dataset. Additionally, the **`cnn-based_dfe/`** subdirectory contains a CNN-based feature extractor that is integrated into the architecture of the second transcoding model. This component aims to generate iris images with richer, more structured textures, thus facilitating better feature extraction for the recognition process.

The **`final_assessments/`** directory contains all the evaluations conducted to assess the improvements brought about by the models. These evaluations use a traditional iris recognition system, where key architectural choices include the adoption of the ISI method for iris segmentation and the Daugman-based algorithm for feature extraction. The implementation of the Iris Recognition System (IRS) can be found in the **`iris_recognition_system/`** directory.


## Further information

For further details and a comprehensive explanation of the methodology, please consult the master_thesis.pdf or feel free to contact me at sasi.amodio98@gmail.com.

## References

The Hong Kong Polytechnic University Cross-Spectral Iris Image Database. [https://www4.comp.polyu.edu.hk/~csajaykr/polyuiris.htm](https://www4.comp.polyu.edu.hk/~csajaykr/polyuiris.htm). 2015.
