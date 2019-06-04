Return-Path: <SRS0=dXNV=UD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14190C282CE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E97C5218CD
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfFDMOq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 08:14:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39594 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfFDMOp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 08:14:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so14462568wma.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Jun 2019 05:14:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T8Il8ZIGjJFcVBBDvMJw4RV7aTrR8pPHE3rfK+2gOCM=;
        b=XEm+pEGhawdXJ2KhW47KF0TtKNcxcHFSozUroruTR3Swa3dJCirWNE6lqX2xKmRWRN
         jy51zg0m/MIq+Z/7xv72YeJE6Wb70uOnEqlp4g1txG70BV/19943jkXEM3xJ9kbcIXdm
         AAkqY9/aernM4ds2+OGsQ+jRkGY7zTgOzSxEEd65w+oTvKKo38Al3wqNflp4q1lCd1j9
         vwgshu5UhU2IBxFD2hu3HzGWCYR9DRHfbBSe0lpWIXLxqDP3xVsQ9JojmoWx/z7V+o4R
         fTdG8xr5O3QHmav2X0cGecyPdPSQh8/y2Jd4LWibQ/xMmizZNB8K3yeQw9YXyOP1IK+l
         2Z4g==
X-Gm-Message-State: APjAAAX+aNUYv6Op2CTcE7rv4JuPPAcQhwRpwZsHvqNDfHgt83UrvXq4
        R8IWR1emDy7kwNHe9q9HtQ==
X-Google-Smtp-Source: APXvYqzs9aV8TWJy4n2sSWdq53Sp/87HtOuIe3D+PcDtdnXJUXstIALPAegRIFcyye43GXsKQ/Du1w==
X-Received: by 2002:a1c:c909:: with SMTP id f9mr5959587wmb.115.1559650483891;
        Tue, 04 Jun 2019 05:14:43 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k10sm10910742wmk.14.2019.06.04.05.14.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 05:14:43 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: [PATCH] trace-cmd: Append metadata about trace-cmd's version when recording
Date:   Tue,  4 Jun 2019 15:14:41 +0300
Message-Id: <20190604121441.19305-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add metadata when recording to the output trace about trace-cmd's version and
git commit. When debugging this can be useful to know which version of trace-cmd
recorded this trace.dat file.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203547
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Makefile                      |  3 +++
 include/trace-cmd/trace-cmd.h |  1 +
 tracecmd/trace-record.c       | 17 ++++++++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index cde45f8..2062d97 100644
--- a/Makefile
+++ b/Makefile
@@ -238,6 +238,9 @@ endif
 override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 
+# Append version define
+override CFLAGS += -DTRACECMD_VERSION=\"$(TRACECMD_VERSION)\"
+override CFLAGS += -DTRACECMD_VERSION_GIT=\"$(shell git log -1 --pretty=format:"%H")\"
 
 CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ceb03f4..ca9fc44 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -81,6 +81,7 @@ enum {
 	TRACECMD_OPTION_HOOK,
 	TRACECMD_OPTION_OFFSET,
 	TRACECMD_OPTION_CPUCOUNT,
+	TRACECMD_OPTION_VERSION,
 };
 
 enum {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4523128..4c4840b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3145,6 +3145,21 @@ static void add_uname(struct tracecmd_output *handle)
 	free(str);
 }
 
+static void add_version(struct tracecmd_output *handle)
+{
+	char *str;
+	int len;
+
+	len = strlen(TRACECMD_VERSION) + strlen(TRACECMD_VERSION_GIT) + 2;
+	str = malloc(len);
+	if (!str)
+		return;
+
+	sprintf(str, "%s %s", TRACECMD_VERSION, TRACECMD_VERSION_GIT);
+	tracecmd_add_option(handle, TRACECMD_OPTION_VERSION, len, str);
+	free(str);
+}
+
 static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
@@ -3182,7 +3197,7 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
 	add_option_hooks(handle);
 	add_uname(handle);
-
+	add_version(handle);
 }
 
 static void record_data(struct common_record_context *ctx)
-- 
2.20.1

