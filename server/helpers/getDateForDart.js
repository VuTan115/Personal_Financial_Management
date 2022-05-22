export default function getDateForDart(timestamp) {
  const dd = String(timestamp.getDate()).padStart(2, '0')
  const mm = String(timestamp.getMonth() + 1).padStart(2, '0') // January is 0!
  const yyyy = timestamp.getFullYear()

  return `${yyyy}${mm}${dd}`
}
