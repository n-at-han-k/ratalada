"use client"

import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import type { InvoiceRecord } from "./data"
import { DownloadIcon } from "lucide-react"

interface InvoiceHistoryCardProps {
  invoices: InvoiceRecord[]
}

export function InvoiceHistoryCard({ invoices }: InvoiceHistoryCardProps) {
  return (
    <Card className="gap-0 p-0">
      {/* Content */}
      <CardContent className="p-0">
        <div className="overflow-x-auto">
          <Table className="min-w-[42rem] table-fixed">
            <TableHeader>
              <TableRow>
                <TableHead className="w-[22%]">Invoice</TableHead>
                <TableHead className="w-[22%]">Period</TableHead>
                <TableHead className="w-[18%]">Date</TableHead>
                <TableHead className="w-[16%]">Total</TableHead>
                <TableHead className="w-[14%] text-right">Status</TableHead>
                <TableHead className="w-[8%] text-right">
                  <span className="sr-only">Download</span>
                </TableHead>
              </TableRow>
            </TableHeader>

            <TableBody>
              {invoices.map((invoice) => (
                <TableRow key={invoice.id}>
                  <TableCell className="font-medium whitespace-nowrap">
                    <a
                      href="#"
                      onClick={(event) => event.preventDefault()}
                      className="text-foreground hover:text-primary inline-flex underline-offset-4 transition-colors hover:underline"
                    >
                      {invoice.reference}
                    </a>
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm whitespace-nowrap">
                    {invoice.period}
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm whitespace-nowrap">
                    {invoice.issuedAt}
                  </TableCell>
                  <TableCell className="font-semibold tracking-tight whitespace-nowrap tabular-nums">
                    {invoice.total}
                  </TableCell>
                  <TableCell className="text-right">
                    <Badge variant={invoice.status.variant}>
                      {invoice.status.label}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon-sm"
                      aria-label={`Download ${invoice.reference}`}
                    >
                      <DownloadIcon aria-hidden="true" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </CardContent>
    </Card>
  )
}