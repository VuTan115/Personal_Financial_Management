function getMonday(timestamp) {
  const d = new Date(timestamp)
  const day = d.getDay()
  const diff = d.getDate() - day + (day === 0 ? -6 : 1) // adjust when day is sunday
  const result = new Date(d.setDate(diff))
  result.setTime(result.getTime() + (7 * 60 * 60 * 1000))
  result.setHours(0, 0, 0, 0)
  return result
}
function getSunday(timestamp) {
  const date = new Date(getMonday(timestamp))
  date.setDate(date.getDate() + 6)
  date.setHours(23, 59, 59, 999)
  return date
}
const getWeekDay = {
  getMonday,
  getSunday
}
export default getWeekDay
