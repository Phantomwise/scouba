module AnsiColorLite
	( AnsiColor8(..)
	, ansi
	) where

-- Define a data type for colors
data AnsiColor8 = Black | Red | Green | Yellow | Blue | Magenta | Cyan | White | Reset
	deriving (Eq, Enum, Show)

-- Map to ANSI color codes
ansi :: AnsiColor8 -> String
ansi Black   = "\x1b[30m"
ansi Red     = "\x1b[31m"
ansi Green   = "\x1b[32m"
ansi Yellow  = "\x1b[33m"
ansi Blue    = "\x1b[34m"
ansi Magenta = "\x1b[35m"
ansi Cyan    = "\x1b[36m"
ansi White   = "\x1b[37m"
ansi Reset   = "\x1b[0m"
