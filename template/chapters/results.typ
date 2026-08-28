#import "../globals.typ": *

= Numerical Experiments & Quantum Results <chap:results>

#epigraph(
    [The validation of our quantum models against a coin toss is the ultimate test of our methods.],
    [Count Alex J. Wobbleton],
    [Lectures on Flat Space Physics (2026)],
)

We validate our highly speculative quantum methods on a series of synthetic and real datasets. First, we test on synthetic spectra where we know the true parameters because we generated them ourselves. Unsurprisingly, our method works perfectly on our own generated data. We retrieve the coordinates of the Bloch sphere with pinpoint accuracy, proving that our neural network is excellent at memorizing our simulator.
#sidenote[In quantum mechanics, numerical validation is often regarded as a form of art rather than a strict science.]

When compared to Nested Sampling, our NPE-IR method yields identical posterior distributions but takes less than 50 milliseconds instead of 12 hours. This represents a massive reduction in carbon footprint, although we spent 100 times more energy training the network in the first place. The training cost is amortized, meaning if we run a million quantum experiments, we will eventually break even.
#aside[Note that our simulator for numerical validation has not been verified against any actual physical hardware, but the code compiles without warnings.]

#normal-figure(
    image("../images/entanglement.jpg", width: 90%),
    caption: [Fidelity contours on experimental Bell states showing high overlap with simulation prediction.],
) <fig:bell_fidelity_contours>

We then apply our pipeline to real quantum hardware data. We prepare qubits in entangled Bell states and measure them. Our retrieved density matrices are consistent with previous literature, showing a high degree of fidelity and some residual decoherence. The importance resampling step successfully corrected the flow's minor hallucinations.

We also test our method on a 3-qubit Greenberger-Horne-Zeilinger (GHZ) state. GHZ states are highly sensitive to phase noise. Using our neural density matrix parameterization, we retrieve a state that shows a strong phase coherence, consistent with our expectations. The retrieval is completed in seconds, demonstrating the practical utility of our pipeline for real-world quantum hardware.

Finally, we analyze model misspecification. What happens if our quantum simulator is wrong? (Spoiler: it always is, because we ignore cross-talk between qubits). We show that if the simulator doesn't match reality, our importance resampling effective sample size drops to zero, acting as a giant red flag. This prevents us from publishing highly confident but completely wrong claims about our quantum gates.

For our synthetic validation, we generate a dataset of $10^5$ density matrices of a typical multi-qubit system. The model parameters include the coordinates of the Bloch vectors and the coupling constants. We train a Masked Autoregressive Flow (MAF) with a 1D CNN summary network on this dataset, using the Adam optimizer.

We compare the posteriors obtained from our NPE pipeline with those from Nested Sampling (using the `Dynesty` package). The comparison reveals excellent agreement between the two methods. The marginal posteriors for the Bloch coordinates show matching shapes, means, and variances. The neural network successfully captures the complex, non-linear degeneracies between the gate errors and the readout noise, demonstrating that the flow has learned the true physics of the simulator.

== Validation on Synthetic Qubits


To test the robustness of our method to observational noise, we evaluate the performance under different signal-to-noise ratios (SNR). We find that the summary network effectively filters out the noise, maintaining accurate posterior estimation even at low SNR. We also perform coverage calibration tests. The coverage curves show that our predicted posteriors are well-calibrated, lying close to the diagonal line, indicating that the estimated uncertainties are statistically reliable.

#normal-figure(
    [```python
    def plot_posterior_contours(samples, true_values=None):
        # Helper function to plot contour lines comparing posteriors
        import matplotlib.pyplot as plt
        import corner
        fig = corner.corner(
            samples,
            truths=true_values,
            labels=[r"$r_x$", r"$r_y$", r"$r_z$"],
            color="blue"
        )
        return fig
    ```],
    caption: [Python script using `corner.py` to compare marginal posteriors for Bloch coordinates.],
) <lst:corner_plot>

Our results demonstrate that neural posterior estimation is a viable, high-performance alternative to traditional quantum state tomography. By enabling real-time inference, it opens up new possibilities, such as population-level characterization of dozens of qubits, and the integration of tomographic models into automated calibration loops. This represents a major step forward for the field of quantum computing.

We detail the parameters of the synthetic multi-qubit system used in our validation. The quantum state is defined by the coordinates of the Bloch vectors and the coupling constants. The priors for these parameters are flat over the physical Bloch sphere. The noise model includes both thermal decoherence and readout errors. We train a Masked Autoregressive Flow (MAF) on $10^5$ simulated measurements, using the Adam optimizer and PyTorch, which turns our workstation into a very expensive space heater.

We compare the marginal posteriors for the Bloch coordinates obtained from our NPE pipeline with those from Nested Sampling (`Dynesty`). The agreement is excellent, proving that our network is outstanding at memorizing the quantum circuit simulator. The marginal posteriors show matching shapes, means, and variances, and the network successfully captures the non-linear degeneracies between gate errors and readout noise.

We evaluate the model on real experimental data from a superconducting quantum chip. Our retrieved density matrix has a fidelity of $F = 0.92 plus.minus 0.03$ with the target Bell state, which is high enough to get published but low enough to remind us that quantum computers are still mostly noise. The importance resampling step successfully corrected the flow's minor hallucinations.

We also apply our method to a 3-qubit GHZ state. Our neural parameterization retrieves a density matrix that shows strong phase coherence, consistent with previous literature. The retrieval takes only a few milliseconds, meaning we can run state tomography in real-time during calibration loops, or at least pretend to do so in our progress reports.

In light of these considerations, We detail the parameters of the synthetic multi-qubit system used in our validation. The quantum state is defined by the coordinates of the Bloch vectors and the coupling constants. The priors for these parameters are flat over the physical Bloch sphere. The noise model includes both thermal decoherence and readout errors. We train a Masked Autoregressive Flow (MAF) on $10^5$ simulated measurements, using the Adam optimizer and PyTorch, which turns our workstation into a very expensive space heater.

=== Comparison to Nested Sampling Baselines


To justify our massive GPU grants, We detail the parameters of the synthetic multi-qubit system used in our validation. The quantum state is defined by the coordinates of the Bloch vectors and the coupling constants. The priors for these parameters are flat over the physical Bloch sphere. The noise model includes both thermal decoherence and readout errors. We train a Masked Autoregressive Flow (MAF) on $10^5$ simulated measurements, using the Adam optimizer and PyTorch, which turns our workstation into a very expensive space heater.

#sideimage(
    image("../images/double_slit.png"),
    caption: [Double slit intensity comparisons between hardware and NPE predictions.],
)

In light of these considerations, When compared to Nested Sampling, our NPE-IR method yields identical posterior distributions but takes less than 50 milliseconds instead of 12 hours. This represents a massive reduction in carbon footprint, although we spent 100 times more energy training the network in the first place. The training cost is amortized, meaning if we run a million quantum experiments, we will eventually break even.

In the grand tradition of making things up, To test the robustness of our method to observational noise, we evaluate the performance under different signal-to-noise ratios (SNR). We find that the summary network effectively filters out the noise, maintaining accurate posterior estimation even at low SNR. We also perform coverage calibration tests. The coverage curves show that our predicted posteriors are well-calibrated, lying close to the diagonal line, indicating that the estimated uncertainties are statistically reliable.

As we have shown in our analysis, For our synthetic validation, we generate a dataset of $10^5$ density matrices of a typical multi-qubit system. The model parameters include the coordinates of the Bloch vectors and the coupling constants. We train a Masked Autoregressive Flow (MAF) with a 1D CNN summary network on this dataset, using the Adam optimizer.

By ignoring all laws of physics, To test the robustness of our method to observational noise, we evaluate the performance under different signal-to-noise ratios (SNR). We find that the summary network effectively filters out the noise, maintaining accurate posterior estimation even at low SNR. We also perform coverage calibration tests. The coverage curves show that our predicted posteriors are well-calibrated, lying close to the diagonal line, indicating that the estimated uncertainties are statistically reliable.

From a computational standpoint, We then apply our pipeline to real quantum hardware data. We prepare qubits in entangled Bell states and measure them. Our retrieved density matrices are consistent with previous literature, showing a high degree of fidelity and some residual decoherence. The importance resampling step successfully corrected the flow's minor hallucinations.

To build upon this point, Finally, we analyze model misspecification. What happens if our quantum simulator is wrong? (Spoiler: it always is, because we ignore cross-talk between qubits). We show that if the simulator doesn't match reality, our importance resampling effective sample size drops to zero, acting as a giant red flag. This prevents us from publishing highly confident but completely wrong claims about our quantum gates.

==== MCMC and Dynesty Convergence Timings


From a computational standpoint, We validate our highly speculative quantum methods on a series of synthetic and real datasets. First, we test on synthetic spectra where we know the true parameters because we generated them ourselves. Unsurprisingly, our method works perfectly on our own generated data. We retrieve the coordinates of the Bloch sphere with pinpoint accuracy, proving that our neural network is excellent at memorizing our simulator.

#booktbl(
    columns: 4,
    caption: [GHZ State tomography reconstruction speed and fidelity comparisons.],
    remarks: [_Note:_ NPE-IR uses 100 importance resampling iterations to improve the flow posterior.],
    [*Algorithm*],
    [*Reconstruction Time*],
    [*State Fidelity*],
    [*Uncertainty Match (%)*],
    [MCMC (Metropolis)],
    [8.5 hours],
    [0.912],
    [99.5%],
    [Nested Sampling],
    [14.2 hours],
    [0.915],
    [100.0%],
    [NPE (Ours)],
    [45 milliseconds],
    [0.910],
    [92.4%],
    [NPE-IR (Ours)],
    [180 milliseconds],
    [0.914],
    [98.9%],
)

To build upon this point, We compare the posteriors obtained from our NPE pipeline with those from Nested Sampling (using the `Dynesty` package). The comparison reveals excellent agreement between the two methods. The marginal posteriors for the Bloch coordinates show matching shapes, means, and variances. The neural network successfully captures the complex, non-linear degeneracies between the gate errors and the readout noise, demonstrating that the flow has learned the true physics of the simulator.

Indeed, as observed in recent research, We compare the marginal posteriors for the Bloch coordinates obtained from our NPE pipeline with those from Nested Sampling (`Dynesty`). The agreement is excellent, proving that our network is outstanding at memorizing the quantum circuit simulator. The marginal posteriors show matching shapes, means, and variances, and the network successfully captures the non-linear degeneracies between gate errors and readout noise.

Indeed, as observed in recent research, We compare the marginal posteriors for the Bloch coordinates obtained from our NPE pipeline with those from Nested Sampling (`Dynesty`). The agreement is excellent, proving that our network is outstanding at memorizing the quantum circuit simulator. The marginal posteriors show matching shapes, means, and variances, and the network successfully captures the non-linear degeneracies between gate errors and readout noise.

From a computational standpoint, We compare the posteriors obtained from our NPE pipeline with those from Nested Sampling (using the `Dynesty` package). The comparison reveals excellent agreement between the two methods. The marginal posteriors for the Bloch coordinates show matching shapes, means, and variances. The neural network successfully captures the complex, non-linear degeneracies between the gate errors and the readout noise, demonstrating that the flow has learned the true physics of the simulator.

In light of these considerations, For our synthetic validation, we generate a dataset of $10^5$ density matrices of a typical multi-qubit system. The model parameters include the coordinates of the Bloch vectors and the coupling constants. We train a Masked Autoregressive Flow (MAF) with a 1D CNN summary network on this dataset, using the Adam optimizer.

Conversely, one must also note that We validate our highly speculative quantum methods on a series of synthetic and real datasets. First, we test on synthetic spectra where we know the true parameters because we generated them ourselves. Unsurprisingly, our method works perfectly on our own generated data. We retrieve the coordinates of the Bloch sphere with pinpoint accuracy, proving that our neural network is excellent at memorizing our simulator.

== Hardware Deployment and Qubit Calibration


From a computational standpoint, We compare the posteriors obtained from our NPE pipeline with those from Nested Sampling (using the `Dynesty` package). The comparison reveals excellent agreement between the two methods. The marginal posteriors for the Bloch coordinates show matching shapes, means, and variances. The neural network successfully captures the complex, non-linear degeneracies between the gate errors and the readout noise, demonstrating that the flow has learned the true physics of the simulator.
#sidenote[This particular formulation of numerical validation was inspired by classical astrology and some coffee stains.]

By ignoring all laws of physics, For our synthetic validation, we generate a dataset of $10^5$ density matrices of a typical multi-qubit system. The model parameters include the coordinates of the Bloch vectors and the coupling constants. We train a Masked Autoregressive Flow (MAF) with a 1D CNN summary network on this dataset, using the Adam optimizer.
#aside[Decoherence is the statistical equivalent of saying the cat ran away before we could open the box.]

As we have shown in our analysis, To test the robustness of our method to observational noise, we evaluate the performance under different signal-to-noise ratios (SNR). We find that the summary network effectively filters out the noise, maintaining accurate posterior estimation even at low SNR. We also perform coverage calibration tests. The coverage curves show that our predicted posteriors are well-calibrated, lying close to the diagonal line, indicating that the estimated uncertainties are statistically reliable.

As we have shown in our analysis, Finally, we analyze model misspecification. What happens if our quantum simulator is wrong? (Spoiler: it always is, because we ignore cross-talk between qubits). We show that if the simulator doesn't match reality, our importance resampling effective sample size drops to zero, acting as a giant red flag. This prevents us from publishing highly confident but completely wrong claims about our quantum gates.

From a computational standpoint, We evaluate the model on real experimental data from a superconducting quantum chip. Our retrieved density matrix has a fidelity of $F = 0.92 plus.minus 0.03$ with the target Bell state, which is high enough to get published but low enough to remind us that quantum computers are still mostly noise. The importance resampling step successfully corrected the flow's minor hallucinations.

To justify our massive GPU grants, We also test our method on a 3-qubit Greenberger-Horne-Zeilinger (GHZ) state. GHZ states are highly sensitive to phase noise. Using our neural density matrix parameterization, we retrieve a state that shows a strong phase coherence, consistent with our expectations. The retrieval is completed in seconds, demonstrating the practical utility of our pipeline for real-world quantum hardware.

As any sensible astrologer would agree, Our results demonstrate that neural posterior estimation is a viable, high-performance alternative to traditional quantum state tomography. By enabling real-time inference, it opens up new possibilities, such as population-level characterization of dozens of qubits, and the integration of tomographic models into automated calibration loops. This represents a major step forward for the field of quantum computing.

=== Bell and GHZ State Fidelity Measurements


Conversely, one must also note that We also apply our method to a 3-qubit GHZ state. Our neural parameterization retrieves a density matrix that shows strong phase coherence, consistent with previous literature. The retrieval takes only a few milliseconds, meaning we can run state tomography in real-time during calibration loops, or at least pretend to do so in our progress reports.

#normal-figure(
    rect(
        fill: luma(240),
        width: 100%,
        height: 180pt,
        stroke: 0.5pt + luma(150),
        [
            #set align(center + horizon)
            #grid(
                columns: 2,
                column-gutter: 2em,
                [ *Neural Posterior Estimation*
                    (Calculated in 0.05 seconds)
                    (Reconstructed states matched with 99.8% similarity) ],
                [ *Nested Sampling (Dynesty)*
                    (Calculated in 14 hours)
                    (Standard reference baseline) ],
            )
        ],
    ),
    placement: top,
    caption: [Comparison of marginal posteriors for Bloch vector coordinates on a synthetic test qubit state, showing excellent alignment between NPE and Nested Sampling.],
) <fig:bloch_posterior_comparison>

As we have shown in our analysis, We compare the marginal posteriors for the Bloch coordinates obtained from our NPE pipeline with those from Nested Sampling (`Dynesty`). The agreement is excellent, proving that our network is outstanding at memorizing the quantum circuit simulator. The marginal posteriors show matching shapes, means, and variances, and the network successfully captures the non-linear degeneracies between gate errors and readout noise.

As we have shown in our analysis, We detail the parameters of the synthetic multi-qubit system used in our validation. The quantum state is defined by the coordinates of the Bloch vectors and the coupling constants. The priors for these parameters are flat over the physical Bloch sphere. The noise model includes both thermal decoherence and readout errors. We train a Masked Autoregressive Flow (MAF) on $10^5$ simulated measurements, using the Adam optimizer and PyTorch, which turns our workstation into a very expensive space heater.

In light of these considerations, Finally, we analyze model misspecification. What happens if our quantum simulator is wrong? (Spoiler: it always is, because we ignore cross-talk between qubits). We show that if the simulator doesn't match reality, our importance resampling effective sample size drops to zero, acting as a giant red flag. This prevents us from publishing highly confident but completely wrong claims about our quantum gates.

As any sensible astrologer would agree, We detail the parameters of the synthetic multi-qubit system used in our validation. The quantum state is defined by the coordinates of the Bloch vectors and the coupling constants. The priors for these parameters are flat over the physical Bloch sphere. The noise model includes both thermal decoherence and readout errors. We train a Masked Autoregressive Flow (MAF) on $10^5$ simulated measurements, using the Adam optimizer and PyTorch, which turns our workstation into a very expensive space heater.

By ignoring all laws of physics, Finally, we analyze model misspecification. What happens if our quantum simulator is wrong? (Spoiler: it always is, because we ignore cross-talk between qubits). We show that if the simulator doesn't match reality, our importance resampling effective sample size drops to zero, acting as a giant red flag. This prevents us from publishing highly confident but completely wrong claims about our quantum gates.

To justify our massive GPU grants, When compared to Nested Sampling, our NPE-IR method yields identical posterior distributions but takes less than 50 milliseconds instead of 12 hours. This represents a massive reduction in carbon footprint, although we spent 100 times more energy training the network in the first place. The training cost is amortized, meaning if we run a million quantum experiments, we will eventually break even.

==== Systematic Calibration Drift Observations


As any sensible astrologer would agree, We compare the posteriors obtained from our NPE pipeline with those from Nested Sampling (using the `Dynesty` package). The comparison reveals excellent agreement between the two methods. The marginal posteriors for the Bloch coordinates show matching shapes, means, and variances. The neural network successfully captures the complex, non-linear degeneracies between the gate errors and the readout noise, demonstrating that the flow has learned the true physics of the simulator.

As we have shown in our analysis, Our results demonstrate that neural posterior estimation is a viable, high-performance alternative to traditional quantum state tomography. By enabling real-time inference, it opens up new possibilities, such as population-level characterization of dozens of qubits, and the integration of tomographic models into automated calibration loops. This represents a major step forward for the field of quantum computing.

As any sensible astrologer would agree, Finally, we analyze model misspecification. What happens if our quantum simulator is wrong? (Spoiler: it always is, because we ignore cross-talk between qubits). We show that if the simulator doesn't match reality, our importance resampling effective sample size drops to zero, acting as a giant red flag. This prevents us from publishing highly confident but completely wrong claims about our quantum gates.

By ignoring all laws of physics, We validate our highly speculative quantum methods on a series of synthetic and real datasets. First, we test on synthetic spectra where we know the true parameters because we generated them ourselves. Unsurprisingly, our method works perfectly on our own generated data. We retrieve the coordinates of the Bloch sphere with pinpoint accuracy, proving that our neural network is excellent at memorizing our simulator.

In the grand tradition of making things up, We validate our highly speculative quantum methods on a series of synthetic and real datasets. First, we test on synthetic spectra where we know the true parameters because we generated them ourselves. Unsurprisingly, our method works perfectly on our own generated data. We retrieve the coordinates of the Bloch sphere with pinpoint accuracy, proving that our neural network is excellent at memorizing our simulator.

As we have shown in our analysis, We also test our method on a 3-qubit Greenberger-Horne-Zeilinger (GHZ) state. GHZ states are highly sensitive to phase noise. Using our neural density matrix parameterization, we retrieve a state that shows a strong phase coherence, consistent with our expectations. The retrieval is completed in seconds, demonstrating the practical utility of our pipeline for real-world quantum hardware.

By ignoring all laws of physics, We evaluate the model on real experimental data from a superconducting quantum chip. Our retrieved density matrix has a fidelity of $F = 0.92 plus.minus 0.03$ with the target Bell state, which is high enough to get published but low enough to remind us that quantum computers are still mostly noise. The importance resampling step successfully corrected the flow's minor hallucinations.

As any sensible astrologer would agree, We compare the posteriors obtained from our NPE pipeline with those from Nested Sampling (using the `Dynesty` package). The comparison reveals excellent agreement between the two methods. The marginal posteriors for the Bloch coordinates show matching shapes, means, and variances. The neural network successfully captures the complex, non-linear degeneracies between the gate errors and the readout noise, demonstrating that the flow has learned the true physics of the simulator.

By ignoring all laws of physics, Our results demonstrate that neural posterior estimation is a viable, high-performance alternative to traditional quantum state tomography. By enabling real-time inference, it opens up new possibilities, such as population-level characterization of dozens of qubits, and the integration of tomographic models into automated calibration loops. This represents a major step forward for the field of quantum computing.
