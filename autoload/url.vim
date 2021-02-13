function url#open(url)
	" Escape values that will be expanded, like % and #.
	let myurl=shellescape(a:url,1)
	" The shellescape adds quotes on both sides, which we now need to remove
	" so !slient doesn't choke on it.
	let myurl=myurl[1:-2]
	silent execute '!start' myurl
endfunction

function url#open_command(qargs)
	let url=trim(a:qargs)

	if len(url) > 0
		" To test, run:
		" :OpenURL example.com
		" :OpenURL https://example.com
		" add prefix if non present
		if len(split(url, '://')) < 2
			let url='https://'.url
		endif
	else
		" To test, put cursor of one of the lines below and run :OpenURL
		" http://example.com
		" https://example.com
		" example.com
		let url=expand('<cWORD>')

		" Handle markdown links:
		" [link description](http://example.com)
		" https://daringfireball.net/projects/markdown/syntax#link
		" Note that since cWORD will not include anything before the
		" space, don't look for the opening [.
		let markdown_url = url->matchlist('^.*\][(]\(.*\)[)]')
		if len(markdown_url) >= 2
			let url = markdown_url[1]
		endif

		" Handle rst links
		" <link>
		" https://docutils.sourceforge.io/docs/user/rst/quickref.html#external-hyperlink-targets
		let rst_url = url->matchlist('^<\(.*\)>.*')
		if len(rst_url)
			let url = rst_url[1]
		endif

		" no prefix, use https:// by default.
		if len(split(url, '://')) < 2
			let url='https://'.url
		endif
		let url=trim(input("Open URL: ", url))
	endif

	if !empty(url)
		call url#open(url)
	endif
endfunction

function url#google(term)
	let url='https://www.google.com/search?q=' . a:term
	call url#open(url)
endfunction

function url#google_command(qargs)
	let terms=trim(a:qargs)
	if len(terms) == 0
		let terms=trim(input("Google: ", expand('<cWORD>')))
	endif
	if !empty(terms)
		call url#google(terms)
	endif
endfunction

function url#define_word_command(qargs)
	let terms=trim(a:qargs)
	if len(terms) == 0
		let terms=expand('<cword>')
	endif
	if len(terms) == 0
		let terms=trim(input("Define Word: ", ''))
	endif
	if !empty(terms)
		call url#open('https://www.merriam-webster.com/dictionary/'.terms)
	endif
endfunction

