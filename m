Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DB1C6379F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E347B24655
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTPREIyw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgKQHqK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgKQHqK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:10 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378F1C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:10 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a3so2270391wmb.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YRTqtNT9mO0mGYSahSb5OSguJogcF8plMjrRUvQGK7M=;
        b=nTPREIywWp1VSjEyZp0D/ClKjxXy61+X/+eVri/EDMXZo4F4kXrBxQobcZsg9W+UPN
         /hTS7sxXONoQRvL/fjAyZoeTfNgYk8WoPPjDmnSEAwUgZz/CwliFWa+ULlUwBh48fz0e
         rT+jaEjjh8a6V+eikDqg24/ing5X6GKDIhulT1dOCoJGHvFF24vwvc+teemtO4LJIQFR
         i0fHfI4eeJWJrJSgjKSdfhV6uP2EQ2O+AA+Rr/NPsCnfepBbnPNdS62B9iQqxdFYgjK1
         3RRXSBeoGxP+8oOFWAW6QF+2vZxmzScrLz3XUV43KkUIi4hKp+wG2TiXaimaLaHyxu4g
         hhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YRTqtNT9mO0mGYSahSb5OSguJogcF8plMjrRUvQGK7M=;
        b=T9boLEUTe9l3XujoCzuIBPjOCGprSfcLs3z0OYl9+HS8NyTLdLOKoN1I2dw+a510ds
         SxMEAtzhCwOyFigaick2gtYnr1eT/MsZkftFHCSvE3WOkdybjlyY7TnT3gJj+Fj9cspS
         zRfQagLrnTfX5s6gJV9gu9IH3/vuPDEn2BBvkIQGX7EtQIQb9ijutFDPwb4bY6x5Zcjq
         /Vtd+8EQzkn7CxtD8x7cLTTMLhNZDb4gO9mEzUBKAQgTRTxqK73gX562aavhdjwSf6cg
         RIcnTvg1QDXWtNes4MrcmYlz57LpigGmXUX/r5FyctKw03o6qx+l1hObSgdbMziI5FLT
         5LAw==
X-Gm-Message-State: AOAM531k76uf4nKIVJTSJPKX5PQTqN5Bmf+D5jLOsVOLxhmU1iCJ499D
        9n5GE0ySon0bkhOZum012mJOzsIfcPAMI3rp
X-Google-Smtp-Source: ABdhPJyaObUCsO87gFUPGUy83ZZbL+VmL09LVlIAs8zhCr7lwH/aKugDwCifmbndysJiSXPTfYBdPA==
X-Received: by 2002:a1c:21c1:: with SMTP id h184mr3005763wmh.106.1605599168979;
        Mon, 16 Nov 2020 23:46:08 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:46:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 8/8] libtracefs: Hide non API functions
Date:   Tue, 17 Nov 2020 09:45:57 +0200
Message-Id: <20201117074557.180602-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117074557.180602-1-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are internal library functions, which are not declared as a static.
They are used inside the library from different files. Hide them from
the library users, as they are not part of the API:
 trace_append_file()
 str_read_file()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/tracefs/include/tracefs-local.h | 2 ++
 lib/tracefs/tracefs-events.c        | 2 +-
 lib/tracefs/tracefs-utils.c         | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
index 08b67fa9..9cc371b4 100644
--- a/lib/tracefs/include/tracefs-local.h
+++ b/lib/tracefs/include/tracefs-local.h
@@ -6,6 +6,8 @@
 #ifndef _TRACE_FS_LOCAL_H
 #define _TRACE_FS_LOCAL_H
 
+#define __hidden __attribute__((visibility ("hidden")))
+
 /* Can be overridden */
 void warning(const char *fmt, ...);
 int str_read_file(const char *file, char **buffer);
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index f2c6046c..80a25ee5 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -210,7 +210,7 @@ static char **add_list_string(char **list, const char *name, int len)
 	return list;
 }
 
-char *trace_append_file(const char *dir, const char *name)
+__hidden char *trace_append_file(const char *dir, const char *name)
 {
 	char *file;
 	int ret;
diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
index 227990a9..326b4559 100644
--- a/lib/tracefs/tracefs-utils.c
+++ b/lib/tracefs/tracefs-utils.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include "tracefs.h"
+#include "tracefs-local.h"
 
 #define TRACEFS_PATH "/sys/kernel/tracing"
 #define DEBUGFS_PATH "/sys/kernel/debug"
@@ -188,7 +189,7 @@ void tracefs_put_tracing_file(char *name)
 	free(name);
 }
 
-int str_read_file(const char *file, char **buffer)
+__hidden int str_read_file(const char *file, char **buffer)
 {
 	char stbuf[BUFSIZ];
 	char *buf = NULL;
-- 
2.28.0

