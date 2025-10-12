import React from "react";

export default function ResumeHeader(props) {
  const person = props.person;
  const contact = props.person.contact;
  return (
    <section className="header">
    <h1>{ person.name }</h1>
    <p>
        <span className="address" dangerouslySetInnerHTML={{ __html: contact.address }} />
        <span className="bull">&bull;</span>
        <span className="email"><a href="mailto:{contact.email}">{contact.email}</a></span>
        <span className="bull">&bull;</span>
        <span className="phone">{contact.phone}</span>
    </p>
    </section>
  );
}