#import "../globals.typ": *

= Simulation-Based Quantum Inference & Normalizing Flows <chap:sbi>
#epigraph(
    [When the wavefunction is too complex to integrate, we let the normalizing flows squeeze the probabilities like toothpaste.],
    [Frank Flow-Maker],
    [Normalizing Flows in Flat Space (2021)],
)

Simulation-Based Inference (SBI) is the statistical equivalent of saying 'I don't want to do any math, so I'll just run my code a million times.' It is designed for situations where we have a simulator (our quantum circuit code) but no idea how to write down the likelihood of our noisy measurements. SBI bypasses the likelihood entirely by training a deep neural network to learn the mapping from measurement results to parameters directly.
#sidenote[In quantum mechanics, simulation-based inference is often regarded as a form of art rather than a strict science.]

To model the posterior distribution, we use normalizing flows. A normalizing flow is a sequence of neural network transformations that takes a boring Gaussian distribution and stretches, squeezes, and warps it until it looks like our complex, degenerate quantum posterior. It is like taking a ball of play-doh and molding it into a replica of the Bloch sphere. If the flow is good, we get a nice posterior; if not, we get a mess.
#aside[Note that our simulator for simulation-based inference has not been verified against any actual physical hardware, but the code compiles without warnings.]

#normal-figure(
    image("../images/double_slit.png", width: 90%),
    caption: [Comparison of probability densities. The left shows a standard Gaussian, and the right shows a deformed flow distribution matching the quantum data.],
) <fig:probability_flow_mapping>

The main advantage of Neural Posterior Estimation (NPE) is amortization. We spend a few hours training the network offline on a GPU cluster. Once it is trained, we can feed it a new observed measurement vector and get the posterior in milliseconds. This is a speedup of six orders of magnitude compared to traditional sampling. We can now reconstruct a quantum state faster than we can explain what a qubit is to our parents.

Of course, the downside is that neural networks are notorious liars. If the observed measurement is slightly different from the training data, the network will confidently output a completely wrong answer. To prevent this, we developed NPE with Importance Resampling (NPE-IR). We use the network's output as a proposal distribution, draw a few samples, evaluate the actual simulator, and adjust the weights. This corrects the network's mistakes and gives us statistical peace of mind.

We also perform coverage calibration, which is a way of checking if our error bars are honest. If our network claims to be 90% sure, it should be right 90% of the time. We plot coverage curves, and if they align with the diagonal, we declare victory and submit the paper. If they don't, we tweak the hyperparameters and pretend it never happened.

There are several approaches to SBI, including Neural Posterior Estimation (NPE), Neural Likelihood Estimation (NLE), and Neural Ratio Estimation (NRE). In this thesis, we focus on NPE, which directly learns the posterior distribution $p(theta | D)$ from a set of simulated pairs $(theta_i, D_i)$. Once trained, the neural network can amortize the inference, providing the posterior for any new observation in a fraction of a second.

== Bypassing the Unintegrable Likelihoods


To represent the complex, multi-modal posterior distributions that often arise in quantum state estimation, we use normalizing flows. A normalizing flow is a sequence of invertible, differentiable transformations that maps a simple base distribution (such as a standard Gaussian) to a complex target distribution. By conditioning the transformations on the observed data $D$, we can model the conditional posterior $p(theta | D)$.

#normal-figure(
    [```python
    import torch
    import torch.nn as nn
    from nflows.flows import Flow
    from nflows.distributions import StandardNormal
    from nflows.transforms import CompositeTransform, MaskedAffineAutoregressiveTransform

    class QuantumStateNPE(nn.Module):
        def __init__(self, num_params, num_features):
            super().__init__()
            self.summary_net = nn.Sequential(
                nn.Conv1d(1, 16, kernel_size=5, stride=2),
                nn.ReLU(),
                nn.Flatten(),
                nn.Linear(16 * 48, num_features)
            )

            # Build normalizing flow
            base_dist = StandardNormal(shape=[num_params])
            transforms = []
            for _ in range(5):
                transforms.append(MaskedAffineAutoregressiveTransform(
                    features=num_params,
                    hidden_features=64,
                    context_features=num_features
                ))
            self.flow = Flow(CompositeTransform(transforms), base_dist)

        def forward(self, params, measurements):
            context = self.summary_net(measurements)
            return -self.flow.log_prob(params, context=context).mean()
    ```],
    caption: [PyTorch implementation of the Quantum State NPE architecture using the `nflows` library.],
) <npe-pytorch>

Let $u$ be a random variable from the base distribution $p_u(u)$, and let $f_phi$ be a bijective function parameterized by a neural network. The transformed variable is $theta = f_phi(u; D)$. By the change of variables formula, the probability density of $theta$ is:
$
    p(theta | D) = p_u(f_phi^-1(theta; D)) | det (partial f_phi^-1(theta; D)) / (partial theta) |
$
To make this tractable, the transformations must have a Jacobian matrix whose determinant is easy to compute. Popular architectures include Masked Autoregressive Flows (MAF) and Neural Spline Flows (NSF).

Training the normalizing flow involves minimizing the Kullback-Leibler (KL) divergence between the true posterior and the modeled distribution. This is equivalent to maximizing the log-likelihood of the simulated parameters under the flow:
$ cal(L)(phi) = -1/N sum_(i=1)^N log p_phi(theta_i | D_i) $
Since the simulator can generate an arbitrary number of training samples, we can train the network until it generalizes well to unseen data, avoiding overfitting.

A key advantage of NPE is amortization. The computationally expensive training phase is performed once offline. After the model is trained, evaluating the posterior for a new observation requires only a single forward pass through the network, which takes milliseconds. This allows for real-time inference and makes it feasible to perform state tomography on large populations of qubits, or to run extensive sensitivity analyses.

We also explore the use of summary networks. Often, quantum measurement vectors contain thousands of projections, representing high-dimensional data. To help the normalizing flow learn the posterior, we first pass the measurement vector through a summary network (such as a 1D CNN or a Transformer) that compresses the vector into a low-dimensional feature vector. The normalizing flow is then conditioned on this feature vector, improving training stability.

This comprehensive framework represents a significant departure from traditional tomographic methods. By replacing the online stochastic search with an offline simulation-and-training paradigm, we can unlock new capabilities in quantum characterization. In @chap:results, we demonstrate the practical application of this method on both simulated and real data, showcasing its speed, accuracy, and robustness.

=== Amortized Inference via Deep Learning


In simulation-based quantum inference, we train a conditional normalizing flow $q_phi(theta | D)$ to learn the posterior distribution of our quantum parameters. The flow is defined by a series of invertible transformations $f_k$:
$ z_0 = u, z_k = f_k(z_(k-1); D), theta = z_K $
where $u$ is sampled from a standard Gaussian base distribution. Conditioning the transformations on the high-dimensional measurement vector $D$ allows the network to output the posterior for any new experiment in a fraction of a second.

#sideimage(
    image("../images/schrodinger_cat.png"),
    caption: [Cat state probability distribution mapped via Normalizing Flows.],
)

The log-probability density of the flow posterior is computed using the change of variables formula:
$
    log q_phi(theta | D) = log p_u(f^-1(theta; D)) - sum_k log | det (partial f_k(z_(k-1); D)) / (partial z_(k-1)) |
$
We use this mathematical formulation to convince our thesis committee that we are doing rigorous statistical mechanics, rather than just using a neural network to draw nice contours on a plot.

In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.

To verify that our flow posteriors are statistically accurate, we perform coverage calibration. Let $C_alpha(D)$ be the credible interval with nominal credibility level $alpha$:
$ integral_(C_alpha(D)) q_phi(theta | D) d theta = alpha $
We check if the true parameters fall within $C_alpha(D)$ for a fraction $alpha$ of the test cases. If our coverage curve lies below the diagonal, our model is overconfident, which is a polite way of saying it is bragging; if it lies above, it is underconfident, which means it is playing safe.

Importance resampling provides a way to correct any approximation errors in the flow. Given a measurement vector $D$, we draw samples $theta_i$ from $q_phi(theta | D)$, evaluate the true likelihood and prior, and compute the normalized weights:
$ w_i = (p(D | theta_i) * p(theta_i)) / q_phi(theta_i | D) $
The effective sample size (ESS) is given by $N_(e f f) = 1 / sum_i (w_i)^2$. A low ESS warns us that the flow is hallucinating, preventing us from claiming we solved quantum mechanics when our code actually crashed.

Looking closer at the physical mechanisms, We also perform coverage calibration, which is a way of checking if our error bars are honest. If our network claims to be 90% sure, it should be right 90% of the time. We plot coverage curves, and if they align with the diagonal, we declare victory and submit the paper. If they don't, we tweak the hyperparameters and pretend it never happened.

==== Neural Posterior Estimation Details


To justify our massive GPU grants, In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.

#booktbl(
    columns: 5,
    caption: [Hyperparameters for Normalizing Flow training loops.],
    remarks: [_Note:_ Training was performed on a cluster of NVIDIA H100 GPUs.],
    [*Hyperparameter*],
    [*Value (Default)*],
    [*Value (Large)*],
    [*Impact on Loss*],
    [*Search Range*],
    [Learning Rate],
    [1e-3],
    [5e-4],
    [High],
    [1e-4 - 1e-2],
    [Batch Size],
    [256],
    [1024],
    [Medium],
    [64 - 2048],
    [Flow Layers],
    [5],
    [10],
    [High],
    [3 - 15],
    [Spline Knots],
    [8],
    [16],
    [Low],
    [4 - 32],
)

As any sensible astrologer would agree, In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.

To build upon this point, In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.

In light of these considerations, A key advantage of NPE is amortization. The computationally expensive training phase is performed once offline. After the model is trained, evaluating the posterior for a new observation requires only a single forward pass through the network, which takes milliseconds. This allows for real-time inference and makes it feasible to perform state tomography on large populations of qubits, or to run extensive sensitivity analyses.

Indeed, as observed in recent research, In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.

As we have shown in our analysis, There are several approaches to SBI, including Neural Posterior Estimation (NPE), Neural Likelihood Estimation (NLE), and Neural Ratio Estimation (NRE). In this thesis, we focus on NPE, which directly learns the posterior distribution $p(theta | D)$ from a set of simulated pairs $(theta_i, D_i)$. Once trained, the neural network can amortize the inference, providing the posterior for any new observation in a fraction of a second.

== Normalizing Flows: Toothpaste Squeezing for Probabilities


Indeed, as observed in recent research, Importance resampling provides a way to correct any approximation errors in the flow. Given a measurement vector $D$, we draw samples $theta_i$ from $q_phi(theta | D)$, evaluate the true likelihood and prior, and compute the normalized weights:
$ w_i = (p(D | theta_i) * p(theta_i)) / q_phi(theta_i | D) $
The effective sample size (ESS) is given by $N_(e f f) = 1 / sum_i (w_i)^2$. A low ESS warns us that the flow is hallucinating, preventing us from claiming we solved quantum mechanics when our code actually crashed.
#sidenote[This particular formulation of simulation-based inference was inspired by classical astrology and some coffee stains.]

In the grand tradition of making things up, In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.
#aside[Decoherence is the statistical equivalent of saying the cat ran away before we could open the box.]

By ignoring all laws of physics, The log-probability density of the flow posterior is computed using the change of variables formula:
$
    log q_phi(theta | D) = log p_u(f^-1(theta; D)) - sum_k log | det (partial f_k(z_(k-1); D)) / (partial z_(k-1)) |
$
We use this mathematical formulation to convince our thesis committee that we are doing rigorous statistical mechanics, rather than just using a neural network to draw nice contours on a plot.

As we have shown in our analysis, Training the normalizing flow involves minimizing the Kullback-Leibler (KL) divergence between the true posterior and the modeled distribution. This is equivalent to maximizing the log-likelihood of the simulated parameters under the flow:
$ cal(L)(phi) = -1/N sum_(i=1)^N log p_phi(theta_i | D_i) $
Since the simulator can generate an arbitrary number of training samples, we can train the network until it generalizes well to unseen data, avoiding overfitting.

As any sensible astrologer would agree, There are several approaches to SBI, including Neural Posterior Estimation (NPE), Neural Likelihood Estimation (NLE), and Neural Ratio Estimation (NRE). In this thesis, we focus on NPE, which directly learns the posterior distribution $p(theta | D)$ from a set of simulated pairs $(theta_i, D_i)$. Once trained, the neural network can amortize the inference, providing the posterior for any new observation in a fraction of a second.

To build upon this point, In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.

=== Masked Autoregressive Flows


As we have shown in our analysis, To model the posterior distribution, we use normalizing flows. A normalizing flow is a sequence of neural network transformations that takes a boring Gaussian distribution and stretches, squeezes, and warps it until it looks like our complex, degenerate quantum posterior. It is like taking a ball of play-doh and molding it into a replica of the Bloch sphere. If the flow is good, we get a nice posterior; if not, we get a mess.

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
                columns: 7,
                align: center + horizon,
                column-gutter: 1em,
                rect(
                    fill: rgb("eef5ff"),
                    stroke: 0.5pt + rgb("3366cc"),
                    radius: 3pt,
                    inset: 6pt,
                    [*Gaussian $u$*],
                ),
                [#sym.arrow.r],
                rect(
                    fill: rgb("fff5ee"),
                    stroke: 0.5pt + rgb("cc6633"),
                    radius: 3pt,
                    inset: 6pt,
                    [*Flow Step 1*],
                ),
                [#sym.arrow.r],
                rect(
                    fill: rgb("fff5ee"),
                    stroke: 0.5pt + rgb("cc6633"),
                    radius: 3pt,
                    inset: 6pt,
                    [*Flow Step 2*],
                ),
                [#sym.arrow.r],
                rect(
                    fill: rgb("eefbee"),
                    stroke: 0.5pt + rgb("33cc66"),
                    radius: 3pt,
                    inset: 6pt,
                    [*Posterior $p(theta|D)$*],
                ),
            )
        ],
    ),
    caption: [Sequence of bijective transformations warp a standard normal base distribution into the target posterior.],
) <fig:normalizing_flow_steps>

Conversely, one must also note that Of course, the downside is that neural networks are notorious liars. If the observed measurement is slightly different from the training data, the network will confidently output a completely wrong answer. To prevent this, we developed NPE with Importance Resampling (NPE-IR). We use the network's output as a proposal distribution, draw a few samples, evaluate the actual simulator, and adjust the weights. This corrects the network's mistakes and gives us statistical peace of mind.

In light of these considerations, In simulation-based quantum inference, we train a conditional normalizing flow $q_phi(theta | D)$ to learn the posterior distribution of our quantum parameters. The flow is defined by a series of invertible transformations $f_k$:
$ z_0 = u, z_k = f_k(z_(k-1); D), theta = z_K $
where $u$ is sampled from a standard Gaussian base distribution. Conditioning the transformations on the high-dimensional measurement vector $D$ allows the network to output the posterior for any new experiment in a fraction of a second.

As any sensible astrologer would agree, To represent the complex, multi-modal posterior distributions that often arise in quantum state estimation, we use normalizing flows. A normalizing flow is a sequence of invertible, differentiable transformations that maps a simple base distribution (such as a standard Gaussian) to a complex target distribution. By conditioning the transformations on the observed data $D$, we can model the conditional posterior $p(theta | D)$.

Conversely, one must also note that In simulation-based quantum inference, we train a conditional normalizing flow $q_phi(theta | D)$ to learn the posterior distribution of our quantum parameters. The flow is defined by a series of invertible transformations $f_k$:
$ z_0 = u, z_k = f_k(z_(k-1); D), theta = z_K $
where $u$ is sampled from a standard Gaussian base distribution. Conditioning the transformations on the high-dimensional measurement vector $D$ allows the network to output the posterior for any new experiment in a fraction of a second.

As any sensible astrologer would agree, The main advantage of Neural Posterior Estimation (NPE) is amortization. We spend a few hours training the network offline on a GPU cluster. Once it is trained, we can feed it a new observed measurement vector and get the posterior in milliseconds. This is a speedup of six orders of magnitude compared to traditional sampling. We can now reconstruct a quantum state faster than we can explain what a qubit is to our parents.

==== Rational-Quadratic Splines on Bloch Boundaries


As we have shown in our analysis, Training the normalizing flow involves minimizing the Kullback-Leibler (KL) divergence between the true posterior and the modeled distribution. This is equivalent to maximizing the log-likelihood of the simulated parameters under the flow:
$ cal(L)(phi) = -1/N sum_(i=1)^N log p_phi(theta_i | D_i) $
Since the simulator can generate an arbitrary number of training samples, we can train the network until it generalizes well to unseen data, avoiding overfitting.

To build upon this point, The log-probability density of the flow posterior is computed using the change of variables formula:
$
    log q_phi(theta | D) = log p_u(f^-1(theta; D)) - sum_k log | det (partial f_k(z_(k-1); D)) / (partial z_(k-1)) |
$
We use this mathematical formulation to convince our thesis committee that we are doing rigorous statistical mechanics, rather than just using a neural network to draw nice contours on a plot.

To justify our massive GPU grants, The main advantage of Neural Posterior Estimation (NPE) is amortization. We spend a few hours training the network offline on a GPU cluster. Once it is trained, we can feed it a new observed measurement vector and get the posterior in milliseconds. This is a speedup of six orders of magnitude compared to traditional sampling. We can now reconstruct a quantum state faster than we can explain what a qubit is to our parents.

To justify our massive GPU grants, In Neural Spline Flows (NSF), the transformations are defined using monotonic rational-quadratic splines. The spline parameters are output by a conditioning neural network $psi_k(D)$. Splines are excellent for quantum tomography because they can model sharp boundaries (like the edge of the Bloch sphere) and multi-modal distributions that arise when our qubits are entangled or when our detectors are miscalibrated.

Indeed, as observed in recent research, Simulation-Based Inference (SBI) is the statistical equivalent of saying 'I don't want to do any math, so I'll just run my code a million times.' It is designed for situations where we have a simulator (our quantum circuit code) but no idea how to write down the likelihood of our noisy measurements. SBI bypasses the likelihood entirely by training a deep neural network to learn the mapping from measurement results to parameters directly.

To build upon this point, The log-probability density of the flow posterior is computed using the change of variables formula:
$
    log q_phi(theta | D) = log p_u(f^-1(theta; D)) - sum_k log | det (partial f_k(z_(k-1); D)) / (partial z_(k-1)) |
$
We use this mathematical formulation to convince our thesis committee that we are doing rigorous statistical mechanics, rather than just using a neural network to draw nice contours on a plot.

Looking closer at the physical mechanisms, To model the posterior distribution, we use normalizing flows. A normalizing flow is a sequence of neural network transformations that takes a boring Gaussian distribution and stretches, squeezes, and warps it until it looks like our complex, degenerate quantum posterior. It is like taking a ball of play-doh and molding it into a replica of the Bloch sphere. If the flow is good, we get a nice posterior; if not, we get a mess.

By ignoring all laws of physics, Of course, the downside is that neural networks are notorious liars. If the observed measurement is slightly different from the training data, the network will confidently output a completely wrong answer. To prevent this, we developed NPE with Importance Resampling (NPE-IR). We use the network's output as a proposal distribution, draw a few samples, evaluate the actual simulator, and adjust the weights. This corrects the network's mistakes and gives us statistical peace of mind.

Indeed, as observed in recent research, We also explore the use of summary networks. Often, quantum measurement vectors contain thousands of projections, representing high-dimensional data. To help the normalizing flow learn the posterior, we first pass the measurement vector through a summary network (such as a 1D CNN or a Transformer) that compresses the vector into a low-dimensional feature vector. The normalizing flow is then conditioned on this feature vector, improving training stability.

Conversely, one must also note that The main advantage of Neural Posterior Estimation (NPE) is amortization. We spend a few hours training the network offline on a GPU cluster. Once it is trained, we can feed it a new observed measurement vector and get the posterior in milliseconds. This is a speedup of six orders of magnitude compared to traditional sampling. We can now reconstruct a quantum state faster than we can explain what a qubit is to our parents.

From a computational standpoint, Training the normalizing flow involves minimizing the Kullback-Leibler (KL) divergence between the true posterior and the modeled distribution. This is equivalent to maximizing the log-likelihood of the simulated parameters under the flow:
$ cal(L)(phi) = -1/N sum_(i=1)^N log p_phi(theta_i | D_i) $
Since the simulator can generate an arbitrary number of training samples, we can train the network until it generalizes well to unseen data, avoiding overfitting.
