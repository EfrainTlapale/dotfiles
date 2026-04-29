local function capitalizeFirstLetter(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

local function stateFormatter(
  args, -- text from i(2) in this example i.e. { { "456" } }
  parent, -- parent snippet or parent node
  user_args -- user_args from opts.user_args
)
  return ', set' .. capitalizeFirstLetter(args[1][1])
end

return {
  s('log', { t 'console.log({', i(1), t '})' }),
  s('clog', { t 'console.log(', i(1), t ')' }),
  s('arrw', { t({ '() => {', '' }), i(1), t({ '', '}' }) }),
  s('uses', {
    t 'const [',
    i(1),
    f(stateFormatter, { 1 }, {}),
    t '] = useState(',
    i(2),
    t ')',
  }),
  s('usee', {
    t({ 'useEffect(() => {', '' }),
    i(1),
    t({ '', '}, [' }),
    i(2),
    t '])',
  }),

  s('logef', {
    t({ 'useEffect(() => {', 'console.log(' }),
    i(1),
    t({ ')', '}, [])' }),
  }),

  s('usem', {
    t({ 'useMemo(() => {', '' }),
    i(1),
    t({ '', '}, [' }),
    i(2),
    t '])',
  }),
  s('jlog', { t 'console.log(JSON.stringify(', i(1), t ', null, 2))' }),
  s('pps', { t '{}:{', i(1), t '}' }),
}
