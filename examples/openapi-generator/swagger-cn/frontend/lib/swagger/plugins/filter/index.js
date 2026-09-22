import opsFilter from "@/lib/swagger/plugins/filter/opsFilter"

export default function() {
  return {
    fn: {
      opsFilter
    }
  }
}
