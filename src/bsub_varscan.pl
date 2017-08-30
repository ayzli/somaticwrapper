
sub bsub_varscan{
    my $sample_name = shift;
    my $sample_full_path = shift;
    my $job_files_dir = shift;
    my $bsub = shift;
    my $REF = shift;

    $current_job_file = "j2_varscan_".$sample_name.".sh";
    my $IN_bam_T = $sample_full_path."/".$sample_name.".T.bam";
    my $IN_bam_N = $sample_full_path."/".$sample_name.".N.bam";
    if (! -e $IN_bam_T) {#make sure there is a input fasta file 
        print $red,  "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        print "Warning: Died because there is no input bam file for bwa:\n";
        print "File $IN_bam_T does not exist!\n";
        die "Please check command line argument!", $normal, "\n\n";

    }
    if (! -s $IN_bam_T) {#make sure input fasta file is not empty
        print $red, "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        die "Warning: Died because $IN_bam_T is empty!", $normal, "\n\n";
    }
    if (! -e $IN_bam_N) {#make sure there is a input fasta file 
        print $red,  "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        print "Warning: Died because there is no input bam file for bwa:\n";
        print "File $IN_bam_N does not exist!\n";
        die "Please check command line argument!", $normal, "\n\n";

    }
    if (! -s $IN_bam_N) {#make sure input fasta file is not empty
        print $red, "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n";
        die "Warning: Died because $IN_bam_N is empty!", $normal, "\n\n";
    }

    # Create a list of BAM files for varscan to use
    my $bam_list="$sample_full_path/varscan/bamfilelist.inp";
    open(OUT, ">$bam_list") or die $!;
    print OUT "$IN_bam_N\n";
    print OUT "$IN_bam_T\n"; 
    close OUT;


    # Create the run script
    # Using HERE docs: https://stackoverflow.com/questions/17479354/how-to-use-here-doc-to-print-lines-to-file

    my $outfn = "$job_files_dir/$current_job_file";
    print("Writing to $outfn\n");
    open(OUT, ">$outfn") or die $!;

# RUNDIR=".$sample_full_path.";
my $jar="/usr/local/VarScan.v2.3.8.jar";
my $samtools="/usr/local/bin/samtools";

my $run_name="varscan.out.som";
my $log=$run_name.".log";
my $snvout=$run_name."_snv";
my $indelout=$run_name."_indel";

my $varscan_args=" \
    --mpileup 1 \
    --p-value 0.99 \
    --somatic-p-value 0.05 \
    --min-coverage-normal 30 \
    --min-coverage-tumor 22 \
    --min-var-freq 0.08 \
    --min-freq-for-hom 0.75 \
    --normal-purity 1.00 \
    --tumor-purity 1.00 \
    --strand-filter 1 \
    --min-avg-qual 15 \
    --output-vcf 1 \
    --output-snp  \
";

    print OUT <<"EOF";
#!/bin/bash
JAVA_OPTS="-Xms256m -Xmx512m"

echo Running in $sample_full_path/varscan
echo Log to $log
cd $sample_full_path/varscan

SAMTOOLS_CMD="$samtools mpileup -q 1 -Q 13 -B -f $REF -b $bam_list "

JAVA_CMD="java \$JAVA_OPTS -jar $jar somatic - $run_name $varscan_args --output-snp $snvout --output-indel $indelout"

\$SAMTOOLS_CMD | \$JAVA_CMD &> $log

EOF
    close OUT;
    my $bsub_com = "$bsub < $job_files_dir/$current_job_file\n";

    print("Executing:\n $bsub_com \n");

    system ( $bsub_com );

}

1;
