import Image from "next/image"

import {
  Empty,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"

export default function Page() {
  return (
    <Empty className="min-h-svh">
      <EmptyHeader className="max-w-3xl gap-8">
        <EmptyMedia className="mb-0">
          <Image
            src="/logo.svg"
            alt="PromptPlay"
            width={96}
            height={96}
            loading="eager"
            className="size-24"
          />
        </EmptyMedia>
        <EmptyTitle className="text-5xl text-muted-foreground/10">
          What should we build today?
        </EmptyTitle>
        <EmptyDescription className="text-2xl text-muted-foreground/50">
          Build your own racers, shooters, puzzles and whole worlds using your own
          words. If you can describe it, you can play it.
        </EmptyDescription>
      </EmptyHeader>
    </Empty>
  )
}
