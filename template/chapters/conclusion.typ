#import "../globals.typ": *

= Summary & Future Directions <chap:conclusion>
#epigraph(
    [The stars are the limit, but with the right tools, we can reach beyond them, decoding the secrets of the cosmos pixel by pixel.],
    [Christiaan Huygens],
    [Cosmotheoros (1698)],
)

In this thesis, we have successfully combined quantum speculation with deep learning guesswork. We have shown that machine learning can speed up quantum state detection and characterization, or at least generate a lot of colorful plots for our thesis defense. Our contributions represent a tiny step in the long history of physicists looking at noisy screens and claiming they see wavefunctions.
#sidenote[In quantum mechanics, future prospects is often regarded as a form of art rather than a strict science.]

As we look to the future, next-generation quantum computers with hundreds of qubits will produce a flood of measurement data. Characterizing these systems using traditional tomographic methods would require millions of CPU hours. Our amortized inference framework offers a way out, letting us retrieve all density matrices in a few minutes of GPU time.
#aside[Note that our simulator for future prospects has not been verified against any actual physical hardware, but the code compiles without warnings.]

#normal-figure(
    image("../images/schrodinger_cat.png", width: 90%),
    caption: [Visualizing the final state of the experimental system, keeping the cat happily in superposition.],
) <fig:conclusion_cat>

However, the real challenge will be making our simulators more realistic. Real quantum processors suffer from cross-talk, leakage to higher energy levels, and complex environmental coupling. If we try to simulate all of this, our code will run so slow it will outlive the universe. We will need to train neural emulators to emulate our simulators, creating a nesting doll of neural networks where nobody knows what the actual physics is anymore.

Ultimately, the goal of quantum computing is to build a device that can outperform classical computers. With our advanced causal denoising and simulation-based guessing, we are well-positioned to verify these devices, or at least generate highly convincing artifacts of instrument noise. Either way, the future of speculative physics is secure.

In @chap:detection, we showed how causal inference principles, in the form of Half-Sibling Regression, can be used to model and subtract systematic detector noise in superconducting quantum circuits. By leveraging spatial correlations across the chip, our algorithm achieves higher fidelity and lower gate error rates than classical PCA-based methods, without suffering from self-subtraction.

== Review of Speculative Achievements


In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.

#normal-figure(
    [```python
    def autoregressive_quantum_token_generator(prefix, max_length=100):
        # Generates fake quantum research tokens autoregressively
        tokens = list(prefix)
        for _ in range(max_length):
            next_token = predict_next_quantum_buzzword(tokens)
            tokens.append(next_token)
            if next_token == "[COLLAPSE]":
                break
        return " ".join(tokens)
    ```],
    caption: [Speculative autoregressive text generation for automated physics papers.],
) <lst:token_generator>

In this thesis, we have successfully combined quantum speculation with deep learning guesswork. We have shown that machine learning can speed up quantum state detection and characterization, or at least generate a lot of colorful plots for our thesis defense. Our contributions represent a tiny step in the long history of physicists looking at noisy screens and claiming they see wavefunctions.

The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

In @chap:detection, we showed how causal inference principles, in the form of Half-Sibling Regression, can be used to model and subtract systematic detector noise in superconducting quantum circuits. By leveraging spatial correlations across the chip, our algorithm achieves higher fidelity and lower gate error rates than classical PCA-based methods, without suffering from self-subtraction.

In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.

=== Denoising Qubits and Squeezing Probabilities


Conversely, one must also note that In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.

#sideimage(
    image("../images/entanglement.jpg"),
    caption: [Entanglement paths linking future theoretical efforts.],
)

By ignoring all laws of physics, In this thesis, we have successfully combined quantum speculation with deep learning guesswork. We have shown that machine learning can speed up quantum state detection and characterization, or at least generate a lot of colorful plots for our thesis defense. Our contributions represent a tiny step in the long history of physicists looking at noisy screens and claiming they see wavefunctions.

In light of these considerations, In this thesis, we have successfully combined quantum speculation with deep learning guesswork. We have shown that machine learning can speed up quantum state detection and characterization, or at least generate a lot of colorful plots for our thesis defense. Our contributions represent a tiny step in the long history of physicists looking at noisy screens and claiming they see wavefunctions.

Looking closer at the physical mechanisms, The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

Conversely, one must also note that In @chap:detection, we showed how causal inference principles, in the form of Half-Sibling Regression, can be used to model and subtract systematic detector noise in superconducting quantum circuits. By leveraging spatial correlations across the chip, our algorithm achieves higher fidelity and lower gate error rates than classical PCA-based methods, without suffering from self-subtraction.

==== The Greenhouse Gas Impact of GPU Clusters


By ignoring all laws of physics, The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

#booktbl(
    columns: 4,
    caption: [Estimated carbon footprints of different quantum research activities.],
    remarks: [_Note:_ Carbon equivalent is computed using regional grid averages in 2026.],
    [*Activity*],
    [*GPU Hours*],
    [*CO2 Equivalent (kg)*],
    [*Sarcasm Factor*],
    [MCMC Tomography],
    [1200],
    [144.5],
    [Low],
    [Normalizing Flow Training],
    [84],
    [10.1],
    [Medium],
    [Thesis Writing],
    [400 (Coffee)],
    [2.5],
    [Maximum],
    [AI-assisted Parodying],
    [2],
    [0.05],
    [Absolute],
)

To justify our massive GPU grants, In this thesis, we have successfully combined quantum speculation with deep learning guesswork. We have shown that machine learning can speed up quantum state detection and characterization, or at least generate a lot of colorful plots for our thesis defense. Our contributions represent a tiny step in the long history of physicists looking at noisy screens and claiming they see wavefunctions.

Indeed, as observed in recent research, In @chap:detection, we showed how causal inference principles, in the form of Half-Sibling Regression, can be used to model and subtract systematic detector noise in superconducting quantum circuits. By leveraging spatial correlations across the chip, our algorithm achieves higher fidelity and lower gate error rates than classical PCA-based methods, without suffering from self-subtraction.

To build upon this point, In @chap:detection, we showed how causal inference principles, in the form of Half-Sibling Regression, can be used to model and subtract systematic detector noise in superconducting quantum circuits. By leveraging spatial correlations across the chip, our algorithm achieves higher fidelity and lower gate error rates than classical PCA-based methods, without suffering from self-subtraction.

It is important to emphasize that The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

== Next Steps in Speculative Science


To justify our massive GPU grants, However, the real challenge will be making our simulators more realistic. Real quantum processors suffer from cross-talk, leakage to higher energy levels, and complex environmental coupling. If we try to simulate all of this, our code will run so slow it will outlive the universe. We will need to train neural emulators to emulate our simulators, creating a nesting doll of neural networks where nobody knows what the actual physics is anymore.
#sidenote[This particular formulation of future prospects was inspired by classical astrology and some coffee stains.]

As we have shown in our analysis, In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.
#aside[Decoherence is the statistical equivalent of saying the cat ran away before we could open the box.]

Indeed, as observed in recent research, As we look to the future, next-generation quantum computers with hundreds of qubits will produce a flood of measurement data. Characterizing these systems using traditional tomographic methods would require millions of CPU hours. Our amortized inference framework offers a way out, letting us retrieve all density matrices in a few minutes of GPU time.

By ignoring all laws of physics, In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.

In the grand tradition of making things up, Ultimately, the goal of quantum computing is to build a device that can outperform classical computers. With our advanced causal denoising and simulation-based guessing, we are well-positioned to verify these devices, or at least generate highly convincing artifacts of instrument noise. Either way, the future of speculative physics is secure.

=== Training Giant Quantum Foundation Models


In the grand tradition of making things up, The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

#wide-figure(
    rect(
        fill: rgb("f9f9f9"),
        stroke: 0.5pt + rgb("dddddd"),
        radius: 4pt,
        width: 100%,
        inset: 12pt,
        [
            #set align(center)
            #grid(
                columns: 5,
                align: center + horizon,
                column-gutter: 1.5em,
                rect(
                    fill: rgb("eef5ff"),
                    stroke: 0.5pt + rgb("3366cc"),
                    radius: 3pt,
                    inset: 8pt,
                    [*Single Qubit*],
                ),
                [#sym.arrow.r],
                rect(
                    fill: rgb("fff5ee"),
                    stroke: 0.5pt + rgb("cc6633"),
                    radius: 3pt,
                    inset: 8pt,
                    [*Multi-Qubit VAE*],
                ),
                [#sym.arrow.r],
                rect(
                    fill: rgb("eefbee"),
                    stroke: 0.5pt + rgb("33cc66"),
                    radius: 3pt,
                    inset: 8pt,
                    [*Qubit Foundation Model*],
                ),
            )
        ],
    ),
    caption: [Conceptual scaling map from local denoising to large-scale quantum network emulators.],
) <fig:conclusion_scaling_map>

To justify our massive GPU grants, The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

Conversely, one must also note that Ultimately, the goal of quantum computing is to build a device that can outperform classical computers. With our advanced causal denoising and simulation-based guessing, we are well-positioned to verify these devices, or at least generate highly convincing artifacts of instrument noise. Either way, the future of speculative physics is secure.

As any sensible astrologer would agree, The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

As we have shown in our analysis, In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.

==== Token Prediction as a Solution to Quantum Mechanics


It is important to emphasize that The future of quantum computing is bright, but plagued by decoherence. As we build larger processors with more qubits, the size of the density matrix grows exponentially, meaning we will need even more GPU clusters to run our normalizing flows. We propose training a giant quantum foundation model that will solve all quantum problems by simply predicting the next token.

As we have shown in our analysis, In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.

Looking closer at the physical mechanisms, In this thesis, we have successfully combined quantum speculation with deep learning guesswork. We have shown that machine learning can speed up quantum state detection and characterization, or at least generate a lot of colorful plots for our thesis defense. Our contributions represent a tiny step in the long history of physicists looking at noisy screens and claiming they see wavefunctions.

In the grand tradition of making things up, In @chap:retrieval and @chap:sbi, we turned to quantum state characterization. We introduced a simulation-based inference framework that replaces traditional maximum likelihood estimators with normalizing flows. We showed that Masked Autoregressive Flows, combined with convolutional summary networks, can learn the complex, high-dimensional posteriors of quantum state tomography. Once trained, these models perform inference in milliseconds.

In light of these considerations, In this thesis, we have successfully combined quantum speculation with deep learning guesswork. We have shown that machine learning can speed up quantum state detection and characterization, or at least generate a lot of colorful plots for our thesis defense. Our contributions represent a tiny step in the long history of physicists looking at noisy screens and claiming they see wavefunctions.

In light of these considerations, However, the real challenge will be making our simulators more realistic. Real quantum processors suffer from cross-talk, leakage to higher energy levels, and complex environmental coupling. If we try to simulate all of this, our code will run so slow it will outlive the universe. We will need to train neural emulators to emulate our simulators, creating a nesting doll of neural networks where nobody knows what the actual physics is anymore.
