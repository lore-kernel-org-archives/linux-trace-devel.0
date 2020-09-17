Return-Path: <SRS0=TigW=C2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BB9C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Sep 2020 01:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71EDF206CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Sep 2020 01:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgIQBPd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 21:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgIQBPc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 21:15:32 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:15:31 EDT
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 623A9206CA;
        Thu, 17 Sep 2020 01:07:23 +0000 (UTC)
Date:   Wed, 16 Sep 2020 21:07:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Initial trace-cmd support for ftrace uprobes
Message-ID: <20200916210721.6994f7ab@rorschach.local.home>
In-Reply-To: <20200916114709.291533-1-tz.stoyanov@gmail.com>
References: <20200916114709.291533-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

I really like this patch set. Great job!

To get it working on my laptop, I had to make the following changes. I
ran this on a new VM which didn't have libbfd and it failed to build.
Then the check wasn't quite working, and it was saying that libbfd
wasn't installed even though it was. Finally, I tested it against a
small program that had numbers in the function name, and I had to
change your sanitizer to not convert numbers into underscores.

Also, all strdup()s need to be tested. But other than that, it looks
great!

Below is the changes I made.

-- Steve

diff --git a/Makefile b/Makefile
index 0d657969..240043e1 100644
--- a/Makefile
+++ b/Makefile
@@ -245,7 +245,7 @@ endif
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
-BFD_INSTALLED := $(shell if (echo -e "\#include <bfd.h>\n void main(){bfd_init();}" | $(CC) -xc  - -lbfd >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+BFD_INSTALLED := $(shell if (printf "$(pound)include <bfd.h>\n void main(){bfd_init();}" | $(CC) -x c  - -lbfd >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 
 export BFD_INSTALLED
 ifeq ($(BFD_INSTALLED), 1)
diff --git a/tracecmd/trace-obj-debug.c b/tracecmd/trace-obj-debug.c
index 93b0dfee..254bfb38 100644
--- a/tracecmd/trace-obj-debug.c
+++ b/tracecmd/trace-obj-debug.c
@@ -8,13 +8,13 @@
 #include <string.h>
 #include <limits.h>
 #include <errno.h>
-#include <bfd.h>
 #include <unistd.h>
 
 #include "trace-local.h"
 #include "trace-cmd.h"
 
 #ifdef BFD_INSTALLED
+#include <bfd.h>
 
 struct trace_debug_handle {
 	bfd *bfd;
diff --git a/tracecmd/trace-uprobes.c b/tracecmd/trace-uprobes.c
index 87f8c148..75bebd6f 100644
--- a/tracecmd/trace-uprobes.c
+++ b/tracecmd/trace-uprobes.c
@@ -31,7 +31,7 @@ static char *uprobe_event_name(char *file, char *func, bool pret)
 	asprintf(&event, "%c_%.*s_%.10s", pret ? 'r':'p', 10, fname, func);
 	if (event) {
 		for (i = 0; event[i]; i++) {
-			if (!isalpha(event[i]))
+			if (!isalnum(event[i]))
 				event[i] = '_';
 		}
 	}
