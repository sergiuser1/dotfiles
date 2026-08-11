" Neovim's bundled syntax/sql.vim defaults to the Oracle PL/SQL dialect, which
" doesn't know a lot of T-SQL/MSSQL-only vocabulary (TRY/CATCH, THROW, EXEC,
" batch-only types, etc). Rather than fighting dialect selection, just extend
" whichever dialect loaded with the missing T-SQL keywords so real-world MSSQL
" scripts get fuller, more useful colouring.
syn keyword sqlStatement exec execute throw raiserror waitfor print merge
syn keyword sqlKeyword try catch transaction output identity nocount goto
syn keyword sqlType datetime2 datetimeoffset nvarchar varbinary uniqueidentifier
syn keyword sqlType sql_variant bigint tinyint bit money smallmoney image xml

" `GO` is a batch separator recognised by client tools (sqlcmd/SSMS), not a
" real T-SQL keyword, so it needs its own rule rather than `syn keyword`.
syn match sqlGo /^\s*GO\s*$/
hi def link sqlGo PreProc
