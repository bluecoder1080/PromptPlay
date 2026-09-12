import Image from "next/image"

import { UserButton, OrganizationSwitcher } from "@clerk/nextjs"
import { auth } from "@clerk/nextjs/server"

import {
  Empty,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"

export default async function Page() {
  await auth.protect()

  return (
    <>
      <Empty>
        <EmptyHeader>
          <EmptyMedia>
            <Image src="/logo.svg" alt="PromptPlay" width={96} height={96} />
          </EmptyMedia>
          <EmptyTitle>What should we build today?</EmptyTitle>
          <EmptyDescription>
            Build your own racers, shooters, puzzles and whole worlds using your
            own words. If you can describe it, you can play it.
          </EmptyDescription>
        </EmptyHeader>
      </Empty>
      <UserButton />
      <OrganizationSwitcher/>
    </>
  )
}
