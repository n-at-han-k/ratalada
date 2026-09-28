"use client"

import { useState } from "react"
import { useFileUpload } from "@/hooks/use-file-upload"
import { cn } from "cn"

import {
  Avatar,
  AvatarFallback,
  AvatarImage,
} from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { UserCircle, XIcon, UploadIcon, Trash2Icon } from "lucide-react"

const PROFILE_IMAGE_ACCEPT = "image/png,image/jpeg,image/gif"
const PROFILE_IMAGE_MAX_SIZE = 10 * 1024 * 1024
const PROFILE_IMAGE_HELP_TEXT =
  "We only support PNGs, JPEGs and GIFs under 10MB."

interface ImageUploadFieldProps {
  ariaLabel: string
  inputId?: string
  defaultImage?: string
  alt?: string
}

export function ImageUploadField({
  ariaLabel,
  inputId,
  defaultImage,
  alt = "Uploaded profile image",
}: ImageUploadFieldProps) {
  const [removedCurrentImage, setRemovedCurrentImage] = useState(false)
  const [
    { files, errors },
    { clearErrors, removeFile, openFileDialog, getInputProps },
  ] = useFileUpload({
    accept: PROFILE_IMAGE_ACCEPT,
    maxSize: PROFILE_IMAGE_MAX_SIZE,
  })

  const currentFile = files[0] ?? null
  const hasSavedImage = Boolean(defaultImage) && !removedCurrentImage
  const previewUrl =
    currentFile?.preview ?? (hasSavedImage ? (defaultImage ?? null) : null)
  const fileName = currentFile?.file.name
  const hasImage = Boolean(previewUrl)
  const helperText = errors[0] ?? PROFILE_IMAGE_HELP_TEXT

  const handleCancelUpload = () => {
    if (!currentFile) {
      return
    }

    removeFile(currentFile.id)
    clearErrors()
  }

  const handleRemoveImage = () => {
    if (currentFile) {
      removeFile(currentFile.id)
    }

    setRemovedCurrentImage(true)
    clearErrors()
  }

  const handleOpenFileDialog = () => {
    clearErrors()
    openFileDialog()
  }

  return (
    <div className="flex flex-col gap-3 sm:flex-row sm:items-start">
      {/* Actions */}
      <div className="relative shrink-0">
        <Avatar className="size-16">
          <AvatarImage src={previewUrl ?? undefined} alt={fileName ?? alt} />
          <AvatarFallback className="bg-muted text-muted-foreground">
            <UserCircle aria-hidden="true" className="size-5 opacity-60" />
          </AvatarFallback>
        </Avatar>

        {currentFile ? (
          <Button
            type="button"
            variant="outline"
            size="icon-xs"
            onClick={handleCancelUpload}
            className="absolute -top-0.5 -right-0.5 size-5 rounded-full"
            aria-label={`Cancel ${currentFile.file.name}`}
          >
            <XIcon aria-hidden="true" />
          </Button>
        ) : null}
      </div>

      {/* Heading */}
      <div className="flex min-w-0 flex-1 flex-col gap-2.5">
        <div className="min-w-0 space-y-px">
          <h2 className="text-base font-semibold tracking-tight">
            Profile Picture
          </h2>
          <p
            className={cn(
              "text-sm",
              errors[0] ? "text-destructive" : "text-muted-foreground"
            )}
          >
            {helperText}
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <div className="relative inline-flex">
            <Button
              type="button"
              size="sm"
              onClick={handleOpenFileDialog}
              aria-haspopup="dialog"
            >
              <UploadIcon aria-hidden="true" />
              Upload
            </Button>
            <input
              {...getInputProps({ id: inputId })}
              className="sr-only"
              aria-label={ariaLabel}
              tabIndex={-1}
            />
          </div>

          {hasImage ? (
            <Button
              type="button"
              variant="destructive"
              size="icon-sm"
              onClick={handleRemoveImage}
              aria-label="Remove current image"
            >
              <Trash2Icon aria-hidden="true" />
            </Button>
          ) : null}
        </div>
      </div>
    </div>
  )
}