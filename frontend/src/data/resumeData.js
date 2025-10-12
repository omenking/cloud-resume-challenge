const resumeData = {
  person: {
    name: "Andrew Brown",
    contact: {
      address: "710 Winnipeg St,<br />Schreiber, ON P0T 2S0, Canada",
      email: "andrew@exampro.co",
      phone: "+1 807-222-2323",
    },
  },

  sections: {
    education: [
      {
        id: 1,
        title: "Confederation College",
        subtitle: "Ontario College Advanced Diploma (3 years)",
        location: "Thunder Bay, ON",
        duration: "2007",
      },
    ],

    experience: [
      {
        id: 2,
        title: "ExamPro Training Inc - CEO and Co-founder",
        subtitle: "Free cloud learning study courses platform",
        location: "Schreiber, ON",
        duration: "2018-2025",
        details: [
          "Built a custom multi-tenant learning management system, deployed to AWS",
          "Created over 40 courses and 1000+ hours of educational content",
        ],
      },
      {
        id: 3,
        title: "Monsterbox Productions - Owner",
        subtitle: "Ruby on Rails web-development firm",
        location: "Toronto, ON",
        duration: "2009-2018",
        details: [
          "Built 50+ web-applications for various tech startups",
        ],
      },
      {
        id: 4,
        title: "PC Medic - IT Technician",
        subtitle: "Computer Repair",
        location: "Thunder Bay, ON",
        duration: "2003-2009",
        details: [
          "Hardware repairs, troubleshooting common computer issues",
          "Onsite training and computer repair",
        ],
      },
    ],

    leadership: [
      {
        id: 5,
        title: "Cloud Resume Challenge Bootcamp",
        subtitle: "I maintain the community project Cloud Resume Challenge",
        location: "Online",
        duration: "2025 May — Present",
        details: [
          "Update eBooks",
          "Created new video course",
          "Created companion cloud essentials course",
        ],
      },
    ],

    skills_interests: [
      {
        id: 6,
        title: "ExamPro Cloud Essentials",
        subtitle: "Cloud Fundamentals and multi-cloud knowledge",
        location: "Online",
        duration: "Valid Till: 2025-2028",
      },
      {
        id: 7,
        title: "JLPT Certification",
        subtitle: "I'm currently studying Japanese aiming to pass the JLPT N4 in 2025-2026",
        location: "Japan/Toronto",
        duration: "2025 May — Present",
      },
    ],
  },
  disclaimer: "This is an example résumé for instructional content and is not intended to be accurate.",
};

export default resumeData;