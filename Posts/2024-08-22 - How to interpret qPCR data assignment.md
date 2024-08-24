# **Describing the Delta-Delta Ct Method and Making Calculations Based On Data Prashant Provided**

## **Describing the Delta-Delta Ct Method**

The Delta-Delta Ct (ΔΔCt) method or Livak is commonly used to analyze quantitative real-time PCR (qPCR) data to compare gene expression levels between different samples. When applying the ΔΔCt method, two critical assumptions including; 1. Efficiency of the PCR reaction and 2. Consistent reference gene expression must be met. 
Below is a brief description of the steps involved:

1. **Ct Value Determination**: The cycle threshold (Ct) value is determined for each sample, which is the cycle number at which the fluorescence signal of the PCR product crosses the threshold level, indicating the presence of the target gene.

2. **Normalization (ΔCt Calculation)**: Normalize the Ct values of the target gene to a reference gene (housekeeping gene) to control for variations in the amount of input RNA and efficiency of the reverse transcription process. This is done by subtracting the Ct value of the reference gene from the Ct value of the target gene for each sample:
ΔCt = Ct target − Ct reference

3. **Comparison Between Samples (ΔΔCt Calculation)**: Compare the ΔCt values between the experimental sample and the control sample. Subtract the ΔCt of the control sample from the ΔCt of the experimental sample: ΔΔCt = ΔCt experimental − ΔCt control

4. **Fold Change Calculation**: Calculate the relative expression level (fold change) of the target gene in the experimental sample compared to the control sample using the formula: Fold Change = 2<sup> −ΔΔCt</sup> 

### **Note:** 
This method assumes that the PCR efficiencies of the target and reference genes are approximately equal and that the reference gene is stably expressed across all samples.

# **Calculations Based on Data Prashant Provided**

## **Data Provided**



### Cycle Threshold (Ct)

|                | ubi  | Rac1 | RhoA | CDC42 | Rock1 | Vegf | VegfR | RhoGap24l/2 |
|----------------|------|------|------|-------|-------|------|-------|-------------|
| **DMSO Control**     | 20.72 | 25.65 | 29.13 | 28.45 | 28.28 | 29.71 | 28.61 | 29.48       |
| **Inhibitor treatment** | 19.89 | 25.34 | 28.41 | 27.38 | 28.01 | 28.85 | 28.36 | 30.45       |

## **Delta Cycle Threshold (ΔCt): ΔCt = Ct target − Ct reference**



|                        | Rac1 | RhoA | CDC42 | Rock1 | Vegf | VegfR | RhoGap24l/2 |
|------------------------|------|------|-------|-------|------|-------|-------------|
| **DMSO Control**       | 4.94 | 8.41 | 7.73  | 7.56  | 8.99 | 7.90  | 8.76        |
| **Inhibitor treatment**| 5.44 | 8.51 | 7.48  | 8.11  | 8.95 | 8.47  | 10.56       |

## **Delta-Delta Cycle Threshold (ΔΔCt)**: ΔΔCt = ΔCt experimental − ΔCt control



|                | Rac1 | RhoA | CDC42 | Rock1 | Vegf | VegfR | RhoGap24l/2 |
|----------------|------|------|-------|-------|------|-------|-------------|
| **Value**      | 0.51 | 0.10 | -0.25 | 0.55  | -0.04| 0.57  | 1.79        |

## **Fold Change**: 1.9<sup> −ΔΔCt</sup>: For the sake of the class, we used 1.9 as the PCR efficiency and for this calculation 



|                | Rac1 | RhoA | CDC42 | Rock1 | Vegf | VegfR | RhoGap24l/2 |
|----------------|------|------|-------|-------|------|-------|-------------|
| **Value**      | 0.72 | 0.94 | 1.17  | 0.70  | 1.03 | 0.69  | 0.32        |

![alt text](<qPCR data analysis_Prashant's data.png>)  
Figure 1: Various gene expressions 

## **Conclusion**

Since the fold change value of the reference gene (ubi) is 1, it indicates that only CDC42 and VegfR were upregulated.




​

​
 


   
   