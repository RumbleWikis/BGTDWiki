--[[
    This file exists for project-scope Scribunto types.

    DO NOT REQUIRE!

    TODO: Syntactic Sugar
]]

---@class Expandable
local Expandable = {}

---Returns the result of [`frame:preprocess( text )`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#frame:preprocess)
---@param self Expandable
---@return string
function Expandable.expand(self) end

---@class Frame
local Frame = {}

---A table for accessing the arguments passed to the frame. For example, if a module is called from wikitext with
---```
---{{#invoke:module|function|arg1|arg2|name=arg3}}
---```
---then `frame.args[1]`will return "arg1", `frame.args[2]` will return "arg2", and `frame.args['name']` (or `frame.args.name`) will return "arg3". It is also possible to iterate over arguments using `pairs( frame.args )` or `ipairs( frame.args )`.
---
---Note that values in this table are always strings; [`tonumber()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#tonumber) may be used to convert them to numbers, if necessary. Keys, however, are numbers even if explicitly supplied in the invocation: `{{#invoke:module|function|1|2=2}}` gives string values "1" and "2" indexed by numeric keys 1 and 2.
---
---As in MediaWiki template invocations, named arguments will have leading and trailing whitespace removed from both the name and the value before they are passed to Lua, whereas unnamed arguments will not have whitespace stripped.
---
---For performance reasons, frame.args is a metatable, not a real table of arguments. Argument values are requested from MediaWiki on demand. This means that most other table methods will not work correctly, including `#frame.args`, `next( frame.args )`, and the functions in the [Table library](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#Table_library).
---
---If preprocessor syntax such as template invocations and triple-brace arguments are included within an argument to #invoke, they will be expanded before being passed to Lua. If certain special tags written in XML notation, such as `<pre>`, `<nowiki>`, `<gallery>` and `<ref>`, are included as arguments to #invoke, then these tags will be converted to "strip markers" — special strings which begin with a delete character (ASCII 127), to be replaced with HTML after they are returned from #invoke.
---@type table<number | string, string>
frame.args = {}

---Called on the frame created by `{{#invoke:}}`, returns the frame for the page that called `{{#invoke:}}`. Called on that frame, returns nil. This lets you just put `{{#invoke:ModuleName|method}}` inside a template and the parameters passed to the template (i.e. `{{Hello|we|are|foo=Wikians}})` will be passed straight to the Lua module, without having to include them directly (so, you don't have to do `{{#invoke:ModuleName|method|{{{1|}}}|{{{2|}}}|{{{foo|}}}}})`.
---
---**Example**:
---* Module:Hello
---
---```lua
---local p = {}
---function p.hello( frame )
---‍    return "Hello, " .. frame:getParent().args[1] .. "!"
---end
---return p
---```
---
---* Template:Hello
---
---```wikitext
---{{#invoke:Hello|hello}}
---```
---
---* Article
---
---```wikitext
---{{Hello|Fandom}}
---```
---
---This will output "Hello, Fandom!"
---@param self Frame
---@return Frame
function frame.getParent(self) end

---This is transclusion. The call
---
---```wikitext
---frame:expandTemplate{ title = 'template', args = { 'arg1', 'arg2', name = 'arg3' } }
---```
---
---does roughly the same thing from Lua that `{{template|arg1|arg2|name=arg3}}` does in wikitext. As in transclusion, if the passed title does not contain a namespace prefix it will be assumed to be in the Template: namespace.
---
---Note that the title and arguments are not preprocessed before being passed into the template:
---
---```lua
---‍-- This is roughly equivalent to wikitext like
---‍-- {{template|{{!}}}}
---‍frame:expandTemplate{ title = 'template', args = { '|' } }
---
---‍-- This is roughly equivalent to wikitext like
---‍-- {{template|{{((}}!{{))}}}}
---frame:expandTemplate{ title = 'template', args = { '{{!}}' } }
---```
---
---@param self Frame
---@param title string
---@param args table<number | string, string> | void
---@return string
function frame.expandTemplate(self, title, args) end

---This expands wikitext in the context of the frame, i.e. templates, parser functions, and parameters such as {{{1}}} are expanded. Certain special tags written in XML-style notation, such as `<pre>`, `<nowiki>`, `<gallery>` and `<ref>`, will be replaced with "strip markers" — special strings which begin with a delete character (ASCII 127), to be replaced with HTML after they are returned from `{{#invoke}}`.
---
---If you are expanding a single template, use [`frame:expandTemplate`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#frame:expandTemplate) instead of trying to construct a wikitext string to pass to this method. It's faster and less prone to error if the arguments contain pipe characters or other wikimarkup.

---```lua
---local p = {}
---function p.hello( frame )
---‍    -- This will preprocess the wikitext and expand the template {{foo}}
---‍    return frame:preprocess( "'''Bold''' and ''italics'' is {{Foo}}" )
---end
---return p
---```
---
---@param self Frame
---@param text string
---@return string
function frame.preprocess(self, text) end

---Gets an object for the specified argument, or nil if the argument is not provided.
---
---The returned object has one method, `object:expand()`, that returns the expanded wikitext for the argument.
---
---```lua
---local p = {}
---
---function p.hello( frame )
---‍    -- {{#invoke:ModuleName|hello|''Foo'' bar|{{Foo}}|foo={{HelloWorld}}}}
---‍    local varOne = frame:getArgument( 1 )
---‍    local varTwo = frame.args[2]
---‍    local varThree = frame:getArgument( 'foo' )
---‍    return varOne:expand() .. varTwo .. varThree:expand()
---end
---
---return p
---```
---
---@param self Frame
---@param name string
---@return Expandable
function frame.getArgument(self, name) end

---Returns an object with one method, `object:expand()`, that returns the result of [`frame:preprocess( text )`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#frame:preprocess).
---@param self Frame
---@param text string
---@return Expandable
function frame.newParserValue(self, text) end

---Returns an object with one method, `object:expand()`, that returns the result of [`frame:preprocess( text )`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#frame:preprocess).
---@param self Frame
---@param text string
---@return Expandable
function frame.newTemplateParserValue(self, text) end

---Same as `pairs( frame.args )`. Included for backwards compatibility.
---@deprecated
---@param self Frame
---@return function
function frame.argumentPairs(self) end

---Returns the title associated with the frame as a string.
---@param self Frame
---@return string
function frame.getTitle(self) end

---@class Language
local Language = {}

---Returns the language code for this language object.
---@param self Language
---@return string
function Language.getCode(self) end

---Returns true if the language is written right-to-left, false if it is written left-to-right.
---@param self Language
---@return boolean
function Language.isRTL(self) end

---Converts the string to lowercase, honoring any special rules for the given language.
---When the [Ustring library](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_library) is loaded, the [mw.ustring.lower()](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.ustring.lower) function is implemented as a call to `mw.language.getContentLanguage():lc( s )`.
---@param self Language
---@param text string
---@return string
function Language.lc(self, text) end

---Converts the first character of the string to lowercase, as with [`lang:lc()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.language:lc).
---@param self Language
---@param text string
---@return string
function Language.lcfirst(self, text) end

---Converts the string to uppercase, honoring any special rules for the given language.
---
---When the [Ustring](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_library) library is loaded, the [`mw.ustring.upper()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.ustring.upper) function is implemented as a call to `mw.language.getContentLanguage():uc( s )`.
---@param self Language
---@param text string
---@return string
function Language.uc(self, text) end

---Converts the first character of the string to uppercase, as with [`lang:uc()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.language:uc).
---@param self Language
---@param text string
---@return string
function Language.ucfirst(self, text) end

---Converts the string to a representation appropriate for case-insensitive comparison. Note that the result may not make any sense when displayed.
---@param self Language
---@param text string
---@return string
function Language.caseFold(self, text) end

---Formats a number with grouping and decimal separators appropriate for the given language. Given 123456.78, this may produce "123,456.78", "123.456,78", or even something like "١٢٣٬٤٥٦٫٧٨" depending on the language and wiki configuration.
---
---With the second parameter, one can prevent the output from containing commas, as shown below:
---
---```lua
---local result = lang:formatNum(123123123, true)
---```
---
---@param self Language
---@param number number
---@param nocommafy boolean | void
---@return string
function Language.formatNum(self, number, nocommafy) end

---Formats a date according to the given format string. If `timestamp` is omitted, the default is the current time. The value for `local` must be a boolean or nil; if true, the time is formatted in the server's local time rather than in UTC.
---
---The **timestamp** is the actual date. It accepts dates with either a backslash or dash e.g. "2015/10/20" or "2015-10-20".
---
---The format string and supported values for `timestamp` are identical to those for the [#time parser function](http://mediawiki.org/wiki/Help:Extension:ParserFunctions#.23time) from [Extension:ParserFunctions](http://mediawiki.org/wiki/Extension:ParserFunctions), as shown below:
---
---This outputs the current date with spaces between the month,day and year
---
---```lua
---lang:formatDate( 'y m d' )
---```
---
---This outputs the inputted date using the specified format
---
---```lua
---lang:formatDate( 'y m d', "2015-02-01" )
---```
---
---Note that backslashes may need to be doubled in the Lua string where they wouldn't in wikitext:
---
---```lua
---‍-- This outputs a newline, where {{#time:\n}} would output a literal "n"
---lang:formatDate( '\n' )
---‍-- This outputs a literal "n", where {{#time:\\n}} would output a backslash followed by the month number.
---lang:formatDate( '\\n' )
---‍-- This outputs a backslash followed by the month number, where `{{#time:\\\\n}}` would output two backslashes followed by the month number.
---lang:formatDate( '\\\\n' )
---```
---
---@param self Language
---@param format string
---@param timestamp string | void
---@param locale string | void
---@return string
function Language.formatDate(self, format, timestamp, locale) end

---This takes a number as formatted by [`lang:formatNum()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.language:formatNum) and returns the actual number. In other words, this is basically a language-aware version of [`tonumber()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#tonumber).
---
---This library allows one to do arithmetic in multiple supported languages (simultaneously), and is better than the `{{#expr}}` parser function:
---
---```lua
---local n1 = "١"
---local n2 = "٣"
---local lang = mw.language.new("ar")
---local num1 = lang:parseFormattedNumber(n1)
---local num2 = lang:parseFormattedNumber(n2)
---local tot = lang:formatNum(num1 + num2)
---mw.log(tot)
---```
---
---@param self Language
---@param text string
---@return number
function Language.parseFormattedNumber(self, text) end

---This chooses the appropriate grammatical form from `forms` (which must be a [sequence](https://dev.fandom.com/wiki/Lua_reference_manual#sequence) table) or `...` based on the number `n`. For example, in English you might use `n .. ' ' .. lang:plural( n, 'sock', 'socks' )` or` n .. ' ' .. lang:plural( n, { 'sock', 'socks' } )` to generate grammatically-correct text whether there is only 1 sock or 200 socks.
---
---The necessary values for the sequence are language-dependent, see [mw:Help:Magic words#Language-dependent word conversions](http://mediawiki.org/wiki/Help:Magic_words#Language-dependent_word_conversions) for some details.
---@param self Language
---@param number number
---@return string
function Language.convertPlural(self, number, ...) end

---This chooses the appropriate inflected form of `word` for the given inflection code `case`.
---
---The possible values for `word` and `case` are language-dependent, see 'mw:Help:Magic words#Language-dependent word conversions](http://mediawiki.org/wiki/Help:Magic_words#Language-dependent_word_conversions) for some details.
---@param self Language
---@param word string
---@param case string
---@return string
function Language.convertGrammar(self, word, case) end

---Chooses the string corresponding to the gender of `what`, which may be "male", "female", or a registered user name.
---@param self Language
---@param what string
---@param masculine string | void
---@param feminine string | void
---@param neutral string | void
---@return string | void
function Language.gender(self, what, masculine, feminine, neutral) end

---@class LanguageService
local LanguageService = {}

---The full name of the native language name (language autonym).
---@param code string
---@return string
function LanguageService.fetchLanguageName(code) end

---Returns a new language object for the wiki's default content language.
---@return Language
function LanguageService.getContentLanguage() end

---Returns true if a language code is of a valid form for the purposes of internal customisation of MediaWiki.
---
---The code may not actually correspond to any known language.
---@param code string
---@return boolean
function LanguageService.isValidBuiltInCode(code) end

---Returns true if a language code string is of a valid form, whether or not it exists. This includes codes which are used solely for customisation via the MediaWiki namespace.
---
---The code may not actually correspond to any known language.
---@param code string
---@return boolean
function LanguageService.isValidCode(code) end

---Creates a new language object. Language objects do not have any publicly accessible properties, but they do have several methods, which are documented below.
---
---The methods below must all use the language object (e.g. lang).
---
---```lua
---local lang = mw.language.new("en")
---local ucText = lang:uc("En Taro Adun executor")
---mw.log (ucText)
---```
---
---@param code string
---@return Language
function LanguageService.new(code) end

---@class Namespace
local Namespace = {}

---Namespace number.
---@type number
Namespace.id = 0

---Local namespace name.
---@type string
Namespace.name = ""

---Canonical namespace name.
---@type string
Namespace.canonicalName = ""

---Set on namespace 0, the name to be used for display (since the name is often the empty string).
---@type string | nil
Namespace.displayName = ""

---Whether subpages are enabled for the namespace.
---@type boolean
Namespace.hasSubPages = true

---Whether the namespace has different aliases for different genders.
---@type boolean
Namespace.hasGenderDistinction = true

---Whether the first letter of pages in the namespace is capitalized.
---@type boolean
Namespace.isCapitalized = true

---Whether this is a content namespace.
---@type boolean
Namespace.isContent = true

---Whether pages in the namespace can be transcluded.
---@type boolean
Namespace.isIncludable = true

---Whether pages in the namespace can be moved.
---@type boolean
Namespace.isMovable = true

---Whether this is a subject namespace.
---@type boolean
Namespace.isSubject = true

---Whether this is a talk namespace.
---@type boolean
Namespace.isTalk = true

---List of aliases for the namespace.
---@type string[]
Namespace.aliases = {}

---Reference to the corresponding subject namespace's data.
---@type Namespace | nil
Namespace.subject = {}

---Reference to the corresponding talk namespace's data.
---@type Namespace | nil
Namespace.talk = {}

---Reference to the corresponding associated namespace's data.
---@type Namespace | nil
Namespace.associated = {}

---@class CategoryStats
local CategoryStats = {}

---Total pages, files, and subcategories.
---@type number
CategoryStats.all = 0

---Number of subcategories.
---@type number
CategoryStats.subcats = 0

---Number of files.
---@type number
CategoryStats.files = 0

---Number of pages.
---@type number
CategoryStats.pages = 0

---@class SiteStats
local SiteStats = {}

---Number of pages in the wiki.
---@type number
SiteStats.pages = 0

---Number of articles in the wiki.
---@type number
SiteStats.articles = 0

---Number of files in the wiki.
---@type number
SiteStats.files = 0

---Number of edits in the wiki.
---@type number
SiteStats.edits = 0

---Number of views in the wiki. Not available if [$wgDisableCounters](http://mediawiki.org/wiki/Manual:$wgDisableCounters) is set.
---@type number | nil
SiteStats.views = 0

---Number of users in the wiki.
---@type number
SiteStats.users = 0

---Number of active users in the wiki.
---@type number
SiteStats.activeUsers = 0

---Number of users in group 'sysop' in the wiki.
---@type number
SiteStats.admins = 0

---**This function is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**
---
---Gets statistics about the category. If `which` is unspecified, nil, or "*".
---
---If `which` is specified, it will return `category[which]`
---
---Each new category queried will increment the expensive function count.
---@param category string
---@param which string | void
---@return CategoryStats
function SiteStats.pagesInCategory(category, which) end

---Returns the number of pages in the given namespace (specify by number).
---@param namespace number
---@return number
function SiteStats.pagesInNamespace(namespace) end

---Returns the number of users in the given group.
---@param group string
---@return number
function SiteStats.usersInGroup(group) end

---@class Site
local Site = {}

---A string holding the current version of MediaWiki.
---@type string
Site.currentVersion = ""

---The value of [$wgScriptPath](https://mediawiki.org/wiki/Manual:$wgScriptPath).
---@type string
Site.scriptPath = ""

---The value of [$wgServer](http://mediawiki.org/wiki/Manual:$wgServer)
---@type string
Site.server = ""

---The value of [$wgSiteName](http://mediawiki.org/wiki/Manual:$wgSitename)
---@type string
Site.siteName = ""

---The value of [$wgStylePath](http://mediawiki.org/wiki/Manual:$wgStylePath)
---@type string
Site.stylePath = ""

---Table holding data for all namespaces, indexed by number, localized, and canonical names.
---@type table<string | number, Namespace>
Site.namespaces = {}

---Table holding just the content namespaces, indexed by number, localized, and canonical names. See [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces) for details.
---@type table<string | number, Namespace>
Site.contentNamespaces = {}

---Table holding just the subject namespaces, indexed by number, localized, and canonical names. See [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces) for details.
---@type table<string | number, Namespace>
Site.subjectNamespaces = {}

---Table holding just the talk namespaces, indexed by number, localized, and canonical names. See [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces) for details.
---@type table<string | number, Namespace>
Site.talkNamespaces = {}

---@type SiteStats
Site.stats = SiteStats

---@class URI
local URI = {}

---Protocol/scheme.
---@type string | nil
URI.protocol = ""

---User.
---@type string | nil
URI.user = ""

---Password.
---@type string | nil
URI.password = ""

---Host.
---@type string | nil
URI.host = ""

---Port.
---@type number | nil
URI.port = 0

---Path.
---@type string | nil
URI.path = ""

---Query table.
---@type table<string, any> | nil
URI.query = {}

---Fragment.
---@type string | nil
URI.fragment = ""

---User and Password.
---@type string | nil
URI.userInfo = ""

---Host and Port.
---@type string | nil
URI.hostPort = ""

---User, Password, Host, and Port.
---@type string | nil
URI.authority = ""

---Stringified version of `query`
---@type string | nil
URI.queryString = ""

---Path, Query string, and Fragment.
---@type string | nil
URI.relativePath = ""

---Parses a string into the current URI object. Any fields specified in the string will be replaced in the current object; fields not specified will keep their old values.
---@param self URI
---@param text string
---@return URI
function URI.parse(self, text) end

---Makes a copy of the URI object.
---@param self URI
---@return URI
function URI.clone(self) end

---Merges the parameters table into the object's query table.
---@param self URI
---@return URI
function URI.extend(self, ...) end

---@class URIService
local URIService = {}

---[Percent-encodes](http://en.wikipedia.org/wiki/Percent-encoding) the string. The default type, "QUERY", encodes spaces using '+' for use in query strings; "PATH" encodes spaces as %20; and "WIKI" encodes spaces as '_'.
---
---Note that the "WIKI" format is not entirely reversable, as both spaces and underscores are encoded as '_'
---
---On the Unified Community Platform wikis, the "WIKI" format matches the behaviour of `{{urlencode|...}}` - any symbol in the set `[!$()*,./:;@~_-]` will not be percent-encoded.
---@param text string
---@param enctype "QUERY" | "PATH" | "WIKI" | void
---@return string
function URIService.encode(text, enctype) end

---[Percent-decodes](http://en.wikipedia.org/wiki/Percent-encoding) the string. The default type, "QUERY", decodes '+' to space; "PATH" does not perform any extra decoding; and "WIKI" decodes '_' to space.
---@param text string
---@param dectype "QUERY" | "PATH" | "WIKI" | void
---@return string
function URIService.decode(text, dectype) end

---Encodes a string for use in a MediaWiki URI fragment.
---@param text string
---@return string
function URIService.anchorEncode(text) end

---Encodes a table as a URI query string. Keys should be strings; values may be strings or numbers, sequence tables, or boolean false.
---@param table table<string, any>
---@return string
function URIService.buildQueryString(table) end

---Decodes a query string to a table. Keys in the string without values will have a value of false; keys repeated multiple times will have sequence tables as values; and others will have strings as values.
---@param queryString string
---@return table<string, any>
function URIService.parseQueryString(queryString) end

---Returns a [URI object](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#URI_object) for the canonical url for a page, with optional query string/table.
---@param page string
---@param query table<string, any> | string | void
---@return URI
function URIService.canonicalUrl(page, query) end

---Returns a [URI object](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#URI_object) for the full url for a page, with optional query string/table.
---@param page string
---@param query table<string, any> | string | void
---@return URI
function URIService.fullUrl(page, query) end

---Returns a [URI object](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#URI_object) for the local url for a page, with optional query string/table.
---@param page string
---@param query table<string, any> | string | void
---@return URI
function URIService.localUrl(page, query) end

---Validates the passed table (or URI object). Returns a boolean indicating whether the table was valid, and on failure a string explaining what problems were found.
---@param table table<string, any> | URI
---@return boolean
function URIService.validate(table) end

---Constructs a new [URI object](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#URI_object) for the passed string or table. See the description of URI objects for the possible fields for the table.
---@param query table<string, any> | string
---@return URI
function URIService.new(query) end

---@class UStringService
local UStringService = {}

---The maximum allowed length of a pattern, in bytes.
---@type number
UStringService.maxPatternLength = 0

---The maximum allowed length of a string, in bytes.
---@type number
UStringService.maxStringLength = 0

---Returns individual bytes; identical to [`string.byte()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.byte).
---@param s string
---@param i number | void
---@param j number | void
---@return number[]
function UStringService.byte(s, i, j) end

---Returns individual the byte offset of a character in the string. The default for both `l` and `i` is 1. i may be negative, in which case it counts from the end of the string.
---
---The character at `l` = 1 is the first character starting at or after byte `i`; the character at `l` = 0 is the first character starting at or before byte `i`. Note this may be the same character. Greater or lesser values of `l` are calculated relative to these.
---@param s string
---@param l number | void
---@param i number | void
---@return number
function UStringService.byteOffset(s, l, i) end

---Much like [`string.char()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.char), except that the integers are Unicode codepoints rather than byte values.
---@return string[]
function UStringService.char(...) end

---Much like [`string.byte()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.byte), except that the return values are codepoints and the offsets are characters rather than bytes.
---@param s string
---@param i number | void
---@param j number | void
---@return number[]
function UStringService.codepoint(s, i, j) end

---Much like [`string.find()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.find), except that the pattern is extended as described in [Ustring patterns](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_patterns) and the `init` offset is in characters rather than bytes.
---@param s string
---@param pattern string
---@param init number | void
---@param plain boolean | void
---@return number[]
function UStringService.find(s, pattern, init, plain) end

---Identical to [`string.format()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.format). Widths and precisions for strings are expressed in bytes, not codepoints.
---@param s string
---@return string
function UStringService.format(s, ...) end

---Returns three values for iterating over the codepoints in the string. `i` defaults to 1, and` j` to -1. This is intended for use in the [iterator form of `for`](https://dev.fandom.com/wiki/Lua_reference_manual#iterators):
---
---```
---for codepoint in mw.ustring.gcodepoint( s ) do
---
---end
---```
---
---@param s string
---@param i number | void
---@param j number | void
---@return any, any, any
function UStringService.gcodepoint(s, i, j) end

---Much like [`string.gmatch()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.gmatch), except that the pattern is extended as described in [Ustring patterns](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_patterns).
---@param s string
---@param pattern string
---@return function
function UStringService.gmatch(s, pattern) end

---Much like [`string.gsub()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.gsub), except that the pattern is extended as described in [Ustring patterns](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_patterns).
---@param s string
---@param pattern string
---@param repl string | table | function | nil
---@param n number | nil
---@return string, number
function UStringService.gsub(s, pattern, repl, n) end

---Returns true if the string is valid UTF-8, false if not.
---@param s string
---@return boolean
function UStringService.isutf8(s) end

---Returns the length of the string in codepoints, or nil if the string is not valid UTF-8.
---@param s string
---@return number | nil
function UStringService.len(s) end

---Much like [`string.lower()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.lower), except that all characters with lowercase to uppercase definitions in Unicode are converted.
---
---If the [Language library](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.match) is also loaded, this will instead call [`lc()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.language:lc) on the default language object.
---@param s string
---@return string
function UStringService.lower(s) end

---Much like [`string.match()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.match), except that the pattern is extended as described in Ustring patterns and the `init` offset is in characters rather than bytes.
---@param s string
---@param pattern string
---@param init number | void
---@return string
function UStringService.match(s, pattern, init) end

---Identical to [`string.rep()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.rep).
---@param s string
---@param n number
---@return string
function UStringService.rep(s, n) end

---Much like [`string.sub()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.sub), except that the offsets are characters rather than bytes.
---@param s string
---@param i number
---@param j number | void
---@return string
function UStringService.sub(s, i, j) end

---Converts the string to [Normalization Form C](http://en.wikipedia.org/wiki/Normalization_Form_C). Returns nil if the string is not valid UTF-8.
---@param s string
---@return string | nil
function UStringService.toNFC(s) end

---Converts the string to [Normalization Form D](http://en.wikipedia.org/wiki/Normalization_Form_D). Returns nil if the string is not valid UTF-8.
---@param s string
---@return string | nil
function UStringService.toNFD(s) end

---Much like [`string.upper()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#string.upper), except that all characters with uppercase to lowercase definitions in Unicode are converted.
---
---If the [Language library](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Language_library) is also loaded, this will instead call [`uc()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.language:uc) on the default language object.
---@param s string
---@return string
function UStringService.upper(s) end

---@class HTMLCreateArgs
local HTMLCreateArgs = {}

---Force the current tag to be self-closing, even if mw.html doesn't recognize it as self-closing
---@type boolean | nil
HTMLCreateArgs.isSelfClosing = true

---Parent of the current mw.html instance (intended for internal usage)
---@type HTML | nil
HTMLCreateArgs.parent = nil

---@class HTML
local HTML = {}

---Appends a child mw.html (`builder`) node to the current mw.html instance.
---@param self HTML
---@param builder HTML
---@return HTML
function HTML.node(self, builder) end

---Appends an undetermined number of wikitext strings to the mw.html object.
---@param self HTML
---@return HTML
function HTML.wikitext(self, ...) end

---Appends a newline to the mw.html object.
---@param self HTML
---@return HTML
function HTML.newline(self) end

---Appends a new child node with the given `tagName` to the builder, and returns a mw.html instance representing that new node. The `args` parameter is identical to that of [`mw.html.create`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.html.create)
---@param self HTML
---@param tagName string | nil
---@param args HTMLCreateArgs | nil
---@return HTML
function HTML.tag(self, tagName, args) end

---Set an HTML attribute with the given `name` and `value` on the node.
---@param self HTML
---@param name string
---@param value any
---@return HTML
function HTML.attr(self, name, value) end

---Get the value of a html attribute previously set using [`html:attr()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.html:attr) with the given `name`.
---@param self HTML
---@param name string
---@return any
function HTML.getAttr(self, name) end

---Adds a class name to the node's class attribute.
---@param self HTML
---@param class string
---@return HTML
function HTML.addClass(self, class) end

---Set a CSS property with the given `name` and `value` on the node.
---@param self HTML
---@param name string
---@param value string
---@return HTML
function HTML.css(self, name, value) end

---Add some raw `css` to the node's style attribute.
---@param self HTML
---@param css string
---@return HTML
function HTML.cssText(self, css) end

---Returns the parent node under which the current node was created. Like jQuery.end, this is a convenience function to allow the construction of several child nodes to be chained together into a single statement.
---@param self HTML
---@return HTML
function HTML.done(self) end

---Like [`html:done()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.html:done), but traverses all the way to the root node of the tree and returns it.
---@param self HTML
---@return HTML
function HTML.allDone(self) end

---@class HTMLService
local HTMLService = {}

---Creates a new mw.html object containing a `tagName` html element. You can also pass an empty string as `tagName` in order to create an empty mw.html object.
---@param tagName string
---@param args HTMLCreateArgs | void
---@return HTML
function HTMLService.create(tagName, args) end

---@class TextService
local TextService = {}

---Replaces [HTML entities](http://en.wikipedia.org/wiki/HTML_entities) in the string with the corresponding characters.
---
---If `decodeNamedEntities` is omitted or false, the only named entities recognized are '&lt;', '&gt;', '&amp;', and '&quot;'. Otherwise, the list of HTML5 named entities to recognize is loaded from PHP's [`get_html_translation_table`](https://www.php.net/get_html_translation_table) function.
---@param s string
---@param decodeNamedEntities boolean | void
---@return string
function TextService.decode(s, decodeNamedEntities) end

---Replaces characters in a string with [HTML](http://en.wikipedia.org/wiki/HTML_entities) entities. Characters '<', '>', '&', '"', and the non-breaking space are replaced with the appropriate named entities; all others are replaced with numeric entities.
---
---If `charset` is supplied, it should be a string as appropriate to go inside brackets in a [Ustring pattern](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_patterns), i.e. the "set" in `[set]`. The default charset is `'<>&"\' '` (the space at the end is the non-breaking space, U+00A0).
---@param s string
---@param charset string | void
---@return string
function TextService.encode(s, charset) end

---Decodes a JSON string. `flags` is 0 or a combination (use `+`) of the flags `mw.text.JSON_PRESERVE_KEYS` and `mw.text.JSON_TRY_FIXING`.
---
---Normally JSON's zero-based arrays are renumbered to Lua one-based sequence tables; to prevent this, pass `mw.text.JSON_PRESERVE_KEYS`.
---
---To relax certain requirements in JSON, such as no terminal comma in arrays or objects, pass `mw.text.JSON_TRY_FIXING`. This is not recommended.
---
---Limitations:
---
---* Decoded JSON arrays may not be Lua sequences if the array contains `null` values.
---* JSON objects will drop keys having `null` values.
---* It is not possible to directly tell whether the input was a JSON array or a JSON object with sequential integer keys.
---* A JSON object having sequential integer keys beginning with 1 will decode to the same table structure as a JSON array with the same values, despite these not being at all equivalent, unless `mw.text.JSON_PRESERVE_KEYS` is used.
---@param s string
---@param flags number | void
---@return table
function TextService.jsonDecode(s, flags) end

---Encode a JSON string. Errors are raised if the passed value cannot be encoded in JSON. `flags` is 0 or a combination (use +) of the flags `mw.text.JSON_PRESERVE_KEYS` and `mw.text.JSON_PRETTY`.
---
---Normally Lua one-based sequence tables are encoded as JSON zero-based arrays; when `mw.text.JSON_PRESERVE_KEYS` is set in `flags`, zero-based sequence tables are encoded as JSON arrays.
---
---Limitations:
---* Empty tables are always encoded as empty arrays (`[]`), not empty objects (`{}`).
---* Sequence tables cannot be encoded as JSON objects without adding a "dummy" element.
---* To produce objects or arrays with `null` values, a tricky implementation of the `__pairs` metamethod is required.
---* A Lua table having sequential integer keys beginning with 0 will encode as a JSON array, the same as a Lua table having integer keys beginning with 1, unless `mw.text.JSON_PRESERVE_KEYS` is used.
---* When both a number and the string representation of that number are used as keys in the same table, behavior is unspecified.
---@param value table
---@param flags number | void
---@return string
function TextService.jsonEncode(value, flags) end

---Removes all MediaWiki strip markers from a string.
---@param s string
---@return string
function TextService.killMarkers(s) end

---Join a list, prose-style. In other words, it's like [table.concat()](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#table.concat) but with a different separator before the final item.
---
---The default separator is taken from [MediaWiki:comma-separator](https://dev.fandom.com/wiki/MediaWiki:Comma-separator) in the wiki's content language, and the default conjuction is [MediaWiki:and](https://dev.fandom.com/wiki/MediaWiki:And) concatenated with [MediaWiki:word-separator](https://dev.fandom.com/wiki/MediaWiki:Word-separator).
---
---Examples, using the default values for the messages:
---
---```lua
---‍-- Returns the empty string
---mw.text.listToText( {} )
---
---‍-- Returns "1"
---mw.text.listToText( { 1 } )
---
---‍-- Returns "1 and 2"
---mw.text.listToText( { 1, 2 } )
---
---‍-- Returns "1, 2, 3, 4 and 5"
---mw.text.listToText( { 1, 2, 3, 4, 5 } )
---
---‍-- Returns "1; 2; 3; 4 or 5"
---mw.text.listToText( { 1, 2, 3, 4, 5 }, '; ', ' or ' )
---```
---
---@param list string[]
---@param separator string | void
---@param conjunction string | void
---@return string
function TextService.listToText(list, separator, conjunction) end

---Replaces various characters in the string with ]HTML entities](http://en.wikipedia.org/wiki/HTML_entities) to prevent their interpretation as wikitext. This includes:
---* The following characters: '"', '&', "'", '<', '=', '>', '[', ']', '{', '|', '}'
---* The following characters at the start of the string or immediately after a newline: '#', '*', ':', ';', space, tab ('\t')
---* Blank lines will have one of the associated newline or carriage return characters escaped
---* "----" at the start of the string or immediately after a newline will have the first '-' escaped
---* "__" will have one underscore escaped
---* "://" will have the colon escaped
---* A whitespace character following "ISBN", "RFC", or "PMID" will be escaped
---@param s string
---@return string
function TextService.nowiki(s) end

---Splits the string into substrings at boundaries matching the [Ustring pattern](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_patterns) `pattern`. If `plain` is specified and true, `pattern` will be interpreted as a literal string rather than as a Lua pattern (just as with the parameter of the same name for [`mw.ustring.find()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.ustring.find)). Returns a table containing the substrings.
---
---For example, `mw.text.split( 'a b\tc\nd', '%s' )` would return a table `{ 'a', 'b', 'c', 'd' }`.
---
---If `pattern` matches the empty string, `s` will be split into individual characters.
---@param s string
---@param pattern string
---@param plain boolean | void
---@return string[]
function TextService.split(s, pattern, plain) end

---Returns an [iterator function](https://dev.fandom.com/wiki/Lua_reference_manual#iterators) that will iterate over the substrings that would be returned by the equivalent call to [`mw.text.split()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.text.split).
---@param s string
---@param pattern string
---@param plain boolean | void
---@return function
function TextService.gsplit(s, pattern, plain) end

---Generates an HTML-style tag for `name`.
---
---If `attrs` is given, it must be a table with string keys. String and number values are used as the value of the attribute; boolean true results in the key being output as an HTML5 valueless parameter; boolean false skips the key entirely; and anything else is an error.
---
---If `content` is not given (or is nil), only the opening tag is returned. If `content` is boolean false, a self-closed tag is returned. Otherwise it must be a string or number, in which case that content is enclosed in the constructed opening and closing tag. Note the content is not automatically HTML-encoded; use [`mw.text.encode()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.text.encode) if needed.
---@param name string
---@param attrs table<string, any> | void
---@param content boolean | void
---@return string
function TextService.tag(name, attrs, content) end

---Remove whitespace or other characters from the beginning and end of a string.
---
---If `charset` is supplied, it should be a string as appropriate to go inside brackets in a [Ustring pattern](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Ustring_patterns), i.e. the "set" in `[set]`. The default charset is ASCII whitespace, "%t%r%n%f ".
---@param s string
---@param charset string | void
---@return string
function TextService.trim(s, charset) end

---Truncates `text` to the specified length, adding `ellipsis` if truncation was performed. If length is positive, the end of the string will be truncated; if negative, the beginning will be removed. If `adjustLength` is given and true, the resulting string including ellipsis will not be longer than the specified length.
---
---The default value for `ellipsis` is taken from [MediaWiki:ellipsis](https://dev.fandom.com/wiki/MediaWiki:Ellipsis) in the wiki's content language.
---
---```lua
---‍-- Returns "foobarbaz"
---mw.text.truncate( "foobarbaz", 9 )
---
---‍-- Returns "fooba..."
---mw.text.truncate( "foobarbaz", 5 )
---
---‍-- Returns "...arbaz"
---mw.text.truncate( "foobarbaz", -5 )
---
---‍-- Returns "foo..."
---mw.text.truncate( "foobarbaz", 6, nil, true )
---
---‍-- Returns "foobarbaz", because that's shorter than "foobarba..."
---mw.text.truncate( "foobarbaz", 8 )
---```
---
---@param text string
---@param length number
---@param ellipsis string | void
---@param adjustLength boolean | void
---@return string
function TextService.truncate(text, length, ellipsis, adjustLength) end

---Replaces MediaWiki strip markers with the corresponding text. Note that the content of the strip marker do not necessarily correspond to the input, nor do they necessarily match the final page output.
---
---**Note that strip markers are typically used for a reason, and replacing them in Lua rather than allowing the parser to do so at the appropriate time may break things.**
---@param s string
---@return string
function TextService.unstrip(s) end

---Replaces MediaWiki `<nowiki>` strip markers with the corresponding text. Other types of strip markers are not changed.
---@param s string
---@return string
function TextService.unstripNoWiki(s) end

---@class Title
local Title = {}

---The page_id. 0 if the page does not exist.
---@type number
Title.id = 0

---The interwiki prefix, or the empty string if none.
---@type string
Title.interwiki = ""

---The namespace number.
---@type number
Title.namespace = 0

---The fragment, or the empty string. May be assigned.
---@type string
Title.fragment = ""

---The text of the namespace for the page.
---@type string
Title.nsText = ""

---The text of the subject namespace for the page.
---@type string
Title.subjectNsText = ""

---The title of the page, without the namespace or interwiki prefixes.
---@type string
Title.text = ""

---The title of the page, with the namespace and interwiki prefixes.
---@type string
Title.prefixedText = ""

---The title of the page, with the namespace and interwiki prefixes and the fragment.
---@type string
Title.fullText = ""

---If this is a subpage, the title of the root page without prefixes. Otherwise, the same as `title.text`.
---@type string
Title.rootText = ""

---If this is a subpage, the title of the page it is a subpage of without prefixes. Otherwise, the same as `title.text`.
---@type string
Title.baseText = ""

---If this is a subpage, just the subpage name. Otherwise, the same as `title.text`.
---@type string
Title.subpageText = ""

---Whether the page for this title could have a talk page.
---@type boolean
Title.canTalk = true

---Whether the page exists. Alias for **fileExists** for Media-namespace titles.
---@type boolean
Title.exists = true

---Whether the file exists. **For File- and Media-namespace titles, this is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit).** It will also be recorded as an image usage for File- and Media-namespace titles.
---@type boolean
Title.fileExists = true

---Whether this title is in a content namespace.
---@type boolean
Title.isContentPage = true

---Whether this title has an interwiki prefix.
---@type boolean
Title.isExternal = true

---Whether this title is in this project. For example, on the English Wikipedia, any other Wikipedia is considered "local" while Wiktionary and such are not.
---@type boolean
Title.isLocal = true

---Whether this is the title for a page that is a redirect.
---@type boolean
Title.isRedirect = true

---Whether this is the title for a possible special page (i.e. a page in the Special: namespace).
---@type boolean
Title.isSpecialPage = true

---Whether this title is a subpage of some other title.
---@type boolean
Title.isSubpage = true

---Whether this is a title for a talk page.
---@type boolean
Title.isTalkPage = true

---Whether this title is a subpage of the given title.
---@param self Title
---@param title2 string | Title
---@return boolean
function Title.isSubpageOf(self, title2) end

---Whether this title is in the given namespace. Namespaces may be specified by anything that is a key found in [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces).
---@param self Title
---@param ns string | number | Namespace
---@return boolean
function Title.inNamespace(self, ns) end

---Whether this title is in any of the given namespaces. Namespaces may be specified by anything that is a key found in [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces).
---@param self Title
---@return boolean
function Title.inNamespaces(self, ...) end

---Whether this title's subject namespace is in the given namespace.  Namespaces may be specified by anything that is a key found in [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces).
---@param self Title
---@param ns string | number | Namespace
---@return boolean
function Title.hasSubjectNamespace(self, ns) end

---The same as `mw.title.makeTitle( title.namespace, title.baseText )`. **This is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**.
---@type string
Title.basePageTitle = ""

---The same as `mw.title.makeTitle( title.namespace, title.rootText )`. **This is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**.
---@type string
Title.rootPageTitle = ""

---The same as `mw.title.makeTitle( mw.site.namespaces[title.namespace].talk.id`, title.text ). **This is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**.
---@type string
Title.talkPageTitle = ""

---The same as `mw.title.makeTitle( mw.site.namespaces[title.namespace].subject.id`, title.text ). **This is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**.
---@type string
Title.subjectPageTitle = ""

---The page's protection levels. This is a table with keys corresponding to each action (e.g., "edit" and "move"). The table values are arrays, the first item of which is a string containing the protection level. If the page is unprotected, either the table values or the array items will be nil. **This is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**.
---@type table<string, any>
Title.protectionLevels = {}

---The same as `mw.title.makeTitle( title.namespace, title.text .. '/' .. text )`. **This is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**.
---@param self Title
---@param text string
---@return Title
function Title.subPageTitle(self, text) end

---Returns `title.text encoded` as it would be in a URL.
---@param self Title
---@return string
function Title.partialUrl(self) end

---Returns the full URL (with optional query table/string) for this title. `proto` may be specified to control the scheme of the resulting url: "http", "https", "relative" (the default), or "canonical".
---@param self Title
---@param query table<string, string> | string | void
---@param proto string | void
---@return string
function Title.fullUrl(self, query, proto) end

---Returns the local URL (with optional query table/string) for this title.
---@param self Title
---@param query table<string, string> | string | void
---@return string
function Title.localUrl(self, query) end

---Returns the canonical URL (with optional query table/string) for this title.
---@param self Title
---@param query table<string, string> | string | void
---@return string
function Title.canonicalUrl(self, query) end

---Returns the (unparsed) content of the page, or nil if there is no page. The page will be recorded as a transclusion.
---@param self Title
---@return string | nil
function Title.getContent(self) end

---@class TitleService
local TitleService = {}

---Test for whether two titles are equal. Note that fragments are ignored in the comparison.
---@param a string | Title
---@param b string | Title
---@return boolean
function TitleService.equals(a, b) end

---Returns -1, 0, or 1 to indicate whether the title `a` is less than, equal to, or greater than title `b`.
---@param a string | Title
---@param b string | Title
---@return number
function TitleService.compare(a, b) end

---Returns the title object for the current page.
---@return Title
function TitleService.getCurrentTitle() end

---**This function is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**
---
---Creates a new title object. The expensive function count will be incremented if the title object created is not for the current page and is not for a title that has already been loaded. The title referenced will be counted as linked from the current page.
---* If a number `id` is given, an object is created for the title with that page_id. If the page_id does not exist, returns nil.
---* If a string `text` is given instead, an object is created for that title (even if the page does not exist). If the text string does not specify a namespace, `namespace` (which may be any key found in [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces)) will be used. If the text is not a valid title, nil is returned.
---@param textOrId string | number
---@param namespace string | number | Namespace
---@return Title | nil
function TitleService.new(textOrId, namespace) end

---**This function is [expensive](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)**
---Creates a title object with title `title` in namespace `namespace`, optionally with the specified `fragment` and `interwiki` prefix. `namespace` may be any key found in [`mw.site.namespaces`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.site.namespaces). If the resulting title is not valid, returns nil. This function is expensive under the same conditions as [mw.title.new()](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.title.new), and records a link just as does `mw.title.new()`.
---
---Note that `mw.title.new( 'Module:Foo', 'Template' )` will create an object for the page Module:Foo, while `mw.title.makeTitle( 'Template', 'Module:Foo' )` will create an object for the page Template:Module:Foo.
---@param namespace string | number | Namespace
---@param title string
---@param fragment string | void
---@param interwiki string | void
---@return Title
function TitleService.makeTitle(namespace, title, fragment, interwiki) end

---@class Message
local Message = {}

---Add parameters to the message, which may be passed as individual arguments. Parameters must be numbers, strings, or the special values returned by [`mw.message.numParam()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message.numParam) or [`mw.message.rawParam()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message.rawParam). If a sequence table is used, parameters must be directly present in the table; references using the [`__index` metamethod](https://dev.fandom.com/wiki/Lua_reference_manual#Metatables) will not work.
---
---Returns the `msg` object, to allow for call chaining.
---@param self Message
---@return Message
function Message.params(self, ...) end

---Like [`:params()](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message:params), but has the effect of passing all the parameters through ]`mw.message.rawParam()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message.rawParam) first.
---
---Returns the `msg` object, to allow for call chaining.
---@param self Message
---@return Message
function Message.rawParams(self, ...) end

---Like [`:params()](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message:params), but has the effect of passing all the parameters through ]`mw.message.numParam()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message.numParam) first.
---
---Returns the `msg` object, to allow for call chaining.
---@param self Message
---@return Message
function Message.numParams(self, ...) end

---Specifies the language to use when processing the message. `lang` may be a string or a table with a g`etCode()` method (i.e. a [Language object](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Language_library)).
---
---The default language is the one returned by [`mw.message.getDefaultLanguage()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message.getDefaultLanguage).
---
---Returns the `msg` object, to allow for call chaining.
---@param self Message
---@param lang string | Language
---@return Message
function Message.inLanguage(self, lang) end

---Specifies whether to look up messages in the MediaWiki: namespace (i.e. look in the database), or just use the default messages distributed with MediaWiki.
---
---The default is true.
---
---Returns the `msg` object, to allow for call chaining.
---@param self Message
---@param bool boolean | void
---@return Message
function Message.useDatabase(self, bool) end

---Substitutes the parameters and returns the message wikitext as-is. Template calls and parser functions are intact.
---@param self Message
---@return string
function Message.plain(self) end

---Returns a boolean indicating whether the message key exists.
---@param self Message
---@return boolean
function Message.exists(self) end

---Returns a boolean indicating whether the message key has content. Returns true if the message key does not exist or the message is the empty string.
---@param self Message
---@return boolean
function Message.isBlank(self) end

---Returns a boolean indicating whether the message key is disabled. Returns true if the message key does not exist or if the message is the empty string or the string "-".
---@param self Message
---@return boolean
function Message.isDisabled(self) end

---@class MessageService
local MessageService = {}

---Creates a new message object for the given message key.
---@param key string
---@return Message
function MessageService.new(key, ...) end

---Creates a new message object for the given messages (the first one that exists will be used).
---@return Message
function MessageService.newFallbackSequence(...) end

---Wraps the value so that it will not be parsed as wikitext by [`msg:parse()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.message:parse).
---@param value string
---@return string
function MessageService.rawParam(value) end

---Wraps the value so that it will automatically be formatted as by [`lang:formatNum()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.language:formatNum). Note this does not depend on the [Language library](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Language_library) actually being available.
---@param value number
---@return string
function MessageService.numParam(value) end

---Returns a Language object for the default language.
---@return Language
function MessageService.getDefaultLanguage() end

---Global "mw" object see [scribunto reference](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries)
mw = {}

---@type Frame
mw.frame = {}

---Calls tostring() on all arguments, then concatenates them with tabs as separators.
---@return string
function mw.allToString(...) end

---Removes all data logged with mw.log().
---@return nil
function mw.clearLogBuffer() end

---Creates a deep copy of a value. All tables (and their metatables) are reconstructed from scratch. Functions are still shared, however.
---@param value any
---@return any
function mw.clone(value) end

---This creates a new copy of the [`frame object`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#Frame_object), calls the function with that as its parameter, then calls [`tostring()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#tostring) on all results and concatenates them (no separator) and returns the resulting string.
---@param func function
---@return string
function mw.executeFunction(func) end

---Executes the function in a sandboxed environment; the function cannot affect anything in the current environment, with the exception of side effects of calling any existing closures.
---
---The name "executeModule" is because this is the function used when a module is loaded from the Module: namespace.
function mw.executeModule(func) end

---Returns the current frame object.
---@return Frame
function mw.getCurrentFrame() end

---Returns the data logged by [`mw.log()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.log), as a string.
---@return string
function mw.getLogBuffer() end

---Adds one to the "expensive parser function" count, and throws an exception if it exceeds the limit (see [$wgExpensiveParserFunctionLimit](http://mediawiki.org/wiki/Manual:$wgExpensiveParserFunctionLimit)).
---@return nil
function mw.incrementExpensiveFunctionCount() end

---Sometimes a module needs large tables of data; for example, a general-purpose module to convert units of measure might need a large table of recognized units and their conversion factors. And sometimes these modules will be used many times in one page. Parsing the large data table for every `{{#invoke:}}` can use a significant amount of time. To avoid this issue, `mw.loadData()` is provided.
---
---`mw.loadData` works like [`require()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#require), with the following differences:
---* The loaded module is evaluated only once per page, rather than once per `{{#invoke:}}` call
---* The loaded module is not recorded in [`package.loaded`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#package.loaded).
---* The value returned from the loaded module must be a table. Other data types are not supported.
---* The returned table (and all subtables) may contain only booleans, numbers, strings, and other tables. Other data types, particularly functions, are not allowed.
---* The returned table (and all subtables) may not have a [metatable](https://dev.fandom.com/wiki/Lua_reference_manual#Metatables).
---* All table keys must be booleans, numbers, or strings.
---* The table actually returned by `mw.loadData()` has metamethods that provide read-only access to the table returned by the module. Since it does not contain the data directly, [`pairs()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#pairs) and [`ipairs()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#ipairs) will work but other methods, including [`#value`](https://dev.fandom.com/wiki/Lua_reference_manual#Length_operator), [`next()`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#next), and the functions in the [`Table library`](https://dev.fandom.com/wiki/Lua_reference_manual/Standard_libraries#Table_library), will not work correctly.
---
---The hypothetical unit-conversion module mentioned above might store its code in "Module:Convert" and its data in "Module:Convert/data", and "Module:Convert" would use `local data = mw.loadData( 'Module:Convert/data' )` to efficiently load the data.
---
---### Global Modules
---
---Modules containing tables can also be retrieved from a global repository ( specifically [dev.fandom.com](https://dev.fandom.com)). This uses a syntax such as:
---
---```lua
---local data = mw.loadData( 'Dev:Convert/data' )
---```
---
---The code above will load a table from a module stored in dev.fandom.com/wiki/Module:Convert/data (if it exists). **Note**: This is **case sensitive**.
---@param module string
---@return table
function mw.loadData(module) end

---Passes the arguments to [`mw.allToString()`](https://dev.fandom.com/wiki/Lua_reference_manual/Scribunto_libraries#mw.allToString), then appends the resulting string to the log buffer.
---@return nil
function mw.log(...) end

---@type LanguageService
mw.language = {}

---@type Site
mw.site = {}

---@type URIService
mw.uri = {}

---@type UStringService
mw.ustring = {}

---@type HTMLService
mw.html = {}

---@type TextService
mw.text = {}

---@type TitleService
mw.title = {}

---@type MessageService
mw.message = {}