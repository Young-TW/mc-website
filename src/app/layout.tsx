import './globals.css'
import type { Metadata } from 'next'
import localFont from 'next/font/local'

// Self-hosted Inter so the production build is hermetic (no Google Fonts fetch).
const inter = localFont({
  src: './fonts/inter-latin-wght-normal.woff2',
  display: 'swap',
})

export const metadata: Metadata = {
  title: 'Minecraft Server',
  description: 'Join our Minecraft server now!',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="icon" href="/favicon.png" />
      </head>
      <body className={inter.className}>{children}</body>
    </html>
  )
}
