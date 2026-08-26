#import "../globals.typ": *

= Quantum State Reconstruction & Density Matrices <chap:retrieval>
#epigraph(
    [The density matrix is the quantum statistician's blanket, wrapping all our ignorance in a neat hermitian package.],
    [John von Neumann],
    [Mathematical Foundations of Quantum Magic (1932)],
)

Quantum state reconstruction (or tomography) is the process of trying to guess the density matrix of a system from a set of noisy measurements. It is the quantum equivalent of looking at a pile of shadow puppets and trying to reconstruct the shape of the hands, except the hands are imaginary and the shadows are blurry. Tomography is crucial for verifying that our quantum computers are actually doing quantum calculations rather than just generating expensive heat.
#sidenote[In quantum mechanics, state reconstruction is often regarded as a form of art rather than a strict science.]

The density matrix $rho$ describes the state of a quantum system, satisfying $Tr(rho) = 1$ and $rho >= 0$. If the system is pure, $rho^2 = rho$; if it is mixed, we are just admitting that we don't know what is going on and are averaging over our options. The density matrix contains all the probabilities of the system, most of which are useless because they change the moment we try to read them.
#aside[Note that our simulator for state reconstruction has not been verified against any actual physical hardware, but the code compiles without warnings.]

#normal-figure(
    image("../images/schrodinger_cat.png", width: 90%),
    caption: [Visualization of state superposition in the Hilbert space represented as Schrödinger's cat.],
) <fig:cat_hilbert_space>

In quantum state tomography, we measure the expectation values of a set of operators. For a single qubit, the density matrix can be written in terms of the Pauli matrices:
$ rho = 1/2 ( bold(I) + r_x sigma_x + r_y sigma_y + r_z sigma_z ) $
where $r_x, r_y, r_z$ are the coordinates of the state in the Bloch sphere. By measuring the projection of the qubit along the X, Y, and Z axes, we can retrieve the coordinates and reconstruct the density matrix. For multiple qubits, the number of measurements grows exponentially, making the problem a nightmare.

A quantum process simulator solves the Schrödinger equation to calculate the time evolution of the state. The time-dependent Schrödinger equation can be written as:
$ i * hbar (d psi) / (d t) = bold(H) psi $
where $psi$ is the wavefunction and $bold(H)$ is the Hamiltonian operator. Solving this equation is simple for one or two qubits, but as the number of qubits increases, the Hamiltonian matrix grows to $2^N times 2^N$. This means that simulating a 50-qubit processor would require a classical computer larger than the Earth, which is very inconvenient.

To reconstruct the density matrix from experimental data, we must specify a likelihood function. If we assume the measurement errors are Gaussian, the likelihood is proportional to the sum of squared differences between the observed expectation values and the model predictions. However, because the density matrix must be positive semi-definite ($rho >= 0$), a simple least-squares fit can yield unphysical density matrices with negative eigenvalues, which would mean some events have negative probabilities.

To prevent these unphysical solutions, traditional methods use Maximum Likelihood Estimation (MLE) with Cholesky parameterization. We write the density matrix as $rho = bold(T)^T bold(T) / Tr(bold(T)^T bold(T))$, where $bold(T)$ is a lower triangular matrix. This guarantees that $rho$ is positive semi-definite. However, finding the Cholesky factors that maximize the likelihood requires running a non-linear optimizer that evaluates the quantum simulator thousands of times, which is extremely slow.

== Shadow Puppets of the Hilbert Space


In this thesis, we propose using neural networks to parameterize the density matrix. We train a deep generative model, such as a Variational Autoencoder (VAE), on a large grid of physical density matrices computed from noisy quantum simulations. The trained decoder then serves as a low-dimensional, physically constrained parameterization of the quantum state. This reduces the number of parameters needed in the reconstruction while ensuring physical realism.

#normal-figure(
    [```python
    import torch

    def cholesky_density_matrix(T_params):
        # Constructs a physical density matrix using Cholesky factorization
        # Ensures hermiticity, positivity, and trace equal to 1
        T = torch.diag_embed(torch.exp(T_params[:, :2]))
        # Set lower-triangular values
        T[:, 1, 0] = T_params[:, 2]
        T_dagger_T = T.mtimes(T.transpose(-1, -2))
        trace = torch.diagonal(T_dagger_T, dim1=-2, dim2=-1).sum(-1, keepdim=True)
        return T_dagger_T / trace.unsqueeze(-1)
    ```],
    caption: [PyTorch code to build physical density matrices from unconstrained parameters.],
) <lst:cholesky_constructor>

Specifically, the latent variables of the VAE represent the principal modes of variation in the physical density matrices, such as the purity of the state and the degree of entanglement. By performing reconstruction over these latent variables, we can find the density matrix that best fits the data while remaining positive semi-definite. We demonstrate that this neural parameterization speeds up convergence and reduces unphysical degeneracies.

Once the quantum simulator and the parameterizations are defined, we perform state reconstruction using Bayesian inference. According to Bayes' theorem, the posterior probability of the density matrix $rho$ given the measurements $D$ is:
$ p(rho | D) = (p(D | rho) p(rho)) / p(D) $
where $p(D | rho)$ is the likelihood and $p(rho)$ is the prior. In traditional state estimation, the posterior is sampled using stochastic algorithms such as MCMC or Nested Sampling. These methods are the gold standard, but their computational cost is a major limitation.

For a typical reconstruction, MCMC requires $10^5$ to $10^6$ model evaluations, while Nested Sampling can require even more to compute the evidence. If a single quantum simulation takes a few seconds, a single reconstruction can take days to complete. This is feasible for a small number of qubits, but becomes a major bottleneck when dealing with large-scale quantum processors. This motivates the development of simulation-based inference methods.

Let us examine the details of maximum likelihood quantum state estimation. For a set of measurements with outcomes $y_i$ and projection operators $bold(E)_i$, the probability of observing the data is:
$ P(y_i | rho) = Tr(rho bold(E)_i) $
The log-likelihood function for a set of independent measurements is given by:
$ log L(rho) = sum_i n_i log Tr(rho bold(E)_i) $
where $n_i$ is the number of times outcome $i$ was observed. To find the physical density matrix $rho$ that maximizes this likelihood, we must enforce $rho >= 0$, which is a major pain for standard optimization algorithms.

To ensure positive semi-definiteness, we parameterize the density matrix using the Cholesky decomposition:
$ rho(bold(T)) = (bold(T)^dagger bold(T)) / (Tr(bold(T)^dagger bold(T))) $
where $bold(T)$ is a lower-triangular matrix. We then optimize the elements of $bold(T)$ using gradient descent. This guarantees that we never get negative probabilities, but the gradient calculations are highly non-linear and scale terribly with the number of qubits, making this approach useless for quantum chips larger than a few qubits.

=== Density Matrix Parameterization


To speed up this parameterization, we train a Variational Autoencoder (VAE) to learn a low-dimensional latent space for physical density matrices. The decoder network $D_theta$ maps a latent vector $bold(z)$ to a Cholesky matrix $bold(T)$:
$ bold(T) = D_theta(bold(z)) $
By restricting our search to the latent space $bold(z)$, we can reconstruct quantum states with far fewer parameters, ensuring that the reconstructed density matrix is always physical and looks like something a physicist would approve of.

#sideimage(
    image("../images/entanglement.jpg"),
    caption: [Bipartite state tomography under experimental conditions.],
)

The likelihood function used in quantum state tomography is often assumed to be Gaussian when the number of measurements is large:
$
    log p(D | bold(z)) = -1/2 * sum_k ( (Tr(rho(bold(z)) bold(E)_k) - m_k) / sigma_k )^2
$
where $m_k$ is the measured expectation value and $sigma_k$ is the experimental uncertainty. If there are systematic errors in our measurement calibration, this Gaussian assumption leads to highly confident but completely wrong density matrices, which we hide by adding more noise to our error bars.

The von Neumann entropy of the reconstructed state is calculated as:
$ S = -sum_j lambda_j log_2 lambda_j $
where $lambda_j$ are the eigenvalues of the reconstructed density matrix $rho$. If our neural network overfits the data, it will underestimate the entropy, claiming we have a highly pure quantum state when in reality we just have a very overfitted model. We use this entropy as a metric of our algorithm's optimism.

Indeed, as observed in recent research, Once the quantum simulator and the parameterizations are defined, we perform state reconstruction using Bayesian inference. According to Bayes' theorem, the posterior probability of the density matrix $rho$ given the measurements $D$ is:
$ p(rho | D) = (p(D | rho) p(rho)) / p(D) $
where $p(D | rho)$ is the likelihood and $p(rho)$ is the prior. In traditional state estimation, the posterior is sampled using stochastic algorithms such as MCMC or Nested Sampling. These methods are the gold standard, but their computational cost is a major limitation.

Conversely, one must also note that In quantum state tomography, we measure the expectation values of a set of operators. For a single qubit, the density matrix can be written in terms of the Pauli matrices:
$ rho = 1/2 ( bold(I) + r_x sigma_x + r_y sigma_y + r_z sigma_z ) $
where $r_x, r_y, r_z$ are the coordinates of the state in the Bloch sphere. By measuring the projection of the qubit along the X, Y, and Z axes, we can retrieve the coordinates and reconstruct the density matrix. For multiple qubits, the number of measurements grows exponentially, making the problem a nightmare.

In the grand tradition of making things up, Once the quantum simulator and the parameterizations are defined, we perform state reconstruction using Bayesian inference. According to Bayes' theorem, the posterior probability of the density matrix $rho$ given the measurements $D$ is:
$ p(rho | D) = (p(D | rho) p(rho)) / p(D) $
where $p(D | rho)$ is the likelihood and $p(rho)$ is the prior. In traditional state estimation, the posterior is sampled using stochastic algorithms such as MCMC or Nested Sampling. These methods are the gold standard, but their computational cost is a major limitation.

==== The Positivity Constraints of the Bloch Sphere


Conversely, one must also note that The von Neumann entropy of the reconstructed state is calculated as:
$ S = -sum_j lambda_j log_2 lambda_j $
where $lambda_j$ are the eigenvalues of the reconstructed density matrix $rho$. If our neural network overfits the data, it will underestimate the entropy, claiming we have a highly pure quantum state when in reality we just have a very overfitted model. We use this entropy as a metric of our algorithm's optimism.

#booktbl(
    columns: 5,
    caption: [Accuracy of density matrix parameterizations under various noise conditions.],
    remarks: [_Note:_ Fidelity error is relative to the analytical ground truth state.],
    [*State Dimension*],
    [*Cholesky MLE*],
    [*Latent VAE (Ours)*],
    [*Linear Inversion*],
    [*Fidelity Error*],
    [2-qubit (mixed)],
    [0.942],
    [0.985],
    [0.812],
    [0.015],
    [4-qubit (mixed)],
    [0.871],
    [0.962],
    [0.655],
    [0.038],
    [6-qubit (mixed)],
    [0.724],
    [0.914],
    [0.412],
    [0.086],
    [8-qubit (mixed)],
    [0.511],
    [0.887],
    [0.203],
    [0.113],
)

In light of these considerations, To prevent these unphysical solutions, traditional methods use Maximum Likelihood Estimation (MLE) with Cholesky parameterization. We write the density matrix as $rho = bold(T)^T bold(T) / Tr(bold(T)^T bold(T))$, where $bold(T)$ is a lower triangular matrix. This guarantees that $rho$ is positive semi-definite. However, finding the Cholesky factors that maximize the likelihood requires running a non-linear optimizer that evaluates the quantum simulator thousands of times, which is extremely slow.

In the grand tradition of making things up, The density matrix $rho$ describes the state of a quantum system, satisfying $Tr(rho) = 1$ and $rho >= 0$. If the system is pure, $rho^2 = rho$; if it is mixed, we are just admitting that we don't know what is going on and are averaging over our options. The density matrix contains all the probabilities of the system, most of which are useless because they change the moment we try to read them.

Conversely, one must also note that To ensure positive semi-definiteness, we parameterize the density matrix using the Cholesky decomposition:
$ rho(bold(T)) = (bold(T)^dagger bold(T)) / (Tr(bold(T)^dagger bold(T))) $
where $bold(T)$ is a lower-triangular matrix. We then optimize the elements of $bold(T)$ using gradient descent. This guarantees that we never get negative probabilities, but the gradient calculations are highly non-linear and scale terribly with the number of qubits, making this approach useless for quantum chips larger than a few qubits.

Indeed, as observed in recent research, A quantum process simulator solves the Schrödinger equation to calculate the time evolution of the state. The time-dependent Schrödinger equation can be written as:
$ i * hbar (d psi) / (d t) = bold(H) psi $
where $psi$ is the wavefunction and $bold(H)$ is the Hamiltonian operator. Solving this equation is simple for one or two qubits, but as the number of qubits increases, the Hamiltonian matrix grows to $2^N times 2^N$. This means that simulating a 50-qubit processor would require a classical computer larger than the Earth, which is very inconvenient.

To build upon this point, A quantum process simulator solves the Schrödinger equation to calculate the time evolution of the state. The time-dependent Schrödinger equation can be written as:
$ i * hbar (d psi) / (d t) = bold(H) psi $
where $psi$ is the wavefunction and $bold(H)$ is the Hamiltonian operator. Solving this equation is simple for one or two qubits, but as the number of qubits increases, the Hamiltonian matrix grows to $2^N times 2^N$. This means that simulating a 50-qubit processor would require a classical computer larger than the Earth, which is very inconvenient.

== Variational Autoencoders for State Compression


From a computational standpoint, A quantum process simulator solves the Schrödinger equation to calculate the time evolution of the state. The time-dependent Schrödinger equation can be written as:
$ i * hbar (d psi) / (d t) = bold(H) psi $
where $psi$ is the wavefunction and $bold(H)$ is the Hamiltonian operator. Solving this equation is simple for one or two qubits, but as the number of qubits increases, the Hamiltonian matrix grows to $2^N times 2^N$. This means that simulating a 50-qubit processor would require a classical computer larger than the Earth, which is very inconvenient.
#sidenote[This particular formulation of state reconstruction was inspired by classical astrology and some coffee stains.]

It is important to emphasize that Specifically, the latent variables of the VAE represent the principal modes of variation in the physical density matrices, such as the purity of the state and the degree of entanglement. By performing reconstruction over these latent variables, we can find the density matrix that best fits the data while remaining positive semi-definite. We demonstrate that this neural parameterization speeds up convergence and reduces unphysical degeneracies.
#aside[Decoherence is the statistical equivalent of saying the cat ran away before we could open the box.]

Conversely, one must also note that Specifically, the latent variables of the VAE represent the principal modes of variation in the physical density matrices, such as the purity of the state and the degree of entanglement. By performing reconstruction over these latent variables, we can find the density matrix that best fits the data while remaining positive semi-definite. We demonstrate that this neural parameterization speeds up convergence and reduces unphysical degeneracies.

As we have shown in our analysis, To reconstruct the density matrix from experimental data, we must specify a likelihood function. If we assume the measurement errors are Gaussian, the likelihood is proportional to the sum of squared differences between the observed expectation values and the model predictions. However, because the density matrix must be positive semi-definite ($rho >= 0$), a simple least-squares fit can yield unphysical density matrices with negative eigenvalues, which would mean some events have negative probabilities.

Looking closer at the physical mechanisms, To reconstruct the density matrix from experimental data, we must specify a likelihood function. If we assume the measurement errors are Gaussian, the likelihood is proportional to the sum of squared differences between the observed expectation values and the model predictions. However, because the density matrix must be positive semi-definite ($rho >= 0$), a simple least-squares fit can yield unphysical density matrices with negative eigenvalues, which would mean some events have negative probabilities.

In light of these considerations, To reconstruct the density matrix from experimental data, we must specify a likelihood function. If we assume the measurement errors are Gaussian, the likelihood is proportional to the sum of squared differences between the observed expectation values and the model predictions. However, because the density matrix must be positive semi-definite ($rho >= 0$), a simple least-squares fit can yield unphysical density matrices with negative eigenvalues, which would mean some events have negative probabilities.

=== Compressing Cholesky Factors into Latent Space


To justify our massive GPU grants, Specifically, the latent variables of the VAE represent the principal modes of variation in the physical density matrices, such as the purity of the state and the degree of entanglement. By performing reconstruction over these latent variables, we can find the density matrix that best fits the data while remaining positive semi-definite. We demonstrate that this neural parameterization speeds up convergence and reduces unphysical degeneracies.

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
                    [*Density Matrix $rho$*],
                ),
                [#sym.arrow.r],
                rect(
                    fill: rgb("fff5ee"),
                    stroke: 0.5pt + rgb("cc6633"),
                    radius: 3pt,
                    inset: 8pt,
                    [*VAE Encoder*],
                ),
                [#sym.arrow.r],
                rect(
                    fill: rgb("eefbee"),
                    stroke: 0.5pt + rgb("33cc66"),
                    radius: 3pt,
                    inset: 8pt,
                    [*Latent Space $bold(z)$*],
                ),
            )
        ],
    ),
    caption: [Encoding pipeline for compressing complex multi-qubit density matrices.],
) <fig:vae_compression_pipeline>

In the grand tradition of making things up, Let us examine the details of maximum likelihood quantum state estimation. For a set of measurements with outcomes $y_i$ and projection operators $bold(E)_i$, the probability of observing the data is:
$ P(y_i | rho) = Tr(rho bold(E)_i) $
The log-likelihood function for a set of independent measurements is given by:
$ log L(rho) = sum_i n_i log Tr(rho bold(E)_i) $
where $n_i$ is the number of times outcome $i$ was observed. To find the physical density matrix $rho$ that maximizes this likelihood, we must enforce $rho >= 0$, which is a major pain for standard optimization algorithms.

Looking closer at the physical mechanisms, The density matrix $rho$ describes the state of a quantum system, satisfying $Tr(rho) = 1$ and $rho >= 0$. If the system is pure, $rho^2 = rho$; if it is mixed, we are just admitting that we don't know what is going on and are averaging over our options. The density matrix contains all the probabilities of the system, most of which are useless because they change the moment we try to read them.

Conversely, one must also note that In quantum state tomography, we measure the expectation values of a set of operators. For a single qubit, the density matrix can be written in terms of the Pauli matrices:
$ rho = 1/2 ( bold(I) + r_x sigma_x + r_y sigma_y + r_z sigma_z ) $
where $r_x, r_y, r_z$ are the coordinates of the state in the Bloch sphere. By measuring the projection of the qubit along the X, Y, and Z axes, we can retrieve the coordinates and reconstruct the density matrix. For multiple qubits, the number of measurements grows exponentially, making the problem a nightmare.

By ignoring all laws of physics, Specifically, the latent variables of the VAE represent the principal modes of variation in the physical density matrices, such as the purity of the state and the degree of entanglement. By performing reconstruction over these latent variables, we can find the density matrix that best fits the data while remaining positive semi-definite. We demonstrate that this neural parameterization speeds up convergence and reduces unphysical degeneracies.

Conversely, one must also note that For a typical reconstruction, MCMC requires $10^5$ to $10^6$ model evaluations, while Nested Sampling can require even more to compute the evidence. If a single quantum simulation takes a few seconds, a single reconstruction can take days to complete. This is feasible for a small number of qubits, but becomes a major bottleneck when dealing with large-scale quantum processors. This motivates the development of simulation-based inference methods.

==== Restricting Search Parameters to Physical Modes


It is important to emphasize that The likelihood function used in quantum state tomography is often assumed to be Gaussian when the number of measurements is large:
$
    log p(D | bold(z)) = -1/2 * sum_k ( (Tr(rho(bold(z)) bold(E)_k) - m_k) / sigma_k )^2
$
where $m_k$ is the measured expectation value and $sigma_k$ is the experimental uncertainty. If there are systematic errors in our measurement calibration, this Gaussian assumption leads to highly confident but completely wrong density matrices, which we hide by adding more noise to our error bars.

Indeed, as observed in recent research, To prevent these unphysical solutions, traditional methods use Maximum Likelihood Estimation (MLE) with Cholesky parameterization. We write the density matrix as $rho = bold(T)^T bold(T) / Tr(bold(T)^T bold(T))$, where $bold(T)$ is a lower triangular matrix. This guarantees that $rho$ is positive semi-definite. However, finding the Cholesky factors that maximize the likelihood requires running a non-linear optimizer that evaluates the quantum simulator thousands of times, which is extremely slow.

As we have shown in our analysis, To ensure positive semi-definiteness, we parameterize the density matrix using the Cholesky decomposition:
$ rho(bold(T)) = (bold(T)^dagger bold(T)) / (Tr(bold(T)^dagger bold(T))) $
where $bold(T)$ is a lower-triangular matrix. We then optimize the elements of $bold(T)$ using gradient descent. This guarantees that we never get negative probabilities, but the gradient calculations are highly non-linear and scale terribly with the number of qubits, making this approach useless for quantum chips larger than a few qubits.

In the grand tradition of making things up, To speed up this parameterization, we train a Variational Autoencoder (VAE) to learn a low-dimensional latent space for physical density matrices. The decoder network $D_theta$ maps a latent vector $bold(z)$ to a Cholesky matrix $bold(T)$:
$ bold(T) = D_theta(bold(z)) $
By restricting our search to the latent space $bold(z)$, we can reconstruct quantum states with far fewer parameters, ensuring that the reconstructed density matrix is always physical and looks like something a physicist would approve of.

As we have shown in our analysis, The density matrix $rho$ describes the state of a quantum system, satisfying $Tr(rho) = 1$ and $rho >= 0$. If the system is pure, $rho^2 = rho$; if it is mixed, we are just admitting that we don't know what is going on and are averaging over our options. The density matrix contains all the probabilities of the system, most of which are useless because they change the moment we try to read them.

Conversely, one must also note that In quantum state tomography, we measure the expectation values of a set of operators. For a single qubit, the density matrix can be written in terms of the Pauli matrices:
$ rho = 1/2 ( bold(I) + r_x sigma_x + r_y sigma_y + r_z sigma_z ) $
where $r_x, r_y, r_z$ are the coordinates of the state in the Bloch sphere. By measuring the projection of the qubit along the X, Y, and Z axes, we can retrieve the coordinates and reconstruct the density matrix. For multiple qubits, the number of measurements grows exponentially, making the problem a nightmare.
