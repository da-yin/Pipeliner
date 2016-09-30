rule cnvkit_somatic:
    input: normal=lambda wildcards: config['project']['pairs'][wildcards.x][0]+".recal.bam",
           tumor=lambda wildcards: config['project']['pairs'][wildcards.x][1]+".recal.bam",
           targets="cnvkit_targets.bed"
    output: calls="cnvkit_out/{x}_calls.cns",
            gainloss="cnvkit_out/{x}_gainloss.tsv"
    params: tumorsample=lambda wildcards: config['project']['pairs'][wildcards.x][1],normalsample=lambda wildcards: config['project']['pairs'][wildcards.x][0],access=config['references'][pfamily]['CNVKITACCESS'],targets="cnvkit_targets.bed",antitargets="cnvkit_antitargets.bed",genome=config['references'][pfamily]['CNVKITGENOME'],rname="pl:cnvkit_somatic"
    shell: "module load cnvkit/0.8; cnvkit.py batch -n {input.normal} --fasta {params.genome} --short-names --drop-low-coverage -g {params.access} --targets {params.targets} --antitargets {params.antitargets} --output-reference cnvkit_out/{params.normalsample}.reference.cnn --output-dir cnvkit_out {input.tumor}; cnvkit.py call -o {output.calls} cnvkit_out/{params.tumorsample}.cns; cnvkit.py gainloss -s cnvkit_out/{params.tumorsample}.cns -t 0.3 --drop-low-coverage -o {output.gainloss} cnvkit_out/{params.tumorsample}.cnr"