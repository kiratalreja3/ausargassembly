process inspector {

    publishDir "${params.outdir}/${sample}/analysis/asmqc/${assembler}/inspector/${tech}", mode: 'copy'

    input:
    tuple val (sample), val (tech), val (assembler), val (reads),  val (h1asm), val (h2asm)

    output:
    tuple val (sample), val (tech), val (assembler), path("*summary_statistics.txt"), path("*structural_error.bed"), path("*small_scale_error.bed")

    when:
    tech in ["pb"]

    script:
    
    """

    cat ${h1asm} ${h2asm} > \${PBS_JOBFS}/${sample}.${assembler}.diploid.fasta
    inspector -t ${task.cpus} -c \${PBS_JOBFS}/${sample}.${assembler}.diploid.fasta -r ${reads.join(' ')} -o ${sample}.${tech}.${assembler} --datatype hifi

    mv ${sample}.${tech}.${assembler}/summary_statistics ${sample}.${tech}.${assembler}.summary_statistics.txt
    mv ${sample}.${tech}.${assembler}/structural_error.bed ${sample}.${tech}.${assembler}.structural_error.bed
    mv ${sample}.${tech}.${assembler}/small_scale_error.bed ${sample}.${tech}.${assembler}.small_scale_error.bed

    
    """

    stub:

    """
    touch "${sample}.${tech}.${assembler}.summary_statistics.txt"
    touch "${sample}.${tech}.${assembler}.structural_error.bed"
    touch "${sample}.${tech}.${assembler}.small_scale_error.bed"
    """
}

