module.exports = client: ({snap,position,util:{isString,isFunction,isArray},Promise}) ->

  resolvePath = (state, path) -> 
    if path
      path.split(".").reduce ((acc, curr) -> 
          acc.parent = acc.parent[acc.prop] if acc.prop?
          acc.prop = curr
          return acc
        ),parent: state.obj
    else
      parent: state, prop: "obj"

  execute = (cmd, {parent, prop}) ->
    val = parent[prop]
    if isFunction(cmd)
      result = cmd(val)
    else if isString(cmd) 
      splitted = cmd.replace(")","").split("(")
      cmd = splitted.shift()
      if val[cmd]?
        if isFunction(val[cmd])
          result = val[cmd].apply(val,splitted)
        else 
          result = val[cmd]
    if result?
      if result.then?
        return result.then (result) -> 
          parent[prop] = result
      else
        parent[prop] = result

  snap.hookIn position.init, ({state}) ->
    if (tmp = state.transform)?
      tmp = [tmp] if isString(tmp) or isFunction(tmp)
      tmp = "": tmp if isArray(tmp)
      for k,v of tmp
        unless isArray(v)
          tmp[k] = [v] 
      state.transform = tmp

  snap.hookIn position.during-2, ({state}) ->
    if (transform = state.transform)? and state.obj?
      delete state.transform
      resolve = resolvePath.bind null, state
      workers = []
      for k,v of transform
        resolved = resolve k
        workers.push v.reduce ((acc,curr) ->
          saved = resolved
          acc.then -> execute(curr, saved)
          ), Promise.resolve()
      return Promise.all(workers)
