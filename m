Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825901D5ADE
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 22:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744325402; cv=none; b=Ipf2r3UrA+umkwiNlSNtY5bMtRa9KKqUD/bk7twldWwvDU9VVc/GsOE0K0ZzwgoYI1XynPoqgTOoG/eJq9TEwVP4DWE2Ucoog/R5mHJFFGoXZrGod74KEF1wOqx6P+6Thc3sfn5NjNP9zzRfrI/Ea4cKmERyT9+dLHHp8S3ZXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744325402; c=relaxed/simple;
	bh=wMs9/BRwafE5nnB/mCgSsjBzJ40nZjrZXz8PYRR7MtM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=slbOmkgOAJLm4QiBkjOJLRdghaFNaVV4yTBdVufkE+luQfHgJ4C3vSoJsSs3i2BJfm6nXBFXMktO72eYDDZn/Ks+aDzrshLIg2Boq+MBXhOB+C0NlJ6S7KbmTQM3pk6ZwIgE4y7UHuKnBCVpzRBt09nsKci4SIHL8Q+6D8Xvof0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AECC4CEDD
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 22:50:01 +0000 (UTC)
Date: Thu, 10 Apr 2025 18:51:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix trace_sql() to handle buckets cast
Message-ID: <20250410185124.7281b197@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The "CAST(start.delta as buckets=50)" doesn't work as the sqlhist.y doesn't
parse the =50 properly, and even if it did, the code in the histogram logic
fails to process the count.

Update the sqlhist.y (and run make sqlhist_remake) and fix the histogram
logic to process the buckets count.

Fixes: faa0ba7f ("libtracefs: Add buckets field to tracefs_sql() function")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/sqlhist-parse.h   |   1 +
 src/sqlhist.tab.c     | 351 ++++++++++++++++++++++--------------------
 src/sqlhist.y         |   4 +
 src/tracefs-hist.c    |  32 +++-
 src/tracefs-sqlhist.c |  17 ++
 5 files changed, 231 insertions(+), 174 deletions(-)

diff --git a/src/sqlhist-parse.h b/src/sqlhist-parse.h
index 5e8d1c8..69aa266 100644
--- a/src/sqlhist-parse.h
+++ b/src/sqlhist-parse.h
@@ -67,6 +67,7 @@ int tfs_add_selection(struct sqlhist_bison *sb, void *item, const char *label);
 int tfs_add_from(struct sqlhist_bison *sb, void *item);
 int tfs_add_to(struct sqlhist_bison *sb, void *item);
 void *tfs_add_cast(struct sqlhist_bison *sb, void *field, const char *type);
+void *tfs_add_cast_buckets(struct sqlhist_bison *sb, void *field, const char *type, int num);
 
 void *tfs_add_string(struct sqlhist_bison *sb, const char *str);
 void *tfs_add_number(struct sqlhist_bison *sb, long val);
diff --git a/src/sqlhist.tab.c b/src/sqlhist.tab.c
index a53f8e1..8c24b36 100644
--- a/src/sqlhist.tab.c
+++ b/src/sqlhist.tab.c
@@ -523,16 +523,16 @@ union yyalloc
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  5
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   104
+#define YYLAST   108
 
 /* YYNTOKENS -- Number of terminals.  */
 #define YYNTOKENS  35
 /* YYNNTS -- Number of nonterminals.  */
 #define YYNNTS  28
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  61
+#define YYNRULES  62
 /* YYNSTATES -- Number of states.  */
-#define YYNSTATES  111
+#define YYNSTATES  114
 
 /* YYMAXUTOK -- Last valid token kind.  */
 #define YYMAXUTOK   276
@@ -584,12 +584,12 @@ static const yytype_int8 yytranslate[] =
 static const yytype_uint8 yyrline[] =
 {
        0,    76,    76,    79,    80,    83,    87,    91,    92,    96,
-     100,   107,   108,   109,   110,   111,   118,   123,   131,   132,
-     136,   140,   144,   148,   152,   153,   158,   159,   160,   161,
-     162,   163,   164,   165,   166,   167,   171,   172,   173,   174,
-     175,   179,   180,   181,   182,   183,   187,   196,   197,   198,
-     202,   205,   207,   210,   212,   216,   220,   235,   239,   240,
-     245,   246
+     100,   107,   108,   109,   110,   111,   115,   122,   127,   135,
+     136,   140,   144,   148,   152,   156,   157,   162,   163,   164,
+     165,   166,   167,   168,   169,   170,   171,   175,   176,   177,
+     178,   179,   183,   184,   185,   186,   187,   191,   200,   201,
+     202,   206,   209,   211,   214,   216,   220,   224,   239,   243,
+     244,   249,   250
 };
 #endif
 
@@ -624,7 +624,7 @@ yysymbol_name (yysymbol_kind_t yysymbol)
 }
 #endif
 
-#define YYPACT_NINF (-58)
+#define YYPACT_NINF (-59)
 
 #define yypact_value_is_default(Yyn) \
   ((Yyn) == YYPACT_NINF)
@@ -638,18 +638,18 @@ yysymbol_name (yysymbol_kind_t yysymbol)
    STATE-NUM.  */
 static const yytype_int8 yypact[] =
 {
-       4,   -58,    13,    11,   -58,   -58,     5,   -58,    43,    53,
-      45,    29,   -58,    19,    43,    44,    32,    60,   -58,    73,
-      11,    75,   -58,   -58,   -58,    43,    43,    87,   -58,   -58,
-      29,   -58,   -58,   -58,    60,    83,   -58,   -58,   -58,   -58,
-     -58,    78,   -58,    86,    14,   -58,   -58,    65,    60,    -4,
-     -12,    34,   -58,    76,   -15,   -58,   -58,   -10,    68,   -58,
-       1,   -58,    18,    -4,   -58,    33,    33,    33,    33,    33,
-      33,    33,    33,    33,    84,    14,    14,    14,    60,    60,
-      60,    -4,   -58,    -4,    -4,   -58,    49,   -58,   -58,   -58,
-     -58,   -58,   -58,   -58,   -58,   -58,   -58,   -58,   -58,   -58,
-     -58,   -58,   -58,   -58,   -58,   -58,    51,   -58,   -58,   -58,
-     -58
+       9,   -59,    16,    -7,   -59,   -59,    45,   -59,    27,    53,
+      42,     1,   -59,    50,    27,    47,    46,    60,   -59,    84,
+      -7,    77,   -59,   -59,   -59,    27,    27,    89,   -59,   -59,
+       1,   -59,   -59,   -59,    60,    85,   -59,   -59,   -59,   -59,
+     -59,    80,   -59,    88,    -4,   -59,   -59,    33,    60,    -5,
+      -2,    22,   -59,    76,    24,   -59,   -59,    86,     3,    71,
+     -59,    18,   -59,    30,    -5,   -59,    31,    31,    31,    31,
+      31,    31,    31,    31,    31,    87,    -4,    -4,    -4,    70,
+      60,    60,    60,    -5,   -59,    -5,    -5,   -59,    37,   -59,
+     -59,   -59,   -59,   -59,   -59,   -59,   -59,   -59,   -59,   -59,
+     -59,   -59,   -59,   -59,   -59,   -59,   -59,   -59,   -59,    41,
+     -59,   -59,   -59,   -59
 };
 
 /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
@@ -657,34 +657,34 @@ static const yytype_int8 yypact[] =
    means the default is an error.  */
 static const yytype_int8 yydefact[] =
 {
-       0,     5,     0,     0,     2,     1,     0,    20,     0,     0,
-       7,     9,    13,    11,     0,     0,     0,     0,     6,    53,
-       0,     0,    22,    10,     4,     0,     0,     0,    14,    12,
-      20,    56,    19,    18,     0,    51,    54,     8,     3,    16,
-      17,     0,    21,     0,     0,    52,    55,     0,     0,     0,
-       0,     0,    45,    46,    47,    50,    15,     0,    60,    57,
-       0,    40,     0,     0,    44,     0,     0,     0,     0,     0,
+       0,     5,     0,     0,     2,     1,     0,    21,     0,     0,
+       7,     9,    13,    11,     0,     0,     0,     0,     6,    54,
+       0,     0,    23,    10,     4,     0,     0,     0,    14,    12,
+      21,    57,    20,    19,     0,    52,    55,     8,     3,    17,
+      18,     0,    22,     0,     0,    53,    56,     0,     0,     0,
+       0,     0,    46,    47,    48,    51,    16,     0,     0,    61,
+      58,     0,    41,     0,     0,    45,     0,     0,     0,     0,
        0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
-       0,     0,    39,     0,     0,    42,     0,    25,    23,    24,
-      28,    29,    31,    32,    26,    27,    30,    33,    34,    35,
-      41,    49,    48,    59,    58,    61,     0,    37,    36,    43,
-      38
+       0,     0,     0,     0,    40,     0,     0,    43,     0,    26,
+      24,    25,    29,    30,    32,    33,    27,    28,    31,    34,
+      35,    36,    42,    50,    49,    15,    60,    59,    62,     0,
+      38,    37,    44,    39
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int8 yypgoto[] =
 {
-     -58,   -58,    69,   -58,   -58,    80,   -58,   -58,    90,   -16,
-      -3,   -58,    81,    27,    15,   -41,   -57,    28,   -58,   -21,
-     -58,   -58,   -58,   -58,   -58,   -58,   -58,    24
+     -59,   -59,    72,   -59,   -59,    81,   -59,   -59,    95,   -16,
+      -3,   -59,    83,    32,    13,   -42,   -58,    29,   -59,    11,
+     -59,   -59,   -59,   -59,   -59,   -59,   -59,    26
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int8 yydefgoto[] =
 {
-       0,     2,    23,     3,     4,     9,    10,    11,    12,    57,
-      51,    33,    24,    89,    90,    61,    62,    53,    54,    55,
-      45,    46,    35,    18,    19,    36,    58,    59
+       0,     2,    23,     3,     4,     9,    10,    11,    12,    58,
+      51,    33,    24,    91,    92,    62,    63,    53,    54,    55,
+      45,    46,    35,    18,    19,    36,    59,    60
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
@@ -692,32 +692,32 @@ static const yytype_int8 yydefgoto[] =
    number is the opposite.  If YYTABLE_NINF, syntax error.  */
 static const yytype_int8 yytable[] =
 {
-      13,    31,     7,    52,    76,    16,    86,    78,     1,    64,
-       7,    27,    77,     5,    32,     7,    63,    13,    43,    82,
-      79,     6,    39,    40,   106,     7,   107,   108,     7,    81,
-      60,    32,    21,    14,    52,    52,    52,    83,    84,     8,
-      25,    26,    49,    22,    87,    32,    88,    85,    50,    65,
-      66,    67,    68,    25,    26,   101,   102,     7,    17,    69,
-      70,    29,   103,   104,    71,    72,    73,    74,    83,    84,
-      83,    84,    20,    28,    30,    32,    32,    32,   109,    34,
-     110,    91,    92,    93,    94,    95,    96,    97,    98,    22,
-      41,    44,    47,    48,    56,    80,    75,    88,    15,    42,
-      37,    99,    38,   100,   105
+      13,    31,    52,     6,    21,    16,    88,     7,    65,     7,
+       7,    27,     7,     1,    32,    22,     5,    13,    43,    84,
+      80,     8,    39,    40,    49,   109,    64,   110,   111,    61,
+      50,    32,     7,    81,    52,    52,    52,    66,    67,    68,
+      69,     7,    89,    77,    90,    32,    83,    70,    71,    85,
+      86,    78,    72,    73,    74,    75,    85,    86,    17,    87,
+      85,    86,    56,    57,   106,   107,   112,    25,    26,    20,
+     113,    25,    26,    14,    30,    29,    28,    32,    32,    32,
+      93,    94,    95,    96,    97,    98,    99,   100,   103,   104,
+      34,    22,    41,    44,    47,    48,    76,    79,    82,   105,
+      90,    37,    42,    15,    38,   102,     0,   101,   108
 };
 
 static const yytype_int8 yycheck[] =
 {
-       3,    17,    14,    44,    19,     8,    63,    17,     4,    50,
-      14,    14,    27,     0,    17,    14,    28,    20,    34,    60,
-      30,    10,    25,    26,    81,    14,    83,    84,    14,    28,
-      34,    34,     3,    28,    75,    76,    77,    19,    20,    28,
-      21,    22,    28,    14,    11,    48,    13,    29,    34,    15,
-      16,    17,    18,    21,    22,    76,    77,    14,     5,    25,
-      26,    29,    78,    79,    30,    31,    32,    33,    19,    20,
-      19,    20,    27,    29,    14,    78,    79,    80,    29,     6,
-      29,    66,    67,    68,    69,    70,    71,    72,    73,    14,
-       3,     8,    14,     7,    29,    27,    20,    13,     8,    30,
-      20,    74,    21,    75,    80
+       3,    17,    44,    10,     3,     8,    64,    14,    50,    14,
+      14,    14,    14,     4,    17,    14,     0,    20,    34,    61,
+      17,    28,    25,    26,    28,    83,    28,    85,    86,    34,
+      34,    34,    14,    30,    76,    77,    78,    15,    16,    17,
+      18,    14,    11,    19,    13,    48,    28,    25,    26,    19,
+      20,    27,    30,    31,    32,    33,    19,    20,     5,    29,
+      19,    20,    29,    30,    80,    81,    29,    21,    22,    27,
+      29,    21,    22,    28,    14,    29,    29,    80,    81,    82,
+      67,    68,    69,    70,    71,    72,    73,    74,    77,    78,
+       6,    14,     3,     8,    14,     7,    20,    11,    27,    29,
+      13,    20,    30,     8,    21,    76,    -1,    75,    82
 };
 
 /* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
@@ -729,37 +729,37 @@ static const yytype_int8 yystos[] =
       27,     3,    14,    37,    47,    21,    22,    45,    29,    29,
       14,    44,    45,    46,     6,    57,    60,    40,    47,    45,
       45,     3,    37,    44,     8,    55,    56,    14,     7,    28,
-      34,    45,    50,    52,    53,    54,    29,    44,    61,    62,
-      34,    50,    51,    28,    50,    15,    16,    17,    18,    25,
-      26,    30,    31,    32,    33,    20,    19,    27,    17,    30,
-      27,    28,    50,    19,    20,    29,    51,    11,    13,    48,
-      49,    49,    49,    49,    49,    49,    49,    49,    49,    48,
-      52,    54,    54,    44,    44,    62,    51,    51,    51,    29,
-      29
+      34,    45,    50,    52,    53,    54,    29,    30,    44,    61,
+      62,    34,    50,    51,    28,    50,    15,    16,    17,    18,
+      25,    26,    30,    31,    32,    33,    20,    19,    27,    11,
+      17,    30,    27,    28,    50,    19,    20,    29,    51,    11,
+      13,    48,    49,    49,    49,    49,    49,    49,    49,    49,
+      49,    48,    52,    54,    54,    29,    44,    44,    62,    51,
+      51,    51,    29,    29
 };
 
 /* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
 static const yytype_int8 yyr1[] =
 {
        0,    35,    36,    37,    37,    38,    39,    40,    40,    41,
-      41,    42,    42,    42,    42,    42,    43,    43,    44,    44,
-      45,    46,    47,    48,    49,    49,    50,    50,    50,    50,
-      50,    50,    50,    50,    50,    50,    51,    51,    51,    51,
-      51,    52,    52,    52,    52,    52,    53,    54,    54,    54,
-      55,    56,    56,    57,    57,    58,    59,    60,    61,    61,
-      62,    62
+      41,    42,    42,    42,    42,    42,    42,    43,    43,    44,
+      44,    45,    46,    47,    48,    49,    49,    50,    50,    50,
+      50,    50,    50,    50,    50,    50,    50,    51,    51,    51,
+      51,    51,    52,    52,    52,    52,    52,    53,    54,    54,
+      54,    55,    56,    56,    57,    57,    58,    59,    60,    61,
+      61,    62,    62
 };
 
 /* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
 static const yytype_int8 yyr2[] =
 {
        0,     2,     1,     2,     1,     1,     3,     1,     3,     1,
-       2,     1,     3,     1,     3,     6,     3,     3,     1,     1,
-       1,     2,     1,     1,     1,     1,     3,     3,     3,     3,
-       3,     3,     3,     3,     3,     3,     3,     3,     4,     2,
-       1,     3,     3,     4,     2,     1,     1,     1,     3,     3,
-       2,     0,     1,     0,     1,     3,     2,     4,     3,     3,
-       1,     3
+       2,     1,     3,     1,     3,     8,     6,     3,     3,     1,
+       1,     1,     2,     1,     1,     1,     1,     3,     3,     3,
+       3,     3,     3,     3,     3,     3,     3,     3,     3,     4,
+       2,     1,     3,     3,     4,     2,     1,     1,     1,     3,
+       3,     2,     0,     1,     0,     1,     3,     2,     4,     3,
+       3,     1,     3
 };
 
 
@@ -1276,197 +1276,206 @@ yyreduce:
 #line 1277 "sqlhist.tab.c"
     break;
 
-  case 15: /* selection_expr: CAST '(' field AS FIELD ')'  */
+  case 15: /* selection_expr: CAST '(' field AS FIELD '=' NUMBER ')'  */
 #line 111 "sqlhist.y"
+                                          {
+					 (yyval.expr) = tfs_add_cast_buckets(sb, (yyvsp[-5].expr), (yyvsp[-3].string), (yyvsp[-1].number));
+					 CHECK_RETURN_PTR((yyval.expr));
+				}
+#line 1286 "sqlhist.tab.c"
+    break;
+
+  case 16: /* selection_expr: CAST '(' field AS FIELD ')'  */
+#line 115 "sqlhist.y"
                                 {
 					 (yyval.expr) = tfs_add_cast(sb, (yyvsp[-3].expr), (yyvsp[-1].string));
 					 CHECK_RETURN_PTR((yyval.expr));
 				}
-#line 1286 "sqlhist.tab.c"
+#line 1295 "sqlhist.tab.c"
     break;
 
-  case 16: /* selection_addition: field '+' field  */
-#line 119 "sqlhist.y"
+  case 17: /* selection_addition: field '+' field  */
+#line 123 "sqlhist.y"
                                 {
 					(yyval.expr) = tfs_add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_ADD);
 					CHECK_RETURN_PTR((yyval.expr));
 				}
-#line 1295 "sqlhist.tab.c"
+#line 1304 "sqlhist.tab.c"
     break;
 
-  case 17: /* selection_addition: field '-' field  */
-#line 124 "sqlhist.y"
+  case 18: /* selection_addition: field '-' field  */
+#line 128 "sqlhist.y"
                                 {
 					(yyval.expr) = tfs_add_compare(sb, (yyvsp[-2].expr), (yyvsp[0].expr), COMPARE_SUB);
 					CHECK_RETURN_PTR((yyval.expr));
 				}
-#line 1304 "sqlhist.tab.c"
+#line 1313 "sqlhist.tab.c"
     break;
 
-  case 20: /* field: FIELD  */
-#line 136 "sqlhist.y"
+  case 21: /* field: FIELD  */
+#line 140 "sqlhist.y"
                 { (yyval.expr) = tfs_add_field(sb, (yyvsp[0].string), NULL); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1310 "sqlhist.tab.c"
+#line 1319 "sqlhist.tab.c"
     break;
 
-  case 21: /* named_field: FIELD label  */
-#line 140 "sqlhist.y"
+  case 22: /* named_field: FIELD label  */
+#line 144 "sqlhist.y"
                { (yyval.expr) = tfs_add_field(sb, (yyvsp[-1].string), (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1316 "sqlhist.tab.c"
+#line 1325 "sqlhist.tab.c"
     break;
 
-  case 23: /* str_val: STRING  */
-#line 148 "sqlhist.y"
+  case 24: /* str_val: STRING  */
+#line 152 "sqlhist.y"
                 { (yyval.expr) = tfs_add_string(sb, (yyvsp[0].string)); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1322 "sqlhist.tab.c"
+#line 1331 "sqlhist.tab.c"
     break;
 
-  case 25: /* val: NUMBER  */
-#line 153 "sqlhist.y"
+  case 26: /* val: NUMBER  */
+#line 157 "sqlhist.y"
                 { (yyval.expr) = tfs_add_number(sb, (yyvsp[0].number)); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1328 "sqlhist.tab.c"
+#line 1337 "sqlhist.tab.c"
     break;
 
-  case 26: /* compare: field '<' val  */
-#line 158 "sqlhist.y"
+  case 27: /* compare: field '<' val  */
+#line 162 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LT); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1334 "sqlhist.tab.c"
+#line 1343 "sqlhist.tab.c"
     break;
 
-  case 27: /* compare: field '>' val  */
-#line 159 "sqlhist.y"
+  case 28: /* compare: field '>' val  */
+#line 163 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GT); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1340 "sqlhist.tab.c"
+#line 1349 "sqlhist.tab.c"
     break;
 
-  case 28: /* compare: field LE val  */
-#line 160 "sqlhist.y"
+  case 29: /* compare: field LE val  */
+#line 164 "sqlhist.y"
                 { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_LE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1346 "sqlhist.tab.c"
+#line 1355 "sqlhist.tab.c"
     break;
 
-  case 29: /* compare: field GE val  */
-#line 161 "sqlhist.y"
+  case 30: /* compare: field GE val  */
+#line 165 "sqlhist.y"
                 { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_GE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1352 "sqlhist.tab.c"
+#line 1361 "sqlhist.tab.c"
     break;
 
-  case 30: /* compare: field '=' val  */
-#line 162 "sqlhist.y"
+  case 31: /* compare: field '=' val  */
+#line 166 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1358 "sqlhist.tab.c"
+#line 1367 "sqlhist.tab.c"
     break;
 
-  case 31: /* compare: field EQ val  */
-#line 163 "sqlhist.y"
+  case 32: /* compare: field EQ val  */
+#line 167 "sqlhist.y"
                 { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_EQ); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1364 "sqlhist.tab.c"
+#line 1373 "sqlhist.tab.c"
     break;
 
-  case 32: /* compare: field NEQ val  */
-#line 164 "sqlhist.y"
+  case 33: /* compare: field NEQ val  */
+#line 168 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1370 "sqlhist.tab.c"
+#line 1379 "sqlhist.tab.c"
     break;
 
-  case 33: /* compare: field "!=" val  */
-#line 165 "sqlhist.y"
+  case 34: /* compare: field "!=" val  */
+#line 169 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_NE); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1376 "sqlhist.tab.c"
+#line 1385 "sqlhist.tab.c"
     break;
 
-  case 34: /* compare: field '&' val  */
-#line 166 "sqlhist.y"
+  case 35: /* compare: field '&' val  */
+#line 170 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_BIN_AND); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1382 "sqlhist.tab.c"
+#line 1391 "sqlhist.tab.c"
     break;
 
-  case 35: /* compare: field '~' str_val  */
-#line 167 "sqlhist.y"
+  case 36: /* compare: field '~' str_val  */
+#line 171 "sqlhist.y"
                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_STR_CMP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1388 "sqlhist.tab.c"
+#line 1397 "sqlhist.tab.c"
     break;
 
-  case 36: /* compare_and_or: compare_and_or OR compare_and_or  */
-#line 171 "sqlhist.y"
+  case 37: /* compare_and_or: compare_and_or OR compare_and_or  */
+#line 175 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1394 "sqlhist.tab.c"
+#line 1403 "sqlhist.tab.c"
     break;
 
-  case 37: /* compare_and_or: compare_and_or AND compare_and_or  */
-#line 172 "sqlhist.y"
+  case 38: /* compare_and_or: compare_and_or AND compare_and_or  */
+#line 176 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_AND); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1400 "sqlhist.tab.c"
+#line 1409 "sqlhist.tab.c"
     break;
 
-  case 38: /* compare_and_or: '!' '(' compare_and_or ')'  */
-#line 173 "sqlhist.y"
+  case 39: /* compare_and_or: '!' '(' compare_and_or ')'  */
+#line 177 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1406 "sqlhist.tab.c"
+#line 1415 "sqlhist.tab.c"
     break;
 
-  case 39: /* compare_and_or: '!' compare  */
-#line 174 "sqlhist.y"
+  case 40: /* compare_and_or: '!' compare  */
+#line 178 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1412 "sqlhist.tab.c"
+#line 1421 "sqlhist.tab.c"
     break;
 
-  case 41: /* compare_items: compare_items OR compare_items  */
-#line 179 "sqlhist.y"
+  case 42: /* compare_items: compare_items OR compare_items  */
+#line 183 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-2].expr), (yyvsp[0].expr), FILTER_OR); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1418 "sqlhist.tab.c"
+#line 1427 "sqlhist.tab.c"
     break;
 
-  case 42: /* compare_items: '(' compare_and_or ')'  */
-#line 180 "sqlhist.y"
+  case 43: /* compare_items: '(' compare_and_or ')'  */
+#line 184 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1424 "sqlhist.tab.c"
+#line 1433 "sqlhist.tab.c"
     break;
 
-  case 43: /* compare_items: '!' '(' compare_and_or ')'  */
-#line 181 "sqlhist.y"
+  case 44: /* compare_items: '!' '(' compare_and_or ')'  */
+#line 185 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[-1].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1430 "sqlhist.tab.c"
+#line 1439 "sqlhist.tab.c"
     break;
 
-  case 44: /* compare_items: '!' compare  */
-#line 182 "sqlhist.y"
+  case 45: /* compare_items: '!' compare  */
+#line 186 "sqlhist.y"
                                         { (yyval.expr) = tfs_add_filter(sb, (yyvsp[0].expr), NULL, FILTER_NOT_GROUP); CHECK_RETURN_PTR((yyval.expr)); }
-#line 1436 "sqlhist.tab.c"
+#line 1445 "sqlhist.tab.c"
     break;
 
-  case 46: /* compare_cmds: compare_items  */
-#line 187 "sqlhist.y"
+  case 47: /* compare_cmds: compare_items  */
+#line 191 "sqlhist.y"
                                 { CHECK_RETURN_VAL(tfs_add_where(sb, (yyvsp[0].expr))); }
-#line 1442 "sqlhist.tab.c"
+#line 1451 "sqlhist.tab.c"
     break;
 
-  case 56: /* from_clause: FROM item  */
-#line 220 "sqlhist.y"
+  case 57: /* from_clause: FROM item  */
+#line 224 "sqlhist.y"
                         { CHECK_RETURN_VAL(tfs_add_from(sb, (yyvsp[0].expr))); }
-#line 1448 "sqlhist.tab.c"
+#line 1457 "sqlhist.tab.c"
     break;
 
-  case 57: /* join_clause: JOIN item ON match_clause  */
-#line 235 "sqlhist.y"
+  case 58: /* join_clause: JOIN item ON match_clause  */
+#line 239 "sqlhist.y"
                                 { tfs_add_to(sb, (yyvsp[-2].expr)); }
-#line 1454 "sqlhist.tab.c"
+#line 1463 "sqlhist.tab.c"
     break;
 
-  case 58: /* match: item '=' item  */
-#line 239 "sqlhist.y"
+  case 59: /* match: item '=' item  */
+#line 243 "sqlhist.y"
                  { CHECK_RETURN_VAL(tfs_add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
-#line 1460 "sqlhist.tab.c"
+#line 1469 "sqlhist.tab.c"
     break;
 
-  case 59: /* match: item EQ item  */
-#line 240 "sqlhist.y"
+  case 60: /* match: item EQ item  */
+#line 244 "sqlhist.y"
                 { CHECK_RETURN_VAL(tfs_add_match(sb, (yyvsp[-2].expr), (yyvsp[0].expr))); }
-#line 1466 "sqlhist.tab.c"
+#line 1475 "sqlhist.tab.c"
     break;
 
 
-#line 1470 "sqlhist.tab.c"
+#line 1479 "sqlhist.tab.c"
 
       default: break;
     }
@@ -1659,5 +1668,5 @@ yyreturnlab:
   return yyresult;
 }
 
-#line 249 "sqlhist.y"
+#line 253 "sqlhist.y"
 
diff --git a/src/sqlhist.y b/src/sqlhist.y
index c35a1a3..96609bb 100644
--- a/src/sqlhist.y
+++ b/src/sqlhist.y
@@ -108,6 +108,10 @@ selection_expr :
  | '(' field ')'		{  $$ = $2; }
  | selection_addition
  | '(' selection_addition ')'	{  $$ = $2; }
+ | CAST '(' field AS FIELD '=' NUMBER ')' {
+					 $$ = tfs_add_cast_buckets(sb, $3, $5, $7);
+					 CHECK_RETURN_PTR($$);
+				}
  | CAST '(' field AS FIELD ')'	{
 					 $$ = tfs_add_cast(sb, $3, $5);
 					 CHECK_RETURN_PTR($$);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 0ea8312..bfbcd65 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -250,6 +250,17 @@ tracefs_hist_alloc(struct tep_handle *tep,
 	return tracefs_hist_alloc_nd(tep, system, event_name, axis);
 }
 
+static struct tracefs_hist *
+hist_alloc_cnt(struct tep_handle *tep,
+	       const char *system, const char *event_name,
+	       const char *key, enum tracefs_hist_key_type type,
+	       int cnt)
+{
+	struct tracefs_hist_axis_cnt axis[] = {{key, type, cnt}, {NULL, 0}};
+
+	return tracefs_hist_alloc_nd_cnt(tep, system, event_name, axis);
+}
+
 /**
  * tracefs_hist_alloc_2d - Initialize two-dimensional histogram
  * @tep: The tep handle that has the @system and @event.
@@ -323,6 +334,7 @@ hist_alloc_nd(struct tep_handle *tep,
 	tracefs_hist_free(hist);
 	return NULL;
 }
+
 /**
  * tracefs_hist_alloc_nd - Initialize N-dimensional histogram
  * @tep: The tep handle that has the @system and @event.
@@ -778,6 +790,7 @@ struct tracefs_synth {
 	unsigned int		end_parens;
 	unsigned int		end_state;
 	int			*start_type;
+	int			*start_cnts;
 	char			arg_name[16];
 	int			arg_cnt;
 	bool			new_format;
@@ -847,6 +860,7 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 	free(synth->start_filter);
 	free(synth->end_filter);
 	free(synth->start_type);
+	free(synth->start_cnts);
 
 	tep_unref(synth->tep);
 
@@ -1473,6 +1487,7 @@ __hidden int tfs_synth_add_start_field(struct tracefs_synth *synth,
 	char *start_arg;
 	char **tmp;
 	int *types;
+	int *cnts;
 	int len;
 	int ret;
 
@@ -1526,6 +1541,14 @@ __hidden int tfs_synth_add_start_field(struct tracefs_synth *synth,
 	synth->start_type = types;
 	synth->start_type[len - 1] = type;
 
+	cnts = realloc(synth->start_cnts, sizeof(*cnts) * len);
+	if (!cnts) {
+		ret = -1;
+		goto out_free;
+	}
+	synth->start_cnts = cnts;
+	synth->start_cnts[len - 1] = count;
+
  out_free:
 	free(start_arg);
 	return ret;
@@ -2182,6 +2205,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 	const char *key;
 	char **keys;
 	int *types;
+	int *cnts;
 	int ret;
 	int i;
 
@@ -2194,6 +2218,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 	event = synth->start_event->name;
 	types = synth->start_type;
 	keys = synth->start_keys;
+	cnts = synth->start_cnts;
 	tep = synth->tep;
 
 	if (!keys)
@@ -2204,6 +2229,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 
 	for (i = 0; keys[i]; i++) {
 		int type = types ? types[i] : 0;
+		int cnt = cnts ? cnts[i] : 0;
 
 		if (type == HIST_COUNTER_TYPE)
 			continue;
@@ -2211,14 +2237,14 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 		key = keys[i];
 
 		if (i) {
-			ret = tracefs_hist_add_key(hist, key, type);
+			ret = tracefs_hist_add_key_cnt(hist, key, type, cnt);
 			if (ret < 0) {
 				tracefs_hist_free(hist);
 				return NULL;
 			}
 		} else {
-			hist = tracefs_hist_alloc(tep, system, event,
-						  key, type);
+			hist = hist_alloc_cnt(tep, system, event,
+					      key, type, cnt);
 			if (!hist)
 				return NULL;
 		}
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 3cad2ff..67be678 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -260,6 +260,23 @@ __hidden void *tfs_add_cast(struct sqlhist_bison *sb, void *data, const char *ty
 	return expr;
 }
 
+__hidden void *tfs_add_cast_buckets(struct sqlhist_bison *sb, void *data,
+				    const char *type, int num)
+{
+	struct expr *expr = data;
+	struct field *field = &expr->field;
+	char *str;
+
+	if (asprintf(&str, "%s=%u", type, num) < 0)
+		return NULL;
+
+	field->type = tfs_store_str(sb, str);
+	free(str);
+	if (!field->type)
+		return NULL;
+	return expr;
+}
+
 __hidden int tfs_add_selection(struct sqlhist_bison *sb, void *select, const char *name)
 {
 	struct sql_table *table = sb->table;
-- 
2.47.2

