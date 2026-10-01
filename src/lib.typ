#import "@local/poush:0.1.0": *

// Special pages --------------------------------

#let titlepage(
    title,
    author,
    date,
    blue-cover: false,
) = {
    set page(
        paper: "a4",
        margin: (
            top: 1in,
            bottom: 1in,
            left: 1in,
            right: 1in,
        ),
        fill: if blue-cover == true {
            rgb("#00CCFF")
        } else {
            auto
        },
    )
    set align(center + horizon)

    par(
        justify: false,
        leading: 1em,
        text(
            size: 20.75pt,
            weight: "bold",
            hyphenate: false,
            title,
        ),
    )

    v(2em)

    text(size: 17.28pt, weight: "bold", author)

    v(2em)

    set text(size: 14.4pt)

    text(style: "italic")[
        A dissertation submitted for the partial fulfilment of \
        BS-MS dual degree in Science
    ]

    v(4.3em)

    if blue-cover == true {
        image("assets/iiserm_logo_blue.jpg", width: 8cm)
    } else if blue-cover == false {
        image("assets/iiserm_logo.jpg", width: 8cm)
    }

    v(4.3em)

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
    case,
    committee-members,
    date,
) = centered-section(title: "Certificate of Examination")[
    #set par(
        justify: true,
        leading: 0.8em,
        first-line-indent: 1.5em,
    )

    This is to certify that the dissertation titled #strong(title) submitted by #strong(author) (Reg. No. #text(number-type: "lining", reg)) for the partial fulfillment of BS- MS Dual Degree programme of IISER Mohali has been examined by the thesis committee duly appointed by the institution. The committee finds the work done by the candidate satisfactory and recommends that the report be accepted.

    #v(9em)

    #grid(
        columns: (1fr, 1fr, 1fr),
        column-gutter: 1.5cm,
        row-gutter: 0.5em,
        align: center,
        ..committee-members,
        [(Examiner 1)],
        [(Examiner 2)],
        if case == 1 [
            (Supervisor)
        ] else if case == 2 [
            (Co-supervisor)
        ] else if case == 3 [
            (Administrative Guide)
        ],
    )

    #v(9em)

    Dated:
]

#let declaration(
    title,
    case,
    committee-members,
    external-supervisor,
    author,
) = centered-section(title: "Declaration")[
    #set par(
        justify: true,
        leading: 0.8em,
        spacing: 2em,
        first-line-indent: 0em,
    )

    #let supervisors = ()
    #if case == 1 or case == 2 {
        supervisors.push(
            (
                name: committee-members.at(2),
                affiliation: [IISER Mohali],
            ),
        )
    }
    #if case == 2 or case == 3 {
        supervisors.push(
            (
                name: external-supervisor.name,
                affiliation: external-supervisor.affiliation,
            ),
        )
    }

    I have carried out the work presented in this dissertation titled #strong(title) under the guidance of #supervisors.map(x => [#x.name at #x.affiliation]).join(" and ").

    This work has not been submitted in part or in full for a degree, a diploma, or a fellowship to any other university or institute. Whenever contributions of others are involved, every effort is made to indicate this clearly, with due acknowledgement of collaborative research and discussions.

    This thesis is a bonafide record of original work done by me and all sources listed within have been detailed in the bibliography.

    #v(5em)

    #align(right)[
        #box()[
            #align(center)[
                #author \
                (Candidate) \
                Dated: #h(7.5em)
            ]
        ]
    ]

    #v(2.5em)

    In my capacity as the #{ if case == 1 or case == 3 [supervisor] else if case == 2 [co-supervisor] } of the candidate's project work, I certify that the above statements by the candidate are true to the best of my knowledge.

    #v(5em)

    #if case == 1 or case == 3 {
        align(right)[
            #box()[
                #align(center)[
                    #supervisors.at(0).name \
                    (Supervisor) \
                    Dated: #h(7.5em)
                ]
            ]
        ]
    } else if case == 2 {
        columns(2)[
            #align(left)[
                #supervisors.at(0).name \
                (Co-supervisor) \
                Dated: #h(7.5em)
            ]

            #colbreak()

            #align(right)[
                #supervisors.at(1).name \
                (Co-supervisor) \
                Dated: #h(7.5em)
            ]
        ]
    }
]

// Main -----------------------------------------

#let iiserm-thesis(
    title: [Title of MS Thesis],
    author: [*Name of the Student*],
    date: [Enter Relevant Date],
    reg: [Registration Number of the Student],
    case: 1,
    committee-members: (
        [Member 1],
        [Member 2],
        [Member 3],
    ),
    external-supervisor: none,
    colophon-text: none,
    blue-cover: false,
    doc,
) = {
    if case == 1 {
        assert(
            external-supervisor == none,
            message: "The status of Supervisor is assigned to Member 3 of the committee.",
        )
    } else if case == 2 {
        assert(
            external-supervisor != none,
            message: "Member 3 is the internal co-supervisor. External co-supervisor is required.",
        )
    } else if case == 3 {
        assert(
            external-supervisor != none,
            message: "The status of Administrative guide is assigned to Member 3 of the committee. External supervisor is required.",
        )
    } else {
        panic("Invalid case value. Please use 1, 2, or 3.")
    }

    show: thesis

    set page(numbering: "i")

    titlepage(title, author, date, blue-cover: blue-cover)

    if colophon-text != none {
        colophon(colophon-text)
    }

    certificate(title, author, reg, case, committee-members, date)

    declaration(title, case, committee-members, external-supervisor, author)

    doc
}
