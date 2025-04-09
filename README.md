# 🧬 Genoviz

**Genoviz** is a lightweight toolkit for visualizing somatic mutation patterns in cancer cohorts. It provides an easy-to-run shell script pipeline to extract driver mutations from MAF files, format them, and generate mutation landscape plots and VAF-based comparisons.

## 📂 Repository Structure

```
genoviz/
├── oncoplot/              # Mutation landscape plotting scripts and data
├── vaf_comparison/        # VAF comparison analysis and plots
├── images/                # Output visualizations (see below)
└── README.md              # Project documentation
```

## ⚙️ Key Features

- Extracts **non-silent somatic mutations** from MAF files
- Focuses on a **user-defined list of SMGs (Significantly Mutated Genes)**
- Generates **oncoplots** annotated by mutation type
- Produces **VAF correlation plots** for paired or longitudinal sample comparison

## 🚀 Usage

To run the mutation landscape pipeline:

```bash
bash run_oncoplot.sh --maf your_input.maf --smg smg_list.txt --pdf output_plot.pdf
```

- `--maf`: Input annotated MAF file
- `--smg`: A plain-text list of SMG gene symbols (one per line)
- `--pdf`: Output filename for the oncoplot (PDF)

Make sure the script `summary.somatic.alter.v3.r` is located in your working directory.

## 🖼️ Example Plots

### 🧬 Somatic Mutation Landscape (New Samples)

![SMG New](images/smg.new.dnp.all.png)

### 🔬 Somatic Mutation Landscape (Clinical Samples)

![SMG Clinical](images/smg.dnp.all.clinical.png)

### 📈 VAF Correlation Plot

This plot compares variant allele frequencies between samples collected at different tumor time points from the same patient (e.g., primary vs. relapse).

![VAF Correlations](images/vaf_correlations.png)

## 🙋‍♂️ Contact

For questions or feedback, feel free to reach out via [GitHub Issues](https://github.com/syingduo/genoviz/issues) or contact **syingduo** directly.

## 📄 License

This project is licensed under the MIT License.
