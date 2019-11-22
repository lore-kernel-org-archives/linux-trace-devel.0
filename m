Return-Path: <SRS0=hl++=ZO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12295C432C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Nov 2019 14:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC31E2071F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Nov 2019 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574434719;
	bh=8bYXXlzd4B7lGdMNSfMw5lRNKBXg6nYGApFt/zgLGbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=EB13OuWo8QiUU4ImAnfQvNrUHvXYighl3avqE5IpFUH39AlCFq81vR7+O0tfr2vvm
	 AnX5Uz5JA1tNsj2gSvR+3h1bRW+1XIs4Is+E4JQOu9p63oS6w2OwORPQbTp2C6sykn
	 dp1nRpuWXxh83JFHmjD3652QNS4o5bNb4r0DLwAc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKVO6Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbfKVO6W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 09:58:22 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B9B2072D;
        Fri, 22 Nov 2019 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574434702;
        bh=8bYXXlzd4B7lGdMNSfMw5lRNKBXg6nYGApFt/zgLGbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp1SZ1eIPe42K4KgtzHIbixns8lIlWz5KFtBtt1tnBu1dW0e8SA2AGeh28e4ZoDGT
         mqPSRYBdKf2dgQHnTXZKNXHMaZvEKqWEMG/xqjw95wjqd/um0dhVhgpLfTS3arMCyB
         EQ3NJ1XIRKO8rFkvSd8OjZb4wWW4jVYaIVRODM2I=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/26] libtraceevent: Fix header installation
Date:   Fri, 22 Nov 2019 11:57:08 -0300
Message-Id: <20191122145711.3171-24-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191122145711.3171-1-acme@kernel.org>
References: <20191122145711.3171-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

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
index 5315f3787f8d..cbb429f55062 100644
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
 
-- 
2.21.0

