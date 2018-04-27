exports.applyRecordImpl = function(transform, obj) {
  const result = {}
  for (key in obj) {
    const fn = transform[key]
    result[key] = fn(obj[key])
  }
  return result
}
