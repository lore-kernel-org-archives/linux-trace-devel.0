Return-Path: <SRS0=HVYc=ZP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AA2C43215
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Nov 2019 08:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE94207FA
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Nov 2019 08:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKWIPL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 03:15:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36258 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfKWIPL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 03:15:11 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iYQZI-0002WA-GZ; Sat, 23 Nov 2019 09:15:00 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 381B81C1AD0;
        Sat, 23 Nov 2019 09:15:00 +0100 (CET)
Date:   Sat, 23 Nov 2019 08:15:00 -0000
From:   "tip-bot2 for Sudip Mukherjee" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] libtraceevent: Fix header installation
Cc:     Sudipm Mukherjee <sudipm.mukherjee@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191114133719.309-1-sudipm.mukherjee@gmail.com>
References: <20191114133719.309-1-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Message-ID: <157449690015.21853.2630112930404018807.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     68401a1799fa14cb72c2a129bbefdacd44279772
Gitweb:        https://git.kernel.org/tip/68401a1799fa14cb72c2a129bbefdacd44279772
Author:        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
AuthorDate:    Thu, 14 Nov 2019 13:37:19 
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Fri, 22 Nov 2019 10:48:14 -03:00

libtraceevent: Fix header installation

When we passed some location in DESTDIR, install_headers called
do_install with DESTDIR as part of the second argument.

But do_install is again using '$(DESTDIR_SQ)$2', so as a result the
headers were installed in a location $DESTDIR/$DESTDIR.

In my testing I passed DESTDIR=/home/sudip/test and the headers were
installed in: /home/sudip/test/home/sudip/test/usr/include/traceevent.

Lets remove DESTDIR from the second argument of do_install so that the
headers are installed in the correct location.

Signed-off-by: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191114133719.309-1-sudipm.mukherjee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 5315f37..cbb429f 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -232,10 +232,10 @@ install_pkgconfig:
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-		$(call do_install,event-parse.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,event-utils.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,trace-seq.h,$(DESTDIR)$(includedir_SQ),644); \
-		$(call do_install,kbuffer.h,$(DESTDIR)$(includedir_SQ),644)
+		$(call do_install,event-parse.h,$(includedir_SQ),644); \
+		$(call do_install,event-utils.h,$(includedir_SQ),644); \
+		$(call do_install,trace-seq.h,$(includedir_SQ),644); \
+		$(call do_install,kbuffer.h,$(includedir_SQ),644)
 
 install: install_lib
 
