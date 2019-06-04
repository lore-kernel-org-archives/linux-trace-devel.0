Return-Path: <SRS0=dXNV=UD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4E9C282CE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C74324987
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfFDMsb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 08:48:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42190 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfFDMsb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 08:48:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id o12so8564020wrj.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Jun 2019 05:48:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B+FNonimhej0iNhBJc5p1qz3anVt3syj1GjzMGWe5kw=;
        b=JCPV2QAQINt7ZJm9fCQCDLiVeGll8sIJr8smQMYJZ6ad39RFQ6BOL/W2F3Fxv0SAal
         d/JpFvmscipTLx1sh7y4qq743YjJ8i9OW9w+k3WoCxSg/Z7jGOuQe2tetTL6Irukjvg7
         oTryE+gdNv4Y//tIw+rrI4DaUGiXkMaGmOAAF3qFevak9f7lcd3sgFtZ5FBDy3bWzVj1
         7CAlUBeURyEHO6r63IgT6pJJs/dBVxN5DPYzVRyn4ue+D8L/1geJtIye8HYCAy2eZh+h
         7Uc9j+bLr4lmGWEFOWXStigBUuTejWprRV3fTHMeAZDrtLyIBycBvMMmPdX6vXG5/Q00
         chIw==
X-Gm-Message-State: APjAAAXM8NMDeDUnJajqjGqvr2qEknNKN1rl6yFnJoEU5/rGCE55fSD+
        YjYDvkGfOp7IPejy4tjBsA==
X-Google-Smtp-Source: APXvYqz4HcXLypzmhkfOSVAlB2K2kDTo+DCVlz1hhM1WeR18hOLXN9XuMEjfIEhzhkiL5a7ApEtF4Q==
X-Received: by 2002:adf:baca:: with SMTP id w10mr9931497wrg.230.1559652509360;
        Tue, 04 Jun 2019 05:48:29 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o1sm31174968wre.76.2019.06.04.05.48.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 05:48:28 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: [PATCH] trace-cmd: Append metadata about trace-cmd's version when recording
Date:   Tue,  4 Jun 2019 15:48:26 +0300
Message-Id: <20190604124826.6716-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604082440.724d7d95@oasis.local.home>
References: <20190604082440.724d7d95@oasis.local.home>
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
 tracecmd/trace-record.c       | 15 ++++++++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

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
index 4523128..c38d279 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3145,6 +3145,19 @@ static void add_uname(struct tracecmd_output *handle)
 	free(str);
 }
 
+static void add_version(struct tracecmd_output *handle)
+{
+	char *str;
+	int len;
+
+	len = asprintf(&str, "%s %s", TRACECMD_VERSION, TRACECMD_VERSION_GIT);
+	if (len < 0)
+		return;
+
+	tracecmd_add_option(handle, TRACECMD_OPTION_VERSION, len+1, str);
+	free(str);
+}
+
 static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
@@ -3182,7 +3195,7 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
 	add_option_hooks(handle);
 	add_uname(handle);
-
+	add_version(handle);
 }
 
 static void record_data(struct common_record_context *ctx)
-- 
2.20.1

