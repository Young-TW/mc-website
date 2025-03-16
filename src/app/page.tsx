import Image from "next/image";

const links = [
  {
    title: "Discord",
    href: "https://discord.gg/Sugbu3t9zd",
    description: "Join our Discord server to play with other player!",
  },
  {
    title: "Server",
    href: "https://mc.young-tw.com",
    description: "Copy the link mc.young-tw.com to join our server!",
  },
  {
    title: "Contact",
    href: "https://youngtw.net",
    description: "Contact us if you have any question!",
  },
  {
    title: "Donate",
    href: "https://donate.young-tw.com",
    description: "Donate to support our server!",
  },
];

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24 bg-hero bg-fixed bg-no-repeat bg-center bg-cover">
      <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
        <p className="fixed left-0 top-0 flex w-full justify-center border-b border-gray-300 bg-gradient-to-b from-zinc-200 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800/30 dark:from-inherit lg:static lg:w-auto  lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800/30">
          Join mc.young-tw.com now!
        </p>
        <div className="fixed bottom-0 left-0 flex h-48 w-full items-end justify-center bg-gradient-to-t from-white via-white dark:from-black dark:via-black lg:static lg:h-auto lg:w-auto lg:bg-none">
          <a
            className="pointer-events-none flex place-items-center gap-2 p-8 lg:pointer-events-auto lg:p-0"
            href="https://youngtw.net"
            target="_blank"
            rel="noopener noreferrer"
          >
            By Young 2025
          </a>
        </div>
      </div>

      <div className="mb-32 grid text-center lg:max-w-5xl lg:w-full lg:mb-0 lg:grid-cols-4 lg:text-left">
        {links.map((p) => {
          return (
            <a
              href={p.href}
              className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30"
              target="_blank"
              rel="noopener noreferrer"
              key={p.title}
            >
              <h2 className={`mb-3 text-2xl font-semibold`}>
                {p.title}{" "}
                <span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
                  -&gt;
                </span>
              </h2>
              <p className={`m-0 max-w-[30ch] text-sm opacity-50`}>
                {p.description}
              </p>
            </a>
          );
        })}
      </div>
    </main>
  );
}
