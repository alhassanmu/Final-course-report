# **Primer Design for *Endozoicomonas*, a Genus of γ-Proteobacteria in the Family *Endozoicomonadaceae***

![alt text](../images/Primers.png)   
Figure 1: Showing foward and reverse primers used in Polymerase Chain Reaction 

## **Selection of Sequences**

To begin with the primer design, I decided on my target gene and selected the 16S rRNA gene because it is a conserved gene in bacteria. I visited the website of the [ National Center for Biotechnology Information (NCBI)](https://www.ncbi.nlm.nih.gov/) and searched for *Endozoicomonas* in the nucleotide database. I selected and downloaded the FASTA sequences of four *Endozoicomonas* species: *Endozoicomonas* *euniceicola*, *Endozoicomonas* *gorgoniicola*, *Endozoicomonas* *numazuensis*, and *Endozoicomonas* *montiporae* because they are closely related.

## **Alignment of Sequences**

I then aligned the four downloaded sequences using  [CLUSTALW](https://www.genome.jp/tools-bin/clustalw). This helped me identify the conserved and variable regions of the sequences. I proceeded with the conserved regions for the primer design.

## **Picking of Primers**

I visited the [Primer3](https://primer3.ut.ee/) website for the primer design. I pasted the conserved sequence and set the primer size range to 1000-1500 base pairs, then clicked on "Pick Primers."

![alt text](../images/Primer%20picking%20result.png)
Figure 2: [Primer picking result](https://primer3.ut.ee/cgi-bin/primer3/primer3web_results.cgi)

## **Phylogenetic Tree Analysis**

I created a phylogenetic tree for the four sequences using the Molecular Evolutionary Genetics Analysis (MEGA) software version 11.
I created a FASTA file of the sequences and uploaded it into MEGA 11 software for multiple sequence alignment using the CLUSTALW option. The generated multiple sequence alignment file was then used to construct a phylogenetic tree.

On the MEGA 11 software interface, I clicked on "Phylogeny" and selected "Construct/Test Neighbor-Joining Tree." Under the "Test Phylogeny" option, I chose the bootstrap method and set it to 1000 replicates, keeping the remaining parameters at their default settings. I saved the generated phylogenetic tree as a PNG file.

The phylogenetic analysis revealed that *Endozoicomonas gorgoniicola* is more closely related to *Endozoicomonas numazuensis*.

![alt text](../images/Phylogenetic%20tree%20for%20endozoicomonas%20sequences.png)
Figure 3: Phylogenetic tree generated from the four sequences of *Endozoicomonas* spp.