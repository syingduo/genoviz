#!/bin/bash

# Parse named arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
    --maf)
        MAF_FILE="$2"
        shift 2
        ;;
    --smg)
        SMG_FILE="$2"
        shift 2
        ;;
    --pdf)
        PDF_FILE="$2"
        shift 2
        ;;
    *)
        echo "Unknown parameter: $1"
        echo "Usage: $0 --maf <maf_file> --smg <smg_list.txt> --pdf <out.pdf>"
        exit 1
        ;;
    esac
done

# Check required args
if [[ -z "$MAF_FILE" || -z "$SMG_FILE" || -z "$PDF_FILE" ]]; then
    echo "Error: missing required arguments."
    echo "Usage: $0 --maf <maf_file> --smg <smg_list.txt> --pdf <out.pdf>"
    exit 1
fi

# Step 1: Extract non-silent mutations
echo "[Step 1] Extracting non-silent mutations from $MAF_FILE ..."
awk '$9=="Frame_Shift_Del" || $9=="Frame_Shift_Ins" || $9=="Missense_Mutation" || $9=="Nonsense_Mutation" || $9=="Nonstop_Mutation" || $9=="Silent" || $9=="Splice_Site" || $9=="In_Frame_Ins" || $9=="In_Frame_Del" {print $0}' "$MAF_FILE" >non_slient.dnp.annotated.maf

# Step 2: Generate oncoplot.csv
echo "[Step 2] Creating oncoplot.csv from filtered MAF and SMG list ..."
perl -e '$f="'$SMG_FILE'";foreach $l(`cat $f`){chomp($l);$smg{$l}=1;}foreach $l(`cat non_slient.dnp.annotated.maf`){chomp($l);next if $l=~/version/ || $l=~/^Hugo/;@t=split("\t",$l);$sn=$t[15];$sn=~s/_T//;$slist{$sn}=1;if($smg{$t[0]}){next if $t[8] eq "Silent";$a=$t[8];$a="In_Frame_Indel" if $a=~/In_Frame/;$a="Frame_Shift" if $a=~/Frame_Shift/;$smg_sn{$t[0]}{$sn}{$a}=1;$glist{$t[0]}=1;}}foreach $s(sort keys %slist){print ",$s";}print "\n";foreach $g(sort keys %glist){print "$g";foreach $s(sort keys %slist){print ",";if($smg_sn{$g}{$s}){$i="";foreach $t(sort keys %{$smg_sn{$g}{$s}}){$t=~s/_Mutation//g;$i=$i?$i.";".$t:$t;}print $i;}}print "\n";}' >oncoplot.csv

# Step 3: Plot oncoplot
echo "[Step 3] Plotting mutation landscape to $PDF_FILE ..."
Rscript summary.somatic.alter.v3.r oncoplot.csv "$PDF_FILE"

echo "✅ Done!"
