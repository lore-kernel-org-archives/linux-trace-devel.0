Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73184C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 420832087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfCHNhB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34090 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHNhA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:00 -0500
Received: by mail-wm1-f67.google.com with SMTP id o10so8975603wmc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:36:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lp0vFYrBBBMX0fIItrHSvdGAAmrdEmflDRuI95m5iNk=;
        b=FpT7uldmcjoMpdTXgnvl35bExXbU2cJQN0TqCH6XMBVW+g9D78vurVvbzIEJoGq3N3
         CDUgHIG9mYs1lUx+vGXdi1a+XD9qiLaxkE5drvM4Gn/CIgt2sTd9WvKUO2r+plOMbEBw
         veHzR9bgNhQhFEo9t0PS8jgsOsE4CC1a8H+yWKBmYPqMcEXOE9rpEPVekSszhlgxvMl9
         pZgdVx7faeJonp3MpH/19KpTMPR58H9u1YH68qCaE3jjX/e0u2RCRYu8VkRM9cEygsnk
         4MeNR+ks16syKYRQGw4lt8MaiqtLPJRyuOk9GsH69NK+FEM90H8LKZQFjZRwvRRFwiY7
         8D6A==
X-Gm-Message-State: APjAAAVE79ePvSPprvLWGl/mXRtvYE9tnu+GmMeQS32MMFvRBrdD4fZ8
        qJ9Zlf30YG76PbhgOpZfMxk=
X-Google-Smtp-Source: APXvYqyk040iFBqXlVNQggkjNcQvO8LzKW7f+y6PwvngA7t40jedqDr4boICmqDYJrOjagSwygk4tQ==
X-Received: by 2002:a7b:c41a:: with SMTP id k26mr9752388wmi.6.1552052219149;
        Fri, 08 Mar 2019 05:36:59 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.36.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:36:58 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 02/46] tools/lib/traceevent: Fix libtraceevent/Documentation Makefile
Date:   Fri,  8 Mar 2019 15:36:10 +0200
Message-Id: <20190308133654.21264-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As libtraceevent/Documentation Makefile and all XLS files were taken
from tools/perf/Documentation, and modified for libtraceevent, this patch
adds a note on the top of the Makefile to state it. It also fixes the "clean"
rule, to clean up compiled man pages.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Documentation/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Documentation/Makefile b/tools/lib/traceevent/Documentation/Makefile
index e17c0723b4e1..680a9771067f 100644
--- a/tools/lib/traceevent/Documentation/Makefile
+++ b/tools/lib/traceevent/Documentation/Makefile
@@ -1,6 +1,9 @@
 include ../../../scripts/Makefile.include
 include ../../../scripts/utilities.mak
 
+# This Makefile and manpage XSL files were taken from tools/perf/Documentation
+# and modified for libtraceevent.
+
 MAN3_TXT= \
 	$(wildcard libtraceevent-*.txt) \
 	libtraceevent.txt
@@ -174,7 +177,7 @@ endif
 CLEAN_FILES =					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
-	$(DOC_MAN3)
+	$(DOC_MAN3) *.3
 
 clean:
 	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
-- 
2.20.1

