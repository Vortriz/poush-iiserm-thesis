#import "globals.typ": *

#show: init-glossary.with(yaml("chapters/glossary.yaml"))

#show: iiserm-thesis.with(
    title: [Title of MS Thesis],
    author: [Name of the Student],
    date: [Enter Relevant Date],
    reg: [Registration Number of the Student],
    committee-members: (
        [Member 1],
        [Member 2],
        [Member 3],
    ),
    supervisor: (
        (
            name: [Name of the Supervisor],
            affiliation: [Indian Institute of Science Education and Research, Mohali],
        ),
        // (
        //     name: "Name of the Co-supervisor",
        //     affiliation: "Indian Institute of Science Education and Research, Mohali"
        // ),
    ),
    colophon-text: [This dissertation was prepared with Typst using #link("https://github.com/Vortriz/poush", [Poush]) template. The main text is set in Libertinus Serif. The monospace font is `DejaVu Sans Mono`.],
)

#centered-section(title: "Abstract")[
    Over the past thirty years, quantum information science—that is, the study of bits that cannot decide if they are 0 or 1—has become one of the most thriving and dynamic subfields of physics. At the time of this writing, complex quantum processors have been developed by various institutions, and measurements from noisy cryogenic circuits allow us to study their properties in unprecedented detail. Complementing these hardware advances, there has recently been an increased interest in methods for processing quantum measurement data, especially through the use of machine learning (ML). This should not come as a surprise, considering that both the detection of quantum states and the characterization of their processes are fundamentally challenging inference problems which require the extraction of information from complex, noisy data that push traditional analysis techniques to their limits.

    In this thesis, we present contributions at the intersection of quantum physics and ML, which trace an arc from the detection of qubit states with the help of ML in readout circuits to the characterization of multi-qubit processes using quantum state tomography. The first study addresses the problem of post-processing readout data. We show how we can combine physical domain knowledge about the data with techniques from the field of causal inference (specifically Half-Sibling Regression) to learn pixel-wise models for the systematic classical noise that allow us to denoise the readouts and thus reveal previously unseen quantum states. We demonstrate the applicability of our approach on superconducting quantum hardware datasets.

    In the second part, we turn to the problem of quantum state tomography; that is, the inference of density matrices from observed projection measurements. We show that we can use neural networks to replace key components in the standard Bayesian inference pipeline; namely the parameterization of the density matrices. This reduces the number of parameters needed to describe a quantum state, thus speeding up reconstruction. In addition, it effectively allows performing state tomography with density matrices from self-consistent models, which are usually too computationally expensive for Bayesian parameter inference.

    Finally, we completely replace the traditional state tomography workflow using stochastic samplers with a simulation-based inference approach based on continuous normalizing flows. We combine this approach with importance sampling to ensure the reliability of our results and show that we can learn models that amortize over different assumptions for the noise in the hardware, thus boosting the practical applicability of our method. We validate it against traditional alternatives through extensive experiments on simulated and real quantum hardware.
]

#set outline(depth: 2)

// ToC
#create-outline(
    preset: outline-presets.toc,
    kind: none,
)

// List of figures
#create-outline(
    preset: outline-presets.figures,
    title: [List of Figures],
)

// List of tables
#create-outline(
    preset: outline-presets.figures,
    title: [List of Tables],
    kind: table,
)

// List of listings
#create-outline(
    preset: outline-presets.figures,
    title: [List of Listings],
    kind: raw,
)


// Body -------------------------------------------

#set page(numbering: "1")
#counter(page).update(1)

#create-part("Prelude")

#include "chapters/introduction.typ"
#include "chapters/detection.typ"

#create-part("Main contributions")

#include "chapters/retrieval.typ"
#include "chapters/sbi.typ"

#create-part("Epilog")

#include "chapters/results.typ"
#include "chapters/conclusion.typ"

// Backmatter -------------------------------------
#set heading(numbering: none)

#centered-section[
    #bibliography("references.bib", style: "apa")
]

#centered-section[
    #glossary(
        title: "Acronyms & Abbreviations",
        theme: acr-theme,
    )
]

#include "chapters/acknowledgements.typ"
