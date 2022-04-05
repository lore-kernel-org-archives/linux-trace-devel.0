Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87356C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Apr 2022 02:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiDFCmy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573608AbiDETYN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 15:24:13 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CD46D85C
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Apr 2022 12:22:14 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id p8so420558qvv.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Apr 2022 12:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtSps7/m+IfjWY2IhgorjG8AnRB88okvBnpSvx3lWeA=;
        b=wbsmJPQdYTrWqLRqSoBvk2aa2b5hi+ZHvwv4vvIDRn0hkvsz6k1AcwKTte6CYygw7l
         FlWAScZT2hyJ+jrm7TJtbCdIetyYWVz3dJMw2vQosebVrkTNjsfX93wj3N0269fNXbkp
         fFMRGY9eD+hKJ/Zl3EAYnWVx3FjwfZOQqWsv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XtSps7/m+IfjWY2IhgorjG8AnRB88okvBnpSvx3lWeA=;
        b=RAIrEJexu7JRmWMGFEUpaqtzTeRRwbjg9tXsbDk/YvOPFYphQKzLuZDo3aj7QVY7MU
         kvkHMzCA6eJH61k/FZTwvm/cKhQlF3NsWVTLzh2fXhvkB0FoH96yLjvvb8plmxRxlAgQ
         2KWzFyudq5gG/m4tClqdsn9ZNS+84Xf+JLgMBYup2LQ14nqWo4PaqpyI7HgNQg2DnGXJ
         geQxLztj03AsOLwX61l2l5q3CzRKvGgM117UxCoKAuSTsnGV0oseZypyVYQA7GJwPD1U
         zg+cLI6c8KIMaQvIUfgQoaBWekOOORxrOQKTeS1pic4GSGlpGbAEJuqsES779VBbAxeK
         ovEA==
X-Gm-Message-State: AOAM5329aUe+QgRBCf8ESGjg0mTBC2Y3Rm/EyjC0SHw7bQO/m/FRGxgF
        /pvxlHpl9hVv3rzoGLQE84XKr7ZjWZvfTg==
X-Google-Smtp-Source: ABdhPJwhQcV/PPO8ANyRBTyw5DYI9yo9qKBQo3HQwVAekguHddvjBuk/ybbNv89awQZvqo6gEQZzUg==
X-Received: by 2002:a05:6214:d45:b0:441:6b43:6e25 with SMTP id 5-20020a0562140d4500b004416b436e25mr4225502qvr.95.1649186533765;
        Tue, 05 Apr 2022 12:22:13 -0700 (PDT)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id 186-20020a370cc3000000b0067d36e3481dsm8487262qkm.17.2022.04.05.12.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 12:22:13 -0700 (PDT)
From:   Joel Fernandes <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     vineethrp@google.com, rostedt@goodmis.org, tz.stoyanov@gmail.com,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH v3] trace-cmd: Move trace_msg cache file to memfd
Date:   Tue,  5 Apr 2022 19:22:04 +0000
Message-Id: <20220405192204.1551283-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is cleaner and also fixes issues in Android where /tmp does not
exist.

With this, host-guest tracing works on Android VM running on ChromeOS
Linux.

Signed-off-by: Joel Fernandes <joel@joelfernandes.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 --
 lib/trace-cmd/trace-msg.c                         | 5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6934376..3aee139 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -377,7 +377,6 @@ enum tracecmd_msg_flags {
 };
 
 /* for both client and server */
-#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
 struct tracecmd_msg_handle {
 	int			fd;
 	short			cpu_count;
@@ -386,7 +385,6 @@ struct tracecmd_msg_handle {
 	bool			done;
 	bool			cache;
 	int			cfd;
-	char			cfile[sizeof(MSG_CACHE_FILE)];
 };
 
 struct tracecmd_tsync_protos {
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 03b853e..bb559c8 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -19,6 +19,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <arpa/inet.h>
+#include <sys/mman.h>
 #include <sys/types.h>
 #include <linux/types.h>
 
@@ -593,11 +594,9 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
 {
 	if (msg_handle->cfd < 0) {
-		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
-		msg_handle->cfd = mkstemp(msg_handle->cfile);
+		msg_handle->cfd = memfd_create("trace_msg_cache", 0);
 		if (msg_handle->cfd < 0)
 			return -1;
-		unlink(msg_handle->cfile);
 	}
 	msg_handle->cache = true;
 	return 0;
-- 
2.35.1.1094.g7c7d902a7c-goog

