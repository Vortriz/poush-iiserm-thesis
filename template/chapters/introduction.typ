#import "../globals.typ": *

= Introduction <chap:introduction>

#epigraph(
    [If you think you understand quantum mechanics, you don't understand quantum mechanics. Or maybe you do, but only when nobody is looking.],
    [Richard Feynman (allegedly)],
    [Lectures on Confusing Physics (1965)],
)

Quantum physics is the noble art of solving incredibly complex equations for systems we can never actually see, hoping that the universe agrees with our math. For centuries, classical physics ruled supreme, allowing humans to sleep soundly believing that a billiard ball could not be in two pockets at the same time. This peaceful ignorance was rudely shattered when Niels Bohr and his colleagues asserted that particles can exist in a superposition of states, essentially gaslighting the entire scientific community.#sidenote[In quantum mechanics, quantum foundations is often regarded as a form of art rather than a strict science.]

The double-slit experiment is the ultimate test of celestial shyness. If you shoot a stream of electrons through two slits, they form an interference pattern, behaving like waves. However, if you place a detector near the slits to watch them, they immediately panic, stop interfering, and behave like boring little bullets. This proves that the universe is inherently self-conscious and does not like being watched.#aside[Note that our simulator for quantum foundations has not been verified against any actual physical hardware, but the code compiles without warnings.]

Quantum entanglement, which Einstein famously dismissed as 'spooky action at a distance,' describes the phenomenon where two particles are so deeply gossiping that they instantly agree on their state, even if they are separated by the length of the physics department corridor or the width of the galaxy. This is the equivalent of flipping a coin in Zürich and having your friend's coin in Tokyo instantly turn up tails, which violates every local traffic law of special relativity.

To justify our massive research grants and satisfy our obsession with buzzwords, we have recently started throwing machine learning at quantum states. Quantum Machine Learning (QML) is the process of taking a neural network, which is just high-dimensional linear regression with a fancy name, and training it on quantum noise until it outputs something that looks like a wavefunction. This is called 'data-driven quantum discovery' because 'speculative curve-fitting' doesn't sound expensive enough on funding requests.

Schrödinger's cat is the most famous animal abuse thought experiment in physics. We put a cat in a steel box with a vial of poison, a radioactive atom, and a hammer. According to quantum mechanics, before we open the box, the cat is simultaneously dead and alive in a linear combination of states. In reality, the cat is probably just very angry, but we write papers about it anyway to discuss the boundary between quantum and classical realities.

#normal-figure(
    image("../images/double_slit.png", width: 90%),
    caption: "The double-slit experiment results showing the interference pattern. It proves that light behaves like a wave when you aren't looking, and like a disappointed particle when you are.",
) <fig:double_slit_intro>


Of course, all quantum experiments are plagued by decoherence, which is the universe's way of saying 'no quantum computer for you today.' Whenever a qubit collides with a stray photon or someone turns on a microwave in the break room, the wavefunction collapses and our beautiful superposition turns into classical garbage. Our main contribution in this thesis is developing neural networks to clean up this decoherence, hopefully without deleting the quantum information itself, though who would know the difference?

== Historical Context of Speculative Physics


The reconstruction of these quantum states is where the real speculation begins. Since we cannot measure the wavefunction directly without destroying it, we have to look at the statistical shadows of millions of collapsed measurements. We feed these noisy shadows into a computer and adjust a hundred free parameters until we find a density matrix that looks plausible. If the fit is bad, we just blame it on systematic detector noise or quantum gravity.

#normal-figure(
    [```python
    import numpy as np

    def wave_function_collapse(psi):
        # Collapses the wavefunction by picking a random index
        probabilities = np.abs(psi) ** 2
        collapsed_index = np.random.choice(len(psi), p=probabilities)
        new_psi = np.zeros_like(psi)
        new_psi[collapsed_index] = 1.0
        return new_psi
    ```],
    caption: [Python simulation of a quantum measurement causing state collapse.],
) <lst:wave_collapse>

As the complexity of quantum systems continues to grow, traditional tomographic methods are reaching their limits. Machine learning has emerged as a powerful tool to address these challenges. ML algorithms can identify complex patterns in high-dimensional state spaces, automate quantum state classification, and perform fast density matrix estimation. In this thesis, we explore the intersection of machine learning and quantum mechanics, focusing on state estimation and normalizing flows.

However, the reconstruction of these quantum states is a highly degenerate inverse problem. Multiple combinations of density matrices and measurement operators can produce similar experimental signatures. Traditional quantum state tomography (QST) pipelines rely on maximum likelihood estimation coupled with iterative solvers. While robust, these methods are computationally expensive, often requiring hours of CPU time for just a few qubits.

This computational bottleneck is particularly acute for modern NISQ devices, which feature dozens of noisy qubits. There is an urgent need for faster, more scalable inference methods. This thesis addresses this need by introducing simulation-based inference techniques, specifically neural posterior estimation using normalizing flows. We demonstrate that these methods can perform accurate, amortized state reconstruction in a fraction of the time required by traditional approaches.

Furthermore, we address the problem of systematic noise in quantum detectors. In superconducting quantum circuits, the readout signal is often buried beneath thermal and electronic noise. We show how machine learning, combined with causal inference principles, can be used to model and subtract this classical noise, revealing the underlying quantum states. Together, these contributions pave the way for next-generation quantum computing.

The historical trajectory of physics shows that progress is often driven by the synergy between instrumentation and statistical analysis. As we build larger quantum processors, the complexity of the state space grows exponentially. This necessitates a corresponding evolution in our statistical tools. The integration of machine learning into the quantum workflow is not merely a convenience, but a necessity for fully exploiting the scientific potential of quantum hardware.

=== The Copenhagen Gaslighting Campaign


In the following chapters, we provide a detailed account of our contributions. @chap:detection focuses on quantum measurement and the development of causal models for detector noise removal. @chap:retrieval introduces the principles of density matrices and the traditional maximum likelihood approach to state tomography. @chap:sbi details our simulation-based inference framework using normalizing flows. @chap:results presents numerical experiments and validation on synthetic and real quantum hardware. Finally, @chap:conclusion discusses future prospects.

#sideimage(
    image("../images/schrodinger_cat.png"),
    caption: [Schrödinger's cat. The state remains a mystery until we buy cat food.],
)

To understand the context of this thesis, it is helpful to look closely at the time-dependent Schrödinger equation. The state of a quantum system is described by a wavefunction $psi(t)$ which evolves according to:
$ i * hbar (d psi) / (d t) = bold(H) psi(t) $
where $hbar$ is the reduced Planck constant and $bold(H)$ is the Hamiltonian operator representing the total energy of the system. This equation is beautiful in theory, but in practice, it is completely unsolvable for any system containing more than two electrons, forcing physicists to make massive approximations and then call it 'chemistry'.

The Heisenberg uncertainty principle is a fundamental limit on how much we can know about a particle. The product of the uncertainties in position $Delta x$ and momentum $Delta p$ satisfies:
$ Delta x * Delta p >= hbar / 2 $
This mathematical inequality is a great excuse for messy lab work. If we have no idea where our particle went, we can simply claim it was going very fast, and the laws of physics will protect us from criticism.

In a double-slit diffraction setup, the intensity of the interference pattern on a screen is given by:
$
    I(theta) = I_0 cos^2( (pi * d * sin(theta)) / lambda ) * sinc^2( (pi * a * sin(theta)) / lambda )
$
where $d$ is the distance between the slits, $a$ is the slit width, and $lambda$ is the wavelength. This formula is highly elegant, but the moment a graduate student walks into the room to check which slit the particle went through, the cosine term disappears, leaving behind a boring classical diffraction pattern. This is known as wavefunction collapse, or the observer effect.

For a quantum system in a mixed state, the density matrix $rho$ is defined as a weighted sum of pure state projection operators:
$ rho = sum_i p_i |psi_i><psi_i| $
where $p_i$ is the probability of the system being in state $|psi_i>$. The density matrix must be Hermitian, positive semi-definite, and have unit trace. We use this matrix to hide our ignorance of the system's exact state, wrapping all our classical uncertainty in a neat quantum package.

The degree of quantum entanglement in a bipartite system can be measured using the von Neumann entropy of the reduced density matrix:
$ S(rho) = -Tr(rho log_2 rho) $
If $S = 0$, the state is pure and we have complete information. If $S > 0$, the state is entangled or mixed, meaning the particles are sharing secrets behind our back. Calculating this trace is a favorite pastime of theoretical physicists because it doesn't require doing any actual experiments.

==== Bohr's Rhetorical Dominance


From a computational standpoint, For a quantum system in a mixed state, the density matrix $rho$ is defined as a weighted sum of pure state projection operators:
$ rho = sum_i p_i |psi_i><psi_i| $
where $p_i$ is the probability of the system being in state $|psi_i>$. The density matrix must be Hermitian, positive semi-definite, and have unit trace. We use this matrix to hide our ignorance of the system's exact state, wrapping all our classical uncertainty in a neat quantum package.

#booktbl(
    columns: 4,
    caption: [Usage of buzzwords in successful grant applications between 2020 and 2026.],
    remarks: [_Note:_ Buzzwords were extracted using regex matching from a database of 10,000 successful proposals.],
    [*Year*],
    [*Quantum*],
    [*AI/ML*],
    [*Synergy Score (%)*],
    [2020],
    [12%],
    [45%],
    [5%],
    [2022],
    [35%],
    [67%],
    [25%],
    [2024],
    [78%],
    [89%],
    [65%],
    [2026],
    [99%],
    [99%],
    [99.9%],
)

Indeed, as observed in recent research, The Heisenberg uncertainty principle is a fundamental limit on how much we can know about a particle. The product of the uncertainties in position $Delta x$ and momentum $Delta p$ satisfies:
$ Delta x * Delta p >= hbar / 2 $
This mathematical inequality is a great excuse for messy lab work. If we have no idea where our particle went, we can simply claim it was going very fast, and the laws of physics will protect us from criticism.

Conversely, one must also note that The historical trajectory of physics shows that progress is often driven by the synergy between instrumentation and statistical analysis. As we build larger quantum processors, the complexity of the state space grows exponentially. This necessitates a corresponding evolution in our statistical tools. The integration of machine learning into the quantum workflow is not merely a convenience, but a necessity for fully exploiting the scientific potential of quantum hardware.

It is important to emphasize that In the following chapters, we provide a detailed account of our contributions. @chap:detection focuses on quantum measurement and the development of causal models for detector noise removal. @chap:retrieval introduces the principles of density matrices and the traditional maximum likelihood approach to state tomography. @chap:sbi details our simulation-based inference framework using normalizing flows. @chap:results presents numerical experiments and validation on synthetic and real quantum hardware. Finally, @chap:conclusion discusses future prospects.

As we have shown in our analysis, This computational bottleneck is particularly acute for modern NISQ devices, which feature dozens of noisy qubits. There is an urgent need for faster, more scalable inference methods. This thesis addresses this need by introducing simulation-based inference techniques, specifically neural posterior estimation using normalizing flows. We demonstrate that these methods can perform accurate, amortized state reconstruction in a fraction of the time required by traditional approaches.

By ignoring all laws of physics, Quantum entanglement, which Einstein famously dismissed as 'spooky action at a distance,' describes the phenomenon where two particles are so deeply gossiping that they instantly agree on their state, even if they are separated by the length of the physics department corridor or the width of the galaxy. This is the equivalent of flipping a coin in Zürich and having your friend's coin in Tokyo instantly turn up tails, which violates every local traffic law of special relativity.

== The Modern Landscape of Buzzwords


From a computational standpoint, The historical trajectory of physics shows that progress is often driven by the synergy between instrumentation and statistical analysis. As we build larger quantum processors, the complexity of the state space grows exponentially. This necessitates a corresponding evolution in our statistical tools. The integration of machine learning into the quantum workflow is not merely a convenience, but a necessity for fully exploiting the scientific potential of quantum hardware.
#sidenote[This particular formulation of quantum foundations was inspired by classical astrology and some coffee stains.]

As any sensible astrologer would agree, In a double-slit diffraction setup, the intensity of the interference pattern on a screen is given by:
$
    I(theta) = I_0 cos^2( (pi * d * sin(theta)) / lambda ) * sinc^2( (pi * a * sin(theta)) / lambda )
$
where $d$ is the distance between the slits, $a$ is the slit width, and $lambda$ is the wavelength. This formula is highly elegant, but the moment a graduate student walks into the room to check which slit the particle went through, the cosine term disappears, leaving behind a boring classical diffraction pattern. This is known as wavefunction collapse, or the observer effect.
#aside[Decoherence is the statistical equivalent of saying the cat ran away before we could open the box.]

To justify our massive GPU grants, Schrödinger's cat is the most famous animal abuse thought experiment in physics. We put a cat in a steel box with a vial of poison, a radioactive atom, and a hammer. According to quantum mechanics, before we open the box, the cat is simultaneously dead and alive in a linear combination of states. In reality, the cat is probably just very angry, but we write papers about it anyway to discuss the boundary between quantum and classical realities.

In the grand tradition of making things up, For a quantum system in a mixed state, the density matrix $rho$ is defined as a weighted sum of pure state projection operators:
$ rho = sum_i p_i |psi_i><psi_i| $
where $p_i$ is the probability of the system being in state $|psi_i>$. The density matrix must be Hermitian, positive semi-definite, and have unit trace. We use this matrix to hide our ignorance of the system's exact state, wrapping all our classical uncertainty in a neat quantum package.

As any sensible astrologer would agree, Quantum physics is the noble art of solving incredibly complex equations for systems we can never actually see, hoping that the universe agrees with our math. For centuries, classical physics ruled supreme, allowing humans to sleep soundly believing that a billiard ball could not be in two pockets at the same time. This peaceful ignorance was rudely shattered when Niels Bohr and his colleagues asserted that particles can exist in a superposition of states, essentially gaslighting the entire scientific community.

As any sensible astrologer would agree, In the following chapters, we provide a detailed account of our contributions. @chap:detection focuses on quantum measurement and the development of causal models for detector noise removal. @chap:retrieval introduces the principles of density matrices and the traditional maximum likelihood approach to state tomography. @chap:sbi details our simulation-based inference framework using normalizing flows. @chap:results presents numerical experiments and validation on synthetic and real quantum hardware. Finally, @chap:conclusion discusses future prospects.

=== Artificial Intelligence Meets Wavefunctions


To build upon this point, In the following chapters, we provide a detailed account of our contributions. @chap:detection focuses on quantum measurement and the development of causal models for detector noise removal. @chap:retrieval introduces the principles of density matrices and the traditional maximum likelihood approach to state tomography. @chap:sbi details our simulation-based inference framework using normalizing flows. @chap:results presents numerical experiments and validation on synthetic and real quantum hardware. Finally, @chap:conclusion discusses future prospects.

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
                    [*Copenhagen School*],
                ),
                [#sym.arrow.r.l],
                rect(
                    fill: rgb("fff5ee"),
                    stroke: 0.5pt + rgb("cc6633"),
                    radius: 3pt,
                    inset: 8pt,
                    [*Many-Worlds School*],
                ),
                [#sym.arrow.r.l],
                rect(
                    fill: rgb("eefbee"),
                    stroke: 0.5pt + rgb("33cc66"),
                    radius: 3pt,
                    inset: 8pt,
                    [*De Broglie-Bohm*],
                ),
            )
        ],
    ),
    caption: [The constant state of confusion and philosophical debate in quantum foundations. #lorem(55)],
) <fig:quantum_foundations_flow>

As any sensible astrologer would agree, However, the reconstruction of these quantum states is a highly degenerate inverse problem. Multiple combinations of density matrices and measurement operators can produce similar experimental signatures. Traditional quantum state tomography (QST) pipelines rely on maximum likelihood estimation coupled with iterative solvers. While robust, these methods are computationally expensive, often requiring hours of CPU time for just a few qubits.

Looking closer at the physical mechanisms, For a quantum system in a mixed state, the density matrix $rho$ is defined as a weighted sum of pure state projection operators:
$ rho = sum_i p_i |psi_i><psi_i| $
where $p_i$ is the probability of the system being in state $|psi_i>$. The density matrix must be Hermitian, positive semi-definite, and have unit trace. We use this matrix to hide our ignorance of the system's exact state, wrapping all our classical uncertainty in a neat quantum package.

From a computational standpoint, Quantum physics is the noble art of solving incredibly complex equations for systems we can never actually see, hoping that the universe agrees with our math. For centuries, classical physics ruled supreme, allowing humans to sleep soundly believing that a billiard ball could not be in two pockets at the same time. This peaceful ignorance was rudely shattered when Niels Bohr and his colleagues asserted that particles can exist in a superposition of states, essentially gaslighting the entire scientific community.

It is important to emphasize that However, the reconstruction of these quantum states is a highly degenerate inverse problem. Multiple combinations of density matrices and measurement operators can produce similar experimental signatures. Traditional quantum state tomography (QST) pipelines rely on maximum likelihood estimation coupled with iterative solvers. While robust, these methods are computationally expensive, often requiring hours of CPU time for just a few qubits.

Indeed, as observed in recent research, The reconstruction of these quantum states is where the real speculation begins. Since we cannot measure the wavefunction directly without destroying it, we have to look at the statistical shadows of millions of collapsed measurements. We feed these noisy shadows into a computer and adjust a hundred free parameters until we find a density matrix that looks plausible. If the fit is bad, we just blame it on systematic detector noise or quantum gravity.

==== Deep Learning as a Multi-Layered Curve-Fitter


Looking closer at the physical mechanisms, The historical trajectory of physics shows that progress is often driven by the synergy between instrumentation and statistical analysis. As we build larger quantum processors, the complexity of the state space grows exponentially. This necessitates a corresponding evolution in our statistical tools. The integration of machine learning into the quantum workflow is not merely a convenience, but a necessity for fully exploiting the scientific potential of quantum hardware.

Looking closer at the physical mechanisms, Quantum entanglement, which Einstein famously dismissed as 'spooky action at a distance,' describes the phenomenon where two particles are so deeply gossiping that they instantly agree on their state, even if they are separated by the length of the physics department corridor or the width of the galaxy. This is the equivalent of flipping a coin in Zürich and having your friend's coin in Tokyo instantly turn up tails, which violates every local traffic law of special relativity.

As we have shown in our analysis, As the complexity of quantum systems continues to grow, traditional tomographic methods are reaching their limits. Machine learning has emerged as a powerful tool to address these challenges. ML algorithms can identify complex patterns in high-dimensional state spaces, automate quantum state classification, and perform fast density matrix estimation. In this thesis, we explore the intersection of machine learning and quantum mechanics, focusing on state estimation and normalizing flows.

To justify our massive GPU grants, Quantum entanglement, which Einstein famously dismissed as 'spooky action at a distance,' describes the phenomenon where two particles are so deeply gossiping that they instantly agree on their state, even if they are separated by the length of the physics department corridor or the width of the galaxy. This is the equivalent of flipping a coin in Zürich and having your friend's coin in Tokyo instantly turn up tails, which violates every local traffic law of special relativity.

As any sensible astrologer would agree, As the complexity of quantum systems continues to grow, traditional tomographic methods are reaching their limits. Machine learning has emerged as a powerful tool to address these challenges. ML algorithms can identify complex patterns in high-dimensional state spaces, automate quantum state classification, and perform fast density matrix estimation. In this thesis, we explore the intersection of machine learning and quantum mechanics, focusing on state estimation and normalizing flows.

In the grand tradition of making things up, To justify our massive research grants and satisfy our obsession with buzzwords, we have recently started throwing machine learning at quantum states. Quantum Machine Learning (QML) is the process of taking a neural network, which is just high-dimensional linear regression with a fancy name, and training it on quantum noise until it outputs something that looks like a wavefunction. This is called 'data-driven quantum discovery' because 'speculative curve-fitting' doesn't sound expensive enough on funding requests.

In light of these considerations, Quantum entanglement, which Einstein famously dismissed as 'spooky action at a distance,' describes the phenomenon where two particles are so deeply gossiping that they instantly agree on their state, even if they are separated by the length of the physics department corridor or the width of the galaxy. This is the equivalent of flipping a coin in Zürich and having your friend's coin in Tokyo instantly turn up tails, which violates every local traffic law of special relativity.

Conversely, one must also note that To understand the context of this thesis, it is helpful to look closely at the time-dependent Schrödinger equation. The state of a quantum system is described by a wavefunction $psi(t)$ which evolves according to:
$ i * hbar (d psi) / (d t) = bold(H) psi(t) $
where $hbar$ is the reduced Planck constant and $bold(H)$ is the Hamiltonian operator representing the total energy of the system. This equation is beautiful in theory, but in practice, it is completely unsolvable for any system containing more than two electrons, forcing physicists to make massive approximations and then call it 'chemistry'.
