import React from "react";
import { NavLink } from "react-router-dom";
export default function Header() {
  return (
    <header>
      <nav>
        <NavLink to="/">Blog</NavLink>
        <NavLink to="/resume">Résumé</NavLink>
        <NavLink to="/projects">Projects</NavLink>
      </nav>
    </header>
  );
}