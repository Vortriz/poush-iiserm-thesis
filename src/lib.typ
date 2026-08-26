#import "@local/poush:0.1.0": *

#let titlepage(
    title,
    author,
    date,
) = {
    set page(
        paper: "a4",
        margin: (
            top: 2.5in,
            bottom: 1in,
            left: 1in,
            right: 1in,
        ),
    )
    set align(center)

    text(size: 20.74pt, weight: "bold", title)

    v(2em)

    text(size: 17.28pt, weight: "bold", author)

    v(2em)

    set text(size: 14.4pt)

    text(
        style: "italic",
    )[A dissertation submitted for the partial fulfilment of BS-MS dual degree in Science]

    v(3cm)

    image("assets/logo.jpg", width: 8cm)

    text(weight: "bold")[
        Indian Institute of Science Education and Research, Mohali \
        #date
    ]

    pagebreak(to: "odd")
}

#let certificate(
    title,
    author,
    reg,
    committee-members,
    supervisor,
    date,
) = centered-section(title: "Certificate of Examination")[
    #set par(
        justify: true,
        leading: 0.8em,
        first-line-indent: 1.5em,
    )

    This is to certify that the dissertation titled #strong(title) submitted by #strong(author) (Reg. No. #text(number-type: "lining", reg)) for the partial fulfillment of BS- MS Dual Degree programme of the institute, has been examined by the thesis committee duly appointed by the institute. The committee finds the work done by the candidate satisfactory and recommends that the report be accepted.

    #v(9em)

    #grid(
        columns: (1fr, 1fr, 1fr),
        column-gutter: 1.5cm,
        align: center,
        ..committee-members,
    )

    #v(9em)

    #if supervisor.len() == 1 {
        align(right)[
            #supervisor.at(0).name \
            (Supervisor) \
        ]
    } else if supervisor.len() == 2 {
        columns(2)[
            #align(left)[
                #supervisor.at(0).name \
                (Co-supervisor) \
            ]

            #colbreak()

            #align(right)[
                #supervisor.at(1).name \
                (Co-supervisor) \
            ]
        ]
    }

    #v(9em)

    #align(right)[Dated: #h(7em)]
]

#let declaration(
    supervisor,
    author,
) = centered-section(title: "Declaration")[
    #let supervisor-array = ()

    #for item in supervisor {
        supervisor-array.push([#item.name at #item.affiliation])
    }

    #set par(
        justify: true,
        leading: 0.8em,
        first-line-indent: 1.5em,
    )

    The work presented in this dissertation has been carried out by me under the guidance of #supervisor-array.join(", ", last: " and ").

    #v(1em)

    This work has not been submitted in part or in full for a degree, a diploma, or a fellowship to any other university or institute. Whenever contributions of others are involved, every effort is made to indicate this clearly, with due acknowledgement of collaborative research and discussions. This thesis is a bonafide record of original work done by me and all sources listed within have been detailed in the bibliography.

    #v(6em)

    #align(right)[
        #author \
        (Candidate) \
        Dated: #h(5em)
    ]

    #v(1em)

    In my capacity as the supervisor of the candidate's project work, I certify that the above statements by the candidate are true to the best of my knowledge.

    #v(6em)

    #if supervisor.len() == 1 {
        align(right)[
            #supervisor.at(0).name \
            (Supervisor) \
            Dated: #h(5em)
        ]
    } else if supervisor.len() == 2 {
        columns(2)[
            #align(left)[
                #supervisor.at(0).name \
                (Co-supervisor) \
                Dated: #h(5em)
            ]

            #colbreak()

            #align(right)[
                #supervisor.at(1).name \
                (Co-supervisor) \
                Dated: #h(5em)
            ]
        ]
    }
]

#let iiserm-thesis(
    title: [Title of MS Thesis],
    author: [*Name of the Student*],
    date: [Enter Relevant Date],
    reg: [Registration Number of the Student],
    committee-members: (
        [Member 1],
        [Member 2],
        [Member 3],
    ),
    supervisor: (
        (
            name: [*Name of the Supervisor*],
            affiliation: [Indian Institute of Science Education and Research, Mohali],
        ),
        // (
        //     name: "Name of the Co-supervisor",
        //     affiliation: "Indian Institute of Science Education and Research, Mohali"
        // ),
    ),
    colophon-text: none,
    doc,
) = {
    show: thesis

    set page(numbering: "i")

    titlepage(title, author, date)

    if colophon-text != none {
        colophon(colophon-text)
    }

    certificate(title, author, reg, committee-members, supervisor, date)

    declaration(supervisor, author)

    doc
}
