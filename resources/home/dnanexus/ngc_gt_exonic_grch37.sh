#!/bin/bash

  echo "[`date`] Running vcf to bcf file conversion"
  gunzip /home/dnanexus/samples/sample_joint_called.vcf.gz

  bcftools view -O b -o /home/dnanexus/samples/sample_joint_called.bcf /home/dnanexus/samples/sample_joint_called.vcf
  bcftools index -f /home/dnanexus/samples/sample_joint_called.bcf

  echo "[`date`] Normalize indels and filter for AC>0"

  bcftools norm -m - -f /home/dnanexus/human_g1k_v37.fa /home/dnanexus/samples/sample_joint_called.bcf|bcftools view -e 'AC==0' -Ob -o /home/dnanexus/tmpFile_AC0.bcf
  bcftools index -f /home/dnanexus/tmpFile_AC0.bcf

  ########## END: Normalize step ##########

  ############## START: Extract Exonic Region ################

  echo "[`date`] Getting exonic regions" 
  
  bcftools view -R /home/dnanexus/hg19_refseq_ensembl_exons_50bp_allMT_hgmd_clinvar_20200519.txt /home/dnanexus/tmpFile_AC0.bcf -Ob -o /home/dnanexus/tmpFile_AC0.exon.bcf
  bcftools view /home/dnanexus/tmpFile_AC0.exon.bcf | bcftools sort | bcftools view -Ob -o /home/dnanexus/tmpFile_AC0.exon.sorted.bcf
  mv /home/dnanexus/tmpFile_AC0.exon.sorted.bcf /home/dnanexus/tmpFile_AC0.exon.bcf
  bcftools index /home/dnanexus/tmpFile_AC0.exon.bcf

  ############ END: Extract Exonic Region  ####################

  #family_name="$(head -1 /home/dnanexus/manifest/family_name.txt)"
  #echo "$family_name"

  bcftools convert -O v -o /home/dnanexus/family.exonic.vcf /home/dnanexus/tmpFile_AC0.exon.bcf
  gzip /home/dnanexus/family.exonic.vcf
  
  cp /home/dnanexus/family.exonic.vcf.gz /home/dnanexus/out/outfiles/family.exonic.vcf.gz

  #cp /home/dnanexus/family.exonic.vcf /home/dnanexus/out/outfiles/family_name.exonic.vcf