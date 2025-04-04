Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C4C17A2E1
	for <linux-trace-devel@vger.kernel.org>; Fri,  4 Apr 2025 16:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783239; cv=none; b=qDgZ+tkdt5hTXOI7nxfDDe/hXhZugGzl0mKOpfA3czD5cVZGPRw7HjcN3dkEoGy223LMc4pds5sPXFt7AM+HvuSyd+yI9GNDJl5CAH5vAtyRKu23Wh9/p9iWPbQ9ZUsy3IsfT6qmZaI4R34XbDHn1bXqigwQfBalQVQvmUtscR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783239; c=relaxed/simple;
	bh=XyfEHZw9aFokYWDvhC6YMGqqqmYcIsuMAc8B3DEMwg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3cPqNg/My1W1/c3EtG95bw8d/Pho7u9a4Ov2oboSdKYYyYaxx6zsEJKWZnj9kunSKUwgIgSDQU7Wfkeirqi2Na0irrLhs1WASRnTen3gDbMOUyMIHUCLxb/nE0cZujQf0lx70UaQmVpm38r10C2Jt5fBxPUK9PLil/sIjwPugU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBC9C4CEEA;
	Fri,  4 Apr 2025 16:13:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1u0jhC-000000070wb-18KH;
	Fri, 04 Apr 2025 12:15:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Oleh Matiusha <omatiush@cisco.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Rerun bison and flex via make sqlhist_remake
Date: Fri,  4 Apr 2025 12:12:11 -0400
Message-ID: <20250404161504.1671790-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250404161504.1671790-1-rostedt@goodmis.org>
References: <20250404161504.1671790-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Update the bison and flex code with the latest bison and flex from Debian.
This uses the new make sqlhist_remake option and includes the added
comments that were added to sqlhist.y and sqlhist.l.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/sqlhist-lex.c |  66 +++---
 src/sqlhist.tab.c | 504 +++++++++++++++++++---------------------------
 src/sqlhist.tab.h |  14 +-
 3 files changed, 248 insertions(+), 336 deletions(-)

diff --git a/src/sqlhist-lex.c b/src/sqlhist-lex.c
index aaea71c35c98..d6342c5ee7d6 100644
--- a/src/sqlhist-lex.c
+++ b/src/sqlhist-lex.c
@@ -1,6 +1,6 @@
-#line 1 "sqlhist-lex.c"
+#line 2 "sqlhist-lex.c"
 
-#line 3 "sqlhist-lex.c"
+#line 4 "sqlhist-lex.c"
 
 #define  YY_INT_ALIGNED short int
 
@@ -506,6 +506,8 @@ static const flex_int16_t yy_chk[234] =
 #line 2 "sqlhist.l"
 /* code here */
 
+/* If you change this file, run: make sqlhist_remake */
+
 #include <stdarg.h>
 #include "sqlhist-parse.h"
 
@@ -524,8 +526,8 @@ extern int tfs_my_yyinput(void *extra, char *buf, int max);
 #define TRACE_SB	((struct sqlhist_bison *)yyextra)
 #define HANDLE_COLUMN do { TRACE_SB->line_idx += strlen(yytext); } while (0)
 
-#line 527 "sqlhist-lex.c"
-#line 528 "sqlhist-lex.c"
+#line 530 "sqlhist-lex.c"
+#line 531 "sqlhist-lex.c"
 
 #define INITIAL 0
 
@@ -799,10 +801,10 @@ YY_DECL
 		}
 
 	{
-#line 33 "sqlhist.l"
+#line 35 "sqlhist.l"
 
 
-#line 805 "sqlhist-lex.c"
+#line 808 "sqlhist-lex.c"
 
 	while ( /*CONSTCOND*/1 )		/* loops until end-of-file is reached */
 		{
@@ -861,42 +863,42 @@ do_action:	/* This label is used only to access EOF actions. */
 
 case 1:
 YY_RULE_SETUP
-#line 35 "sqlhist.l"
+#line 37 "sqlhist.l"
 { HANDLE_COLUMN; return SELECT; }
 	YY_BREAK
 case 2:
 YY_RULE_SETUP
-#line 36 "sqlhist.l"
+#line 38 "sqlhist.l"
 { HANDLE_COLUMN; return AS; }
 	YY_BREAK
 case 3:
 YY_RULE_SETUP
-#line 37 "sqlhist.l"
+#line 39 "sqlhist.l"
 { HANDLE_COLUMN; return FROM; }
 	YY_BREAK
 case 4:
 YY_RULE_SETUP
-#line 38 "sqlhist.l"
+#line 40 "sqlhist.l"
 { HANDLE_COLUMN; return JOIN; }
 	YY_BREAK
 case 5:
 YY_RULE_SETUP
-#line 39 "sqlhist.l"
+#line 41 "sqlhist.l"
 { HANDLE_COLUMN; return ON; }
 	YY_BREAK
 case 6:
 YY_RULE_SETUP
-#line 40 "sqlhist.l"
+#line 42 "sqlhist.l"
 { HANDLE_COLUMN; return WHERE; }
 	YY_BREAK
 case 7:
 YY_RULE_SETUP
-#line 41 "sqlhist.l"
+#line 43 "sqlhist.l"
 { HANDLE_COLUMN; return CAST; }
 	YY_BREAK
 case 8:
 YY_RULE_SETUP
-#line 43 "sqlhist.l"
+#line 45 "sqlhist.l"
 {
 	HANDLE_COLUMN;
 	yylval->string = tfs_store_str(TRACE_SB, yyg->yytext_r);
@@ -906,7 +908,7 @@ YY_RULE_SETUP
 case 9:
 /* rule 9 can match eol */
 YY_RULE_SETUP
-#line 49 "sqlhist.l"
+#line 51 "sqlhist.l"
 {
 	HANDLE_COLUMN;
 	yylval->string = tfs_store_str(TRACE_SB, yyg->yytext_r);
@@ -915,7 +917,7 @@ YY_RULE_SETUP
 	YY_BREAK
 case 10:
 YY_RULE_SETUP
-#line 55 "sqlhist.l"
+#line 57 "sqlhist.l"
 {
 	const char *str = yyg->yytext_r;
 	HANDLE_COLUMN;
@@ -926,7 +928,7 @@ YY_RULE_SETUP
 	YY_BREAK
 case 11:
 YY_RULE_SETUP
-#line 63 "sqlhist.l"
+#line 65 "sqlhist.l"
 {
 	HANDLE_COLUMN;
 	yylval->number = strtol(yyg->yytext_r, NULL, 0);
@@ -935,7 +937,7 @@ YY_RULE_SETUP
 	YY_BREAK
 case 12:
 YY_RULE_SETUP
-#line 69 "sqlhist.l"
+#line 71 "sqlhist.l"
 {
 	HANDLE_COLUMN;
 	yylval->number = strtol(yyg->yytext_r, NULL, 0);
@@ -944,66 +946,66 @@ YY_RULE_SETUP
 	YY_BREAK
 case 13:
 YY_RULE_SETUP
-#line 75 "sqlhist.l"
+#line 77 "sqlhist.l"
 { HANDLE_COLUMN; return NEQ; }
 	YY_BREAK
 case 14:
 YY_RULE_SETUP
-#line 76 "sqlhist.l"
+#line 78 "sqlhist.l"
 { HANDLE_COLUMN; return LE; }
 	YY_BREAK
 case 15:
 YY_RULE_SETUP
-#line 77 "sqlhist.l"
+#line 79 "sqlhist.l"
 { HANDLE_COLUMN; return GE; }
 	YY_BREAK
 case 16:
 YY_RULE_SETUP
-#line 78 "sqlhist.l"
+#line 80 "sqlhist.l"
 { HANDLE_COLUMN; return EQ; }
 	YY_BREAK
 case 17:
 YY_RULE_SETUP
-#line 79 "sqlhist.l"
+#line 81 "sqlhist.l"
 { HANDLE_COLUMN; return AND; }
 	YY_BREAK
 case 18:
 YY_RULE_SETUP
-#line 80 "sqlhist.l"
+#line 82 "sqlhist.l"
 { HANDLE_COLUMN; return OR; }
 	YY_BREAK
 case 19:
 YY_RULE_SETUP
-#line 81 "sqlhist.l"
+#line 83 "sqlhist.l"
 { HANDLE_COLUMN; return yytext[0]; }
 	YY_BREAK
 case 20:
 YY_RULE_SETUP
-#line 83 "sqlhist.l"
+#line 85 "sqlhist.l"
 { HANDLE_COLUMN; return yytext[0]; }
 	YY_BREAK
 case 21:
 YY_RULE_SETUP
-#line 85 "sqlhist.l"
+#line 87 "sqlhist.l"
 { HANDLE_COLUMN; }
 	YY_BREAK
 case 22:
 /* rule 22 can match eol */
 YY_RULE_SETUP
-#line 86 "sqlhist.l"
+#line 88 "sqlhist.l"
 { TRACE_SB->line_idx = 0; TRACE_SB->line_no++; }
 	YY_BREAK
 case 23:
 YY_RULE_SETUP
-#line 88 "sqlhist.l"
+#line 90 "sqlhist.l"
 { HANDLE_COLUMN; return PARSE_ERROR; }
 	YY_BREAK
 case 24:
 YY_RULE_SETUP
-#line 89 "sqlhist.l"
+#line 91 "sqlhist.l"
 ECHO;
 	YY_BREAK
-#line 1006 "sqlhist-lex.c"
+#line 1009 "sqlhist-lex.c"
 case YY_STATE_EOF(INITIAL):
 	yyterminate();
 
@@ -2184,7 +2186,7 @@ void yyfree (void * ptr , yyscan_t yyscanner)
 
 #define YYTABLES_NAME "yytables"
 
-#line 89 "sqlhist.l"
+#line 91 "sqlhist.l"
 
 
 int yywrap(void *data)
diff --git a/src/sqlhist.tab.c b/src/sqlhist.tab.c
index 4088519e26be..a53f8e1d4c89 100644
--- a/src/sqlhist.tab.c
+++ b/src/sqlhist.tab.c
@@ -1,8 +1,8 @@
-/* A Bison parser, made by GNU Bison 3.6.4.  */
+/* A Bison parser, made by GNU Bison 3.8.2.  */
 
 /* Bison implementation for Yacc-like parsers in C
 
-   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
+   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
    Inc.
 
    This program is free software: you can redistribute it and/or modify
@@ -16,7 +16,7 @@
    GNU General Public License for more details.
 
    You should have received a copy of the GNU General Public License
-   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */
 
 /* As a special exception, you may create a larger work that contains
    part or all of the Bison parser skeleton and distribute that work
@@ -45,11 +45,11 @@
    define necessary library symbols; they are noted "INFRINGES ON
    USER NAME SPACE" below.  */
 
-/* Identify Bison output.  */
-#define YYBISON 1
+/* Identify Bison output, and Bison version.  */
+#define YYBISON 30802
 
-/* Bison version.  */
-#define YYBISON_VERSION "3.6.4"
+/* Bison version string.  */
+#define YYBISON_VERSION "3.8.2"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -75,6 +75,7 @@
 /* First part of user prologue.  */
 #line 1 "sqlhist.y"
 
+/* If you change this file, run: make sqlhist_remake */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -104,7 +105,7 @@ extern void yyerror(struct sqlhist_bison *, char *fmt, ...);
 	} while (0)
 
 
-#line 108 "sqlhist.tab.c"
+#line 109 "sqlhist.tab.c"
 
 # ifndef YY_CAST
 #  ifdef __cplusplus
@@ -127,89 +128,7 @@ extern void yyerror(struct sqlhist_bison *, char *fmt, ...);
 #  endif
 # endif
 
-/* Use api.header.include to #include this header
-   instead of duplicating it here.  */
-#ifndef YY_TRACEFS_SQLHIST_TAB_H_INCLUDED
-# define YY_TRACEFS_SQLHIST_TAB_H_INCLUDED
-/* Debug traces.  */
-#ifndef TRACEFS_DEBUG
-# if defined YYDEBUG
-#if YYDEBUG
-#   define TRACEFS_DEBUG 1
-#  else
-#   define TRACEFS_DEBUG 0
-#  endif
-# else /* ! defined YYDEBUG */
-#  define TRACEFS_DEBUG 1
-# endif /* ! defined YYDEBUG */
-#endif  /* ! defined TRACEFS_DEBUG */
-#if TRACEFS_DEBUG
-extern int tracefs_debug;
-#endif
-
-/* Token kinds.  */
-#ifndef TRACEFS_TOKENTYPE
-# define TRACEFS_TOKENTYPE
-  enum tracefs_tokentype
-  {
-    TRACEFS_EMPTY = -2,
-    TRACEFS_EOF = 0,               /* "end of file"  */
-    TRACEFS_error = 256,           /* error  */
-    TRACEFS_UNDEF = 257,           /* "invalid token"  */
-    AS = 258,                      /* AS  */
-    SELECT = 259,                  /* SELECT  */
-    FROM = 260,                    /* FROM  */
-    JOIN = 261,                    /* JOIN  */
-    ON = 262,                      /* ON  */
-    WHERE = 263,                   /* WHERE  */
-    PARSE_ERROR = 264,             /* PARSE_ERROR  */
-    CAST = 265,                    /* CAST  */
-    NUMBER = 266,                  /* NUMBER  */
-    field_type = 267,              /* field_type  */
-    STRING = 268,                  /* STRING  */
-    FIELD = 269,                   /* FIELD  */
-    LE = 270,                      /* LE  */
-    GE = 271,                      /* GE  */
-    EQ = 272,                      /* EQ  */
-    NEQ = 273,                     /* NEQ  */
-    AND = 274,                     /* AND  */
-    OR = 275                       /* OR  */
-  };
-  typedef enum tracefs_tokentype tracefs_token_kind_t;
-#endif
-
-/* Value type.  */
-#if ! defined TRACEFS_STYPE && ! defined TRACEFS_STYPE_IS_DECLARED
-union TRACEFS_STYPE
-{
-#line 46 "sqlhist.y"
-
-	int	s32;
-	char	*string;
-	long	number;
-	void	*expr;
-
-#line 193 "sqlhist.tab.c"
-
-};
-typedef union TRACEFS_STYPE TRACEFS_STYPE;
-# define TRACEFS_STYPE_IS_TRIVIAL 1
-# define TRACEFS_STYPE_IS_DECLARED 1
-#endif
-
-
-
-int tracefs_parse (struct sqlhist_bison *sb);
-/* "%code provides" blocks.  */
-#line 37 "sqlhist.y"
-
-  #define YYSTYPE TRACEFS_STYPE
-  #define yylex tracefs_lex
-  #define yyerror tracefs_error
-
-#line 211 "sqlhist.tab.c"
-
-#endif /* !YY_TRACEFS_SQLHIST_TAB_H_INCLUDED  */
+#include "sqlhist.tab.h"
 /* Symbol kind.  */
 enum yysymbol_kind_t
 {
@@ -320,6 +239,18 @@ typedef int_least16_t yytype_int16;
 typedef short yytype_int16;
 #endif
 
+/* Work around bug in HP-UX 11.23, which defines these macros
+   incorrectly for preprocessor constants.  This workaround can likely
+   be removed in 2023, as HPE has promised support for HP-UX 11.23
+   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
+   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
+#ifdef __hpux
+# undef UINT_LEAST8_MAX
+# undef UINT_LEAST16_MAX
+# define UINT_LEAST8_MAX 255
+# define UINT_LEAST16_MAX 65535
+#endif
+
 #if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
 typedef __UINT_LEAST8_TYPE__ yytype_uint8;
 #elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
@@ -417,17 +348,23 @@ typedef int yy_state_fast_t;
 
 /* Suppress unused-variable warnings by "using" E.  */
 #if ! defined lint || defined __GNUC__
-# define YYUSE(E) ((void) (E))
+# define YY_USE(E) ((void) (E))
 #else
-# define YYUSE(E) /* empty */
+# define YY_USE(E) /* empty */
 #endif
 
-#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
 /* Suppress an incorrect diagnostic about yylval being uninitialized.  */
-# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
+#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
+# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
+#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
+    _Pragma ("GCC diagnostic push")                                     \
+    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
+# else
+#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
     _Pragma ("GCC diagnostic push")                                     \
     _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
     _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
+# endif
 # define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
     _Pragma ("GCC diagnostic pop")
 #else
@@ -597,6 +534,7 @@ union yyalloc
 /* YYNSTATES -- Number of states.  */
 #define YYNSTATES  111
 
+/* YYMAXUTOK -- Last valid token kind.  */
 #define YYMAXUTOK   276
 
 
@@ -642,16 +580,16 @@ static const yytype_int8 yytranslate[] =
 };
 
 #if TRACEFS_DEBUG
-  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
+/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
 static const yytype_uint8 yyrline[] =
 {
-       0,    75,    75,    78,    79,    82,    86,    90,    91,    95,
-      99,   106,   107,   108,   109,   110,   117,   122,   130,   131,
-     135,   139,   143,   147,   151,   152,   157,   158,   159,   160,
-     161,   162,   163,   164,   165,   166,   170,   171,   172,   173,
-     174,   178,   179,   180,   181,   182,   186,   195,   196,   197,
-     201,   204,   206,   209,   211,   215,   219,   234,   238,   239,
-     244,   245
+       0,    76,    76,    79,    80,    83,    87,    91,    92,    96,
+     100,   107,   108,   109,   110,   111,   118,   123,   131,   132,
+     136,   140,   144,   148,   152,   153,   158,   159,   160,   161,
+     162,   163,   164,   165,   166,   167,   171,   172,   173,   174,
+     175,   179,   180,   181,   182,   183,   187,   196,   197,   198,
+     202,   205,   207,   210,   212,   216,   220,   235,   239,   240,
+     245,   246
 };
 #endif
 
@@ -686,18 +624,6 @@ yysymbol_name (yysymbol_kind_t yysymbol)
 }
 #endif
 
-#ifdef YYPRINT
-/* YYTOKNUM[NUM] -- (External) token number corresponding to the
-   (internal) symbol number NUM (which must be that of a token).  */
-static const yytype_int16 yytoknum[] =
-{
-       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
-     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
-     275,    43,    45,    42,    47,    60,    62,    44,    40,    41,
-      61,   276,    38,   126,    33
-};
-#endif
-
 #define YYPACT_NINF (-58)
 
 #define yypact_value_is_default(Yyn) \
@@ -708,8 +634,8 @@ static const yytype_int16 yytoknum[] =
 #define yytable_value_is_error(Yyn) \
   0
 
-  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
-     STATE-NUM.  */
+/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
+   STATE-NUM.  */
 static const yytype_int8 yypact[] =
 {
        4,   -58,    13,    11,   -58,   -58,     5,   -58,    43,    53,
@@ -726,9 +652,9 @@ static const yytype_int8 yypact[] =
      -58
 };
 
-  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
-     Performed when YYTABLE does not specify something else to do.  Zero
-     means the default is an error.  */
+/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
+   Performed when YYTABLE does not specify something else to do.  Zero
+   means the default is an error.  */
 static const yytype_int8 yydefact[] =
 {
        0,     5,     0,     0,     2,     1,     0,    20,     0,     0,
@@ -745,7 +671,7 @@ static const yytype_int8 yydefact[] =
       38
 };
 
-  /* YYPGOTO[NTERM-NUM].  */
+/* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
      -58,   -58,    69,   -58,   -58,    80,   -58,   -58,    90,   -16,
@@ -753,17 +679,17 @@ static const yytype_int8 yypgoto[] =
      -58,   -58,   -58,   -58,   -58,   -58,   -58,    24
 };
 
-  /* YYDEFGOTO[NTERM-NUM].  */
+/* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
-      -1,     2,    23,     3,     4,     9,    10,    11,    12,    57,
+       0,     2,    23,     3,     4,     9,    10,    11,    12,    57,
       51,    33,    24,    89,    90,    61,    62,    53,    54,    55,
       45,    46,    35,    18,    19,    36,    58,    59
 };
 
-  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
-     positive, shift that token.  If negative, reduce the rule whose
-     number is the opposite.  If YYTABLE_NINF, syntax error.  */
+/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
+   positive, shift that token.  If negative, reduce the rule whose
+   number is the opposite.  If YYTABLE_NINF, syntax error.  */
 static const yytype_int8 yytable[] =
 {
       13,    31,     7,    52,    76,    16,    86,    78,     1,    64,
@@ -794,8 +720,8 @@ static const yytype_int8 yycheck[] =
       20,    74,    21,    75,    80
 };
 
-  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
-     symbol of state STATE-NUM.  */
+/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
+   state STATE-NUM.  */
 static const yytype_int8 yystos[] =
 {
        0,     4,    36,    38,    39,     0,    10,    14,    28,    40,
@@ -812,7 +738,7 @@ static const yytype_int8 yystos[] =
       29
 };
 
-  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
+/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
 static const yytype_int8 yyr1[] =
 {
        0,    35,    36,    37,    37,    38,    39,    40,    40,    41,
@@ -824,7 +750,7 @@ static const yytype_int8 yyr1[] =
       62,    62
 };
 
-  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
+/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
 static const yytype_int8 yyr2[] =
 {
        0,     2,     1,     2,     1,     1,     3,     1,     3,     1,
@@ -845,6 +771,7 @@ enum { YYENOMEM = -2 };
 #define YYACCEPT        goto yyacceptlab
 #define YYABORT         goto yyabortlab
 #define YYERROR         goto yyerrorlab
+#define YYNOMEM         goto yyexhaustedlab
 
 
 #define YYRECOVERING()  (!!yyerrstatus)
@@ -885,10 +812,7 @@ do {                                            \
     YYFPRINTF Args;                             \
 } while (0)
 
-/* This macro is provided for backward compatibility. */
-# ifndef YY_LOCATION_PRINT
-#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
-# endif
+
 
 
 # define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
@@ -912,16 +836,12 @@ yy_symbol_value_print (FILE *yyo,
                        yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep, struct sqlhist_bison *sb)
 {
   FILE *yyoutput = yyo;
-  YYUSE (yyoutput);
-  YYUSE (sb);
+  YY_USE (yyoutput);
+  YY_USE (sb);
   if (!yyvaluep)
     return;
-# ifdef YYPRINT
-  if (yykind < YYNTOKENS)
-    YYPRINT (yyo, yytoknum[yykind], *yyvaluep);
-# endif
   YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
-  YYUSE (yykind);
+  YY_USE (yykind);
   YY_IGNORE_MAYBE_UNINITIALIZED_END
 }
 
@@ -1035,14 +955,14 @@ static void
 yydestruct (const char *yymsg,
             yysymbol_kind_t yykind, YYSTYPE *yyvaluep, struct sqlhist_bison *sb)
 {
-  YYUSE (yyvaluep);
-  YYUSE (sb);
+  YY_USE (yyvaluep);
+  YY_USE (sb);
   if (!yymsg)
     yymsg = "Deleting";
   YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);
 
   YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
-  YYUSE (yykind);
+  YY_USE (yykind);
   YY_IGNORE_MAYBE_UNINITIALIZED_END
 }
 
@@ -1058,7 +978,7 @@ yydestruct (const char *yymsg,
 int
 yyparse (struct sqlhist_bison *sb)
 {
-/* The lookahead symbol.  */
+/* Lookahead token kind.  */
 int yychar;
 
 
@@ -1069,36 +989,32 @@ YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
 YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);
 
     /* Number of syntax errors so far.  */
-    int yynerrs;
+    int yynerrs = 0;
 
-    yy_state_fast_t yystate;
+    yy_state_fast_t yystate = 0;
     /* Number of tokens to shift before error messages enabled.  */
-    int yyerrstatus;
+    int yyerrstatus = 0;
 
-    /* The stacks and their tools:
-       'yyss': related to states.
-       'yyvs': related to semantic values.
-
-       Refer to the stacks through separate pointers, to allow yyoverflow
+    /* Refer to the stacks through separate pointers, to allow yyoverflow
        to reallocate them elsewhere.  */
 
     /* Their size.  */
-    YYPTRDIFF_T yystacksize;
+    YYPTRDIFF_T yystacksize = YYINITDEPTH;
 
-    /* The state stack.  */
+    /* The state stack: array, bottom, top.  */
     yy_state_t yyssa[YYINITDEPTH];
-    yy_state_t *yyss;
-    yy_state_t *yyssp;
+    yy_state_t *yyss = yyssa;
+    yy_state_t *yyssp = yyss;
 
-    /* The semantic value stack.  */
+    /* The semantic value stack: array, bottom, top.  */
     YYSTYPE yyvsa[YYINITDEPTH];
-    YYSTYPE *yyvs;
-    YYSTYPE *yyvsp;
+    YYSTYPE *yyvs = yyvsa;
+    YYSTYPE *yyvsp = yyvs;
 
   int yyn;
   /* The return value of yyparse.  */
   int yyresult;
-  /* Lookahead token as an internal (translated) token number.  */
+  /* Lookahead symbol kind.  */
   yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
   /* The variables used to return semantic value and location from the
      action routines.  */
@@ -1112,18 +1028,10 @@ YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);
      Keep to zero when no symbol should be popped.  */
   int yylen = 0;
 
-  yynerrs = 0;
-  yystate = 0;
-  yyerrstatus = 0;
-
-  yystacksize = YYINITDEPTH;
-  yyssp = yyss = yyssa;
-  yyvsp = yyvs = yyvsa;
-
-
   YYDPRINTF ((stderr, "Starting parse\n"));
 
   yychar = TRACEFS_EMPTY; /* Cause a token to be read.  */
+
   goto yysetstate;
 
 
@@ -1149,7 +1057,7 @@ yysetstate:
 
   if (yyss + yystacksize - 1 <= yyssp)
 #if !defined yyoverflow && !defined YYSTACK_RELOCATE
-    goto yyexhaustedlab;
+    YYNOMEM;
 #else
     {
       /* Get the current used size of the three stacks, in elements.  */
@@ -1177,7 +1085,7 @@ yysetstate:
 # else /* defined YYSTACK_RELOCATE */
       /* Extend the stack our own way.  */
       if (YYMAXDEPTH <= yystacksize)
-        goto yyexhaustedlab;
+        YYNOMEM;
       yystacksize *= 2;
       if (YYMAXDEPTH < yystacksize)
         yystacksize = YYMAXDEPTH;
@@ -1188,7 +1096,7 @@ yysetstate:
           YY_CAST (union yyalloc *,
                    YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
         if (! yyptr)
-          goto yyexhaustedlab;
+          YYNOMEM;
         YYSTACK_RELOCATE (yyss_alloc, yyss);
         YYSTACK_RELOCATE (yyvs_alloc, yyvs);
 #  undef YYSTACK_RELOCATE
@@ -1210,6 +1118,7 @@ yysetstate:
     }
 #endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */
 
+
   if (yystate == YYFINAL)
     YYACCEPT;
 
@@ -1321,243 +1230,243 @@ yyreduce:
   YY_REDUCE_PRINT (yyn);
   switch (yyn)
     {
-  case 3:
-#line 78 "sqlhist.y"
+  case 3: /* label: AS name  */
+#line 79 "sqlhist.y"
                 { CHECK_RETURN_PTR((yyval.string) = tfs_store_str(sb, (yyvsp[0].string))); }
-#line 1328 "sqlhist.tab.c"
+#line 1237 "sqlhist.tab.c"
     break;
 
-  case 4:
-#line 79 "sqlhist.y"
+  case 4: /* label: name  */
+#line 80 "sqlhist.y"
         { CHECK_RETURN_PTR((yyval.string) = tfs_store_str(sb, (yyvsp[0].string))); }
-#line 1334 "sqlhist.tab.c"
+#line 1243 "sqlhist.tab.c"
     break;
 
-  case 5:
-#line 82 "sqlhist.y"
+  case 5: /* select: SELECT  */
+#line 83 "sqlhist.y"
                  { tfs_table_start(sb); }
-#line 1340 "sqlhist.tab.c"
+#line 1249 "sqlhist.tab.c"
     break;
 
-  case 9:
-#line 96 "sqlhist.y"
+  case 9: /* selection: selection_expr  */
+#line 97 "sqlhist.y"
                                 {
 					CHECK_RETURN_VAL(tfs_add_selection(sb, (yyvsp[0].expr), NULL));
 				}
-#line 1348 "sqlhist.tab.c"
+#line 1257 "sqlhist.tab.c"
     break;
 
-  case 10:
-#line 100 "sqlhist.y"
+  case 10: /* selection: selection_expr label  */
+#line 101 "sqlhist.y"
                                 {
 					CHECK_RETURN_VAL(tfs_add_selection(sb, (yyvsp[-1].expr), (yyvsp[0].string)));
 				}
-#line 1356 "sqlhist.tab.c"
+#line 1265 "sqlhist.tab.c"
     break;
 
-  case 12:
-#line 107 "sqlhist.y"
+  case 12: /* selection_expr: '(' field ')'  */
+#line 108 "sqlhist.y"
                                 {  (yyval.expr) = (yyvsp[-1].expr); }
-#line 1362 "sqlhist.tab.c"
+#line 1271 "sqlhist.tab.c"
     break;
 
-  case 14:
-#line 109 "sqlhist.y"
+  case 14: /* selection_expr: '(' selection_addition ')'  */
+#line 110 "sqlhist.y"
                                 {  (yyval.expr) = (yyvsp[-1].expr); }
-#line 1368 "sqlhist.tab.c"
+#line 1277 "sqlhist.tab.c"
     break;
 
-  case 15:
-#line 110 "sqlhist.y"
+  case 15: /* selection_expr: CAST '(' field AS FIELD ')'  */
+#line 111 "sqlhist.y"
                                 {
 					 (yyval.expr) = tfs_add_cast(sb, (yyvsp[-3].expr), (yyvsp[-1].string));
 					 CHECK_RETURN_PTR((yyval.expr));
 				}
-#line 1377 "sqlhist.tab.c"
+#line 1286 "sqlhist.tab.c"
     break;
 
-  case 16:
-#line 118 "sqlhist.y"
+  case 16: /* selection_addition: field '+' field  */
+#line 119 "sqlhist.y"
                                 {
 					(yyval.expr) = tfs_add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_ADD);
 					CHECK_RETURN_PTR((yyval.expr));
 				}
-#line 1386 "sqlhist.tab.c"
+#line 1295 "sqlhist.tab.c"
     break;
 
-  case 17:
-#line 123 "sqlhist.y"
+  case 17: /* selection_addition: field '-' field  */
+#line 124 "sqlhist.y"
                                 {
 					(yyval.expr) = tfs_add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_SUB);
 					CHECK_RETURN_PTR((yyval.expr));
 				}
-#line 1395 "sqlhist.tab.c"
+#line 1304 "sqlhist.tab.c"
     break;
 
-  case 20:
-#line 135 "sqlhist.y"
+  case 20: /* field: FIELD  */
+#line 136 "sqlhist.y"
                 { (yyval.expr) = tfs_add_field(sb, (yyvsp[0].string), NULL); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1401 "sqlhist.tab.c"
+#line 1310 "sqlhist.tab.c"
     break;
 
-  case 21:
-#line 139 "sqlhist.y"
+  case 21: /* named_field: FIELD label  */
+#line 140 "sqlhist.y"
                { (yyval.expr) = tfs_add_field(sb, (yyvsp[-1].string), (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1407 "sqlhist.tab.c"
+#line 1316 "sqlhist.tab.c"
     break;
 
-  case 23:
-#line 147 "sqlhist.y"
+  case 23: /* str_val: STRING  */
+#line 148 "sqlhist.y"
                 { (yyval.expr) = tfs_add_string(sb, (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1413 "sqlhist.tab.c"
+#line 1322 "sqlhist.tab.c"
     break;
 
-  case 25:
-#line 152 "sqlhist.y"
+  case 25: /* val: NUMBER  */
+#line 153 "sqlhist.y"
                 { (yyval.expr) = tfs_add_number(sb, (yyvsp[0].number)); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1419 "sqlhist.tab.c"
+#line 1328 "sqlhist.tab.c"
     break;
 
-  case 26:
-#line 157 "sqlhist.y"
+  case 26: /* compare: field '<' val  */
+#line 158 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LT); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1425 "sqlhist.tab.c"
+#line 1334 "sqlhist.tab.c"
     break;
 
-  case 27:
-#line 158 "sqlhist.y"
+  case 27: /* compare: field '>' val  */
+#line 159 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GT); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1431 "sqlhist.tab.c"
+#line 1340 "sqlhist.tab.c"
     break;
 
-  case 28:
-#line 159 "sqlhist.y"
+  case 28: /* compare: field LE val  */
+#line 160 "sqlhist.y"
                 { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1437 "sqlhist.tab.c"
+#line 1346 "sqlhist.tab.c"
     break;
 
-  case 29:
-#line 160 "sqlhist.y"
+  case 29: /* compare: field GE val  */
+#line 161 "sqlhist.y"
                 { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1443 "sqlhist.tab.c"
+#line 1352 "sqlhist.tab.c"
     break;
 
-  case 30:
-#line 161 "sqlhist.y"
+  case 30: /* compare: field '=' val  */
+#line 162 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1449 "sqlhist.tab.c"
+#line 1358 "sqlhist.tab.c"
     break;
 
-  case 31:
-#line 162 "sqlhist.y"
+  case 31: /* compare: field EQ val  */
+#line 163 "sqlhist.y"
                 { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1455 "sqlhist.tab.c"
+#line 1364 "sqlhist.tab.c"
     break;
 
-  case 32:
-#line 163 "sqlhist.y"
+  case 32: /* compare: field NEQ val  */
+#line 164 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1461 "sqlhist.tab.c"
+#line 1370 "sqlhist.tab.c"
     break;
 
-  case 33:
-#line 164 "sqlhist.y"
+  case 33: /* compare: field "!=" val  */
+#line 165 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1467 "sqlhist.tab.c"
+#line 1376 "sqlhist.tab.c"
     break;
 
-  case 34:
-#line 165 "sqlhist.y"
+  case 34: /* compare: field '&' val  */
+#line 166 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_BIN_AND); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1473 "sqlhist.tab.c"
+#line 1382 "sqlhist.tab.c"
     break;
 
-  case 35:
-#line 166 "sqlhist.y"
+  case 35: /* compare: field '~' str_val  */
+#line 167 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_STR_CMP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1479 "sqlhist.tab.c"
+#line 1388 "sqlhist.tab.c"
     break;
 
-  case 36:
-#line 170 "sqlhist.y"
+  case 36: /* compare_and_or: compare_and_or OR compare_and_or  */
+#line 171 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1485 "sqlhist.tab.c"
+#line 1394 "sqlhist.tab.c"
     break;
 
-  case 37:
-#line 171 "sqlhist.y"
+  case 37: /* compare_and_or: compare_and_or AND compare_and_or  */
+#line 172 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_AND); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1491 "sqlhist.tab.c"
+#line 1400 "sqlhist.tab.c"
     break;
 
-  case 38:
-#line 172 "sqlhist.y"
+  case 38: /* compare_and_or: '!' '(' compare_and_or ')'  */
+#line 173 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1497 "sqlhist.tab.c"
+#line 1406 "sqlhist.tab.c"
     break;
 
-  case 39:
-#line 173 "sqlhist.y"
+  case 39: /* compare_and_or: '!' compare  */
+#line 174 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1503 "sqlhist.tab.c"
+#line 1412 "sqlhist.tab.c"
     break;
 
-  case 41:
-#line 178 "sqlhist.y"
+  case 41: /* compare_items: compare_items OR compare_items  */
+#line 179 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1509 "sqlhist.tab.c"
+#line 1418 "sqlhist.tab.c"
     break;
 
-  case 42:
-#line 179 "sqlhist.y"
+  case 42: /* compare_items: '(' compare_and_or ')'  */
+#line 180 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1515 "sqlhist.tab.c"
+#line 1424 "sqlhist.tab.c"
     break;
 
-  case 43:
-#line 180 "sqlhist.y"
+  case 43: /* compare_items: '!' '(' compare_and_or ')'  */
+#line 181 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1521 "sqlhist.tab.c"
+#line 1430 "sqlhist.tab.c"
     break;
 
-  case 44:
-#line 181 "sqlhist.y"
+  case 44: /* compare_items: '!' compare  */
+#line 182 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1527 "sqlhist.tab.c"
+#line 1436 "sqlhist.tab.c"
     break;
 
-  case 46:
-#line 186 "sqlhist.y"
+  case 46: /* compare_cmds: compare_items  */
+#line 187 "sqlhist.y"
                                 { CHECK_RETURN_VAL(tfs_add_where(sb, (yyvsp[0].expr))); }
-#line 1533 "sqlhist.tab.c"
+#line 1442 "sqlhist.tab.c"
     break;
 
-  case 56:
-#line 219 "sqlhist.y"
+  case 56: /* from_clause: FROM item  */
+#line 220 "sqlhist.y"
                         { CHECK_RETURN_VAL(tfs_add_from(sb, (yyvsp[0].expr))); }
-#line 1539 "sqlhist.tab.c"
+#line 1448 "sqlhist.tab.c"
     break;
 
-  case 57:
-#line 234 "sqlhist.y"
+  case 57: /* join_clause: JOIN item ON match_clause  */
+#line 235 "sqlhist.y"
                                 { tfs_add_to(sb, (yyvsp[-2].expr)); }
-#line 1545 "sqlhist.tab.c"
+#line 1454 "sqlhist.tab.c"
     break;
 
-  case 58:
-#line 238 "sqlhist.y"
+  case 58: /* match: item '=' item  */
+#line 239 "sqlhist.y"
                  { CHECK_RETURN_VAL(tfs_add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
-#line 1551 "sqlhist.tab.c"
+#line 1460 "sqlhist.tab.c"
     break;
 
-  case 59:
-#line 239 "sqlhist.y"
+  case 59: /* match: item EQ item  */
+#line 240 "sqlhist.y"
                 { CHECK_RETURN_VAL(tfs_add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
-#line 1557 "sqlhist.tab.c"
+#line 1466 "sqlhist.tab.c"
     break;
 
 
-#line 1561 "sqlhist.tab.c"
+#line 1470 "sqlhist.tab.c"
 
       default: break;
     }
@@ -1639,6 +1548,7 @@ yyerrorlab:
      label yyerrorlab therefore never appears in user code.  */
   if (0)
     YYERROR;
+  ++yynerrs;
 
   /* Do not reclaim the symbols of the rule whose action triggered
      this YYERROR.  */
@@ -1699,7 +1609,7 @@ yyerrlab1:
 `-------------------------------------*/
 yyacceptlab:
   yyresult = 0;
-  goto yyreturn;
+  goto yyreturnlab;
 
 
 /*-----------------------------------.
@@ -1707,24 +1617,22 @@ yyacceptlab:
 `-----------------------------------*/
 yyabortlab:
   yyresult = 1;
-  goto yyreturn;
+  goto yyreturnlab;
 
 
-#if !defined yyoverflow
-/*-------------------------------------------------.
-| yyexhaustedlab -- memory exhaustion comes here.  |
-`-------------------------------------------------*/
+/*-----------------------------------------------------------.
+| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
+`-----------------------------------------------------------*/
 yyexhaustedlab:
   yyerror (sb, YY_("memory exhausted"));
   yyresult = 2;
-  /* Fall through.  */
-#endif
+  goto yyreturnlab;
 
 
-/*-----------------------------------------------------.
-| yyreturn -- parsing is finished, return the result.  |
-`-----------------------------------------------------*/
-yyreturn:
+/*----------------------------------------------------------.
+| yyreturnlab -- parsing is finished, clean up and return.  |
+`----------------------------------------------------------*/
+yyreturnlab:
   if (yychar != TRACEFS_EMPTY)
     {
       /* Make sure we have latest lookahead translation.  See comments at
@@ -1751,5 +1659,5 @@ yyreturn:
   return yyresult;
 }
 
-#line 248 "sqlhist.y"
+#line 249 "sqlhist.y"
 
diff --git a/src/sqlhist.tab.h b/src/sqlhist.tab.h
index b02a782d61b5..f735ee75a135 100644
--- a/src/sqlhist.tab.h
+++ b/src/sqlhist.tab.h
@@ -1,8 +1,8 @@
-/* A Bison parser, made by GNU Bison 3.6.4.  */
+/* A Bison parser, made by GNU Bison 3.8.2.  */
 
 /* Bison interface for Yacc-like parsers in C
 
-   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
+   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
    Inc.
 
    This program is free software: you can redistribute it and/or modify
@@ -16,7 +16,7 @@
    GNU General Public License for more details.
 
    You should have received a copy of the GNU General Public License
-   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */
 
 /* As a special exception, you may create a larger work that contains
    part or all of the Bison parser skeleton and distribute that work
@@ -88,7 +88,7 @@ extern int tracefs_debug;
 #if ! defined TRACEFS_STYPE && ! defined TRACEFS_STYPE_IS_DECLARED
 union TRACEFS_STYPE
 {
-#line 46 "sqlhist.y"
+#line 47 "sqlhist.y"
 
 	int	s32;
 	char	*string;
@@ -105,14 +105,16 @@ typedef union TRACEFS_STYPE TRACEFS_STYPE;
 
 
 
+
 int tracefs_parse (struct sqlhist_bison *sb);
+
 /* "%code provides" blocks.  */
-#line 37 "sqlhist.y"
+#line 38 "sqlhist.y"
 
   #define YYSTYPE TRACEFS_STYPE
   #define yylex tracefs_lex
   #define yyerror tracefs_error
 
-#line 117 "sqlhist.tab.h"
+#line 119 "sqlhist.tab.h"
 
 #endif /* !YY_TRACEFS_SQLHIST_TAB_H_INCLUDED  */
-- 
2.47.2

