#!/bin/bash
# ngc_genotyping_grch38

set -exo pipefail

main() {

    echo "Value of input_vcf_files: '$input_vcf_files'"
    #echo "Value of input_manifest_files: '$input_manifest_files'"
    #echo "Value of input_reference_files: '$input_reference_files'"
    
    time dx-download-all-inputs --parallel
    
    #Create folders
    mkdir -p /home/dnanexus/out/outfiles
    #mkdir -p /home/dnanexus/manifest
    #mkdir -p /home/dnanexus/genome
    mkdir -p /home/dnanexus/samples

    #Permissions to write to /home/dnanexus
    chmod a+rwx /home/dnanexus

    #Move files to folders

    find ~/in/input_vcf_files -type f -name "*" -print0 | xargs -0 -I {} mv {} /home/dnanexus/samples/

    #find ~/in/input_manifest_files -type f -name "*" -print0 | xargs -0 -I {} mv {} /home/dnanexus/manifest/

    #find ~/in/input_reference_files -type f -name "*" -print0 | xargs -0 -I {} mv {} /home/dnanexus/genome/

    dx download project-F3zxk7Q4F30Xp8fG69K1Vppj:file-F403PKj4F30kZbyVFq8YX13b

    dx download project-F3zxk7Q4F30Xp8fG69K1Vppj:file-F3zy5904F30kz2Zj4061Q93f

    gunzip /home/dnanexus/human_g1k_v37.fa.gz

    echo "files are copied"

    #install conda, create, run env
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

    bash ~/miniconda.sh -b -p $HOME/miniconda

    eval "$(/home/dnanexus/miniconda/bin/conda shell.bash hook)"

    conda init

    conda deactivate

    conda create -n mytools -y
    
    #conda activate ngc_snv
    conda activate mytools

    conda install -c bioconda bcftools -y
    
    #Run snv variant filtering script
    . /home/dnanexus/ngc_gt_exonic_grch37.sh

    conda deactivate
    
    # upload output 
    dx-upload-all-outputs --parallel
}
