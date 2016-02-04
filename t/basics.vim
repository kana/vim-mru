runtime plugin/mru.vim

" Hack: Forget result of previous test run.
if !empty(mru#list())
  call remove(mru#list(), 0, -1)
endif

describe 'mru'
  it 'has no entry at first'
    Expect mru#list() == []
  end

  it 'does not react to visiting an empty buffer'
    new
    Expect mru#list() == []
    close
  end

  it 'updates the list for each buffer visit'
    new

    edit foo
    Expect mru#list() ==# [
    \   fnamemodify('foo', ':p'),
    \ ]

    edit bar
    Expect mru#list() ==# [
    \   fnamemodify('bar', ':p'),
    \   fnamemodify('foo', ':p'),
    \ ]

    edit baz
    Expect mru#list() ==# [
    \   fnamemodify('baz', ':p'),
    \   fnamemodify('bar', ':p'),
    \   fnamemodify('foo', ':p'),
    \ ]

    close
  end

  it 'reorder the list whenever known buffers are revisited'
    new

    edit foo
    Expect mru#list() ==# [
    \   fnamemodify('foo', ':p'),
    \   fnamemodify('baz', ':p'),
    \   fnamemodify('bar', ':p'),
    \ ]

    edit baz
    Expect mru#list() ==# [
    \   fnamemodify('baz', ':p'),
    \   fnamemodify('foo', ':p'),
    \   fnamemodify('bar', ':p'),
    \ ]

    close
  end

  it 'can save and restore the list'
    let list = mru#list()
    call mru#save()
    call mru#load()
    Expect mru#list() ==# list
  end
end
