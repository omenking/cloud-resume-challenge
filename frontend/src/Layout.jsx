import { useState } from 'react'
import Header from 'comps/Header'
import { Outlet, NavLink } from "react-router";

export default function Layout() {
  const [count, setCount] = useState(0)
  return (
    <>
      <Header></Header>
      <div className="content_wrap">
        <div className="content">
          <article>
            <Outlet />
          </article>
        </div>
      </div>
    </>
  )
}