# VOP Detection in Variable Speech Rate Condition

The Vowel onset point (VOP) is the location where the onset of vowel takes place in a given speech segment. Many speech processing applications need the information of VOP to extract features from the speech signal. In such cases the overall performance largely depends on the exact detection of VOP location. There are many algorithms proposed in the literature for the automatic detection of VOPs. Most of these methods assume that the given speech signal is produced at normal speech rate. All the parameters for smoothing speech signal evidence as well as hypothesizing VOPs are set accordingly. However, these parameter settings may not work well for variable speech rate conditions. This work proposes a dynamic first order Gaussian differentiator (FOGD) window based approach to overcome this issue. The proposed approach is evaluated using a subset of TIMIT dataset with manually marked ground truth VOPs. The evaluated performance of VOP detection by using the proposed approach shows improvement when compared with the existing approach at higher and lower speech rate conditions.



## Dataset

VOP detection task has been performed by using the 205 speech segment files of TIMIT dataset with manually marked ground truth of around 2500 VOPs. The entire dataset can ne found in 
``` bash
merged.zip
```
## Execution

This repository is the official MATLAB implementation of the paper titled "VOP Detection in Variable Speech Rate Condition."


To visualize the results for single utterance run:
```bash
  Var_Speech_Rate_VOP.m
```
Note: Path of the speech utterance and ground truth can be taken from "merged" data folder.

For execution on entire data run:

```bash
perf_measure_VOP_manual_TIMIT.m
```


## Authors

- [@Ayush Agarwal](https://in.linkedin.com/in/ayush-agarwal-63b632167)
- [@Jagabandhu Mishra](https://github.com/jagabandhumishra)
- [@ S.R. Mahadeva Prasanna](https://sites.google.com/iitdh.ac.in/prasanna/home)



## Citation
The authors request you to cite this paper if it relates to your research

```bash
@inproceedings{agarwal2020vop,
  title={VOP Detection in Variable Speech Rate Condition.},
  author={Agarwal, Ayush and Mishra, Jagabandhu and Prasanna, SR Mahadeva},
  booktitle={INTERSPEECH},
  pages={3690--3694},
  year={2020}
}
```
