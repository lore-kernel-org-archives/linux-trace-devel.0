Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED5BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 15:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C8E613A3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 15:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhDFPip (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 11:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230320AbhDFPip (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 11:38:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A58C613A3;
        Tue,  6 Apr 2021 15:38:37 +0000 (UTC)
Date:   Tue, 6 Apr 2021 11:38:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH v2] trace-cmd: Add CODING_STYLE and CONTRIBUTE documents
Message-ID: <20210406113835.23b1daec@gandalf.local.home>
In-Reply-To: <20210406113758.765a0aef@gandalf.local.home>
References: <20210406113758.765a0aef@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Here's the diff from v1:

diff --git a/CODING_STYLE b/CODING_STYLE
index 6aff138e..24fb10ec 100644
--- a/CODING_STYLE
+++ b/CODING_STYLE
@@ -2,7 +2,7 @@
 trace-cmd coding-style
 ======================
 
-The coding style of trace-cmd and the tracing librariers (libtracefs and
+The coding style of trace-cmd and the tracing libraries (libtracefs and
 libtraceevent) are very similar to the Linux kernel coding style:
 
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst
@@ -18,6 +18,8 @@ divisible by 8.
 Max line width
 ==============
 
+All lines should not be more than 100 characters in length.
+
 This is a guide, as readability is more important than breaking lines up into a
 hard limit. Ideally, strings should never be broken up except for where a new
 line is added.
@@ -33,10 +35,11 @@ But line breaks should not be:
 
 Not only is the above not as readable as the first version, it is not
 even equivalent, because it is missing spaces between the line breaks.
-For this reason, finish the string on the same line.
+For this reason, finish the string on the same line, even if that string
+breaks the 100 character limit.
 
-Brackets and baces
-==================
+Brackets and braces
+===================
 
 For all conditionals, the braces start on the same line:
 
@@ -60,13 +63,80 @@ The same is true for structures:
 		int field;
 	};
 
-But for functions, the baces should start on the following line:
+But for functions, the braces should start on the following line:
 
 	void my_function(void)
 	{
 	}
 
 
+It is also fine to not use braces for simple conditionals and loops.
+
+	if (!x)
+		y = x;
+	else
+		y = 1;
+
+	for (i = 0; i < 10; i++)
+		foo(i);
+
+	while (getline(&line, &size, fp) > 0)
+		printf("%s", line);
+
+But any complex or multiline conditional or loop should have braces even if it
+is allowed not to by the C language.
+
+	if (x) {
+		for (i = 0; i < 10; i++)
+			foo(i);
+	} else {
+		foo(1);
+	}
+
+Notice above that even though the else portion is simple, it too has braces as
+the else and if blocks should match. If one is required to have braces, they
+both should have braces.
+
+
+Spaces
+======
+
+A single space should be used between C commands and their starting
+parenthesis.
+
+	if (x)
+	for (i = 0; i < 10; i++)
+	while (getline(&line, &size, fp) > 0)
+
+There should be no space between function or macros and the starting
+parenthesis.
+
+	foo(x)
+	IS_VALID(y)
+
+This includes prototypes and declarations.
+
+	void foo(int x)
+
+A space should be before and after assignment, comparison and algorithmic
+signs.
+
+	i = 0;
+	if (i < 10)
+	if (i == 5)
+
+	y = i + 10;
+
+	i += 5;
+
+For structures, use tabs to make all the fields line up nicely.
+
+	struct {
+		int			foo;
+		int			bar;
+		unsigned long long	time;
+	};
+
 Variable declarations
 =====================
 
@@ -171,6 +241,44 @@ The form is:
    * be placed at the end of the comment block.
    */
 
+Structure layout
+================
+
+This is more about compaction than coding style. When creating structures, be
+aware that if the fields are placed together without being sized by alignment,
+that the compiler will create "holes" in them.
+
+	struct {
+		int			x;
+		char			y;
+		unsigned long long	f;
+	};
+
+As int is 4 bytes in length, char is one byte, and unsigned long long is 8
+bytes. The compiler will try to naturally align them by their size, and will
+include padding (holes) inside the structure to do so. The above is equivalent
+to:
+
+	struct {
+		int			x;
+		char			y;
+		char			padding[3];
+		unsigned long long	f;
+	};
+
+It is best to try to organize the structure where there are no holes within
+them.
+
+	struct {
+		unsigned long long	f;
+		int			x;
+		char			y;
+	};
+
+The above is better formatting, even if there may be padding outside the
+structure, but the compiler will still have more flexibility to utilize the
+space outside the structure than what it can do within it.
+
 General
 =======
 
diff --git a/CONTRIBUTE b/CONTRIBUTE
index f03d00d8..aed78110 100644
--- a/CONTRIBUTE
+++ b/CONTRIBUTE
@@ -55,6 +55,16 @@ Here's some helpful hints for your git commits.
    Please note, the DCO is your statement that you have the legal right to
    make these changes for the project you are submitting to.
 
+You can use the Linux kernel "checkpatch.pl" script to help verify the formatting
+of your patch:
+
+  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/scripts/checkpatch.pl
+
+Please note that checkpatch.pl is a guide and not a hard rule. If it reports a
+fix that makes the code harder to read, that fix can probably be ignored.
+
+  git format-patch --stdout HEAD~1..HEAD | ./checkpatch.pl
+
 Finally, you can use the git "send-email" functionality:
 
   git --send-email --from='<your-email> --to='linux-trace-devel@vger.kernel.org' HEAD~1..HEAD
@@ -78,3 +88,16 @@ To keep track of the status of patches that have been submitted, check out:
 
   https://patchwork.kernel.org/project/linux-trace-devel/list/
 
+If you would like to apply patches from the mailing list, you can use
+the "b4" utility.
+
+ $ pip install b4
+
+Then from the mailing list archive, find a message id from a patch or patch
+series. For example, to get the patch from:
+
+  https://lore.kernel.org/linux-trace-devel/20210205173713.132051-1-tz.stoyanov@gmail.com/
+
+ $ b4 am -o - 20210205173713.132051-1-tz.stoyanov@gmail.com > /tmp/p.mbox
+ $ git am /tmp/p.mbox
+
