Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38ED4C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A3961059
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhEGJyg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhEGJyg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:36 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85CFC061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:36 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b17so9545891ede.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=McwSnI8FYz6jCmF9mwg97pxJL8wFl9Qpv1eQNjFKRc8=;
        b=tEhVCvmd/pqoLtCPkTMK42Zse6kBMXIUFrUYpEzs23GdbZ1bnIY+Mls68a2F6RRY1P
         uudY2njDcpNrIYVv8z3x8MQHBjuXboHuP9ClgPx4J2KKDzjH4zqZH1nAxc+uKC0bSRu8
         ANYyzZe2ncVx1T00HwlfyPr94r2FzM90a/VwAatv4LJ6uPheN7rxfE8hhQUCZQgL3pG2
         subFYxs1uZ6EvD7gQ+oxmv4XmZ/xPG6lJh64zVVa5e6GC0xN85u2/JxLtmow/+FNhCRZ
         8k1feEwAdgcrxJJYbdgpW0FNcr2WkG672Sz2wv9xckU/ChbJvysT+DrV6mmz2upZ+OUO
         CYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=McwSnI8FYz6jCmF9mwg97pxJL8wFl9Qpv1eQNjFKRc8=;
        b=NMAqO6WKygGEXvvYYX3RtbUXrHd7tFD6WqXeHjsQ1JILpcJls9CgmOsShhijlLcB4m
         NAFVme5pSkfn20qCEYWi/gCB73UbdshaSKqlwXyduMH3TIqDc9TeJxp2gx8iYwJ7CagL
         QS5NPyDzELSOBiS5HBJgFqMCiysnuO0pggOZeyI8JyT8EtZ5xHbNxNya3wuRCoSx5IfA
         11KHoFsQZcfLyVgtBnoSh/9UHvBpwZhyP08GxsHzg3g2hmuh5hCSu6s/POs+VUD2BRoL
         CKxM66rifCVgzV5C8vem4ctZElGZB3g/uOuwwTBprGBcZJ6eSOKDaEgQlR8JM9CIxFMx
         4diw==
X-Gm-Message-State: AOAM531oW6LPly+M24kFsXKSm7cnR0NX+O4AEwUD6SzuYsGSzvvXLA2X
        wbAmPad3QFarq520Qck2q2dnp8RgWBeHOQ==
X-Google-Smtp-Source: ABdhPJxVhNaRgGp3H2ADTcuaUmuwVnN/G13cm4v7LWig9At2jZfr/IU65k7+XAD1CQoCrmJ3LZRESw==
X-Received: by 2002:aa7:cf19:: with SMTP id a25mr10485805edy.231.1620381215585;
        Fri, 07 May 2021 02:53:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/8] trace-cmd library: Use tep_vprint() for logs
Date:   Fri,  7 May 2021 12:53:26 +0300
Message-Id: <20210507095333.1080910-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
References: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The traceevent library funciton for printing logs is changed from
tep_vwarning to tep_vprint.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 5 +++--
 python/ctracecmd.i         | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 2d3bc741..ab77ce2a 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -20,6 +20,7 @@
 #include <sys/stat.h>
 #include <sys/sysinfo.h>
 #include <time.h>
+#include <traceevent/event-parse.h>
 #include <traceevent/event-utils.h>
 
 #include "trace-cmd-private.h"
@@ -359,7 +360,7 @@ void __weak tracecmd_warning(const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	tep_vwarning("libtracecmd", fmt, ap);
+	tep_vprint("libtracecmd", TEP_LOG_WARNING, true, fmt, ap);
 	va_end(ap);
 }
 
@@ -369,7 +370,7 @@ void __weak tracecmd_fatal(const char *fmt, ...)
 	va_list ap;
 
 	va_start(ap, fmt);
-	ret = tep_vwarning("libtracecmd", fmt, ap);
+	ret = tep_vprint("libtracecmd", TEP_LOG_CRITICAL, true, fmt, ap);
 	va_end(ap);
 
 	if (debug) {
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index e938c780..7091b9bd 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -63,7 +63,7 @@ void warning(const char *fmt, ...)
 		return;
 
 	va_start(ap, fmt);
-	tep_vwarning("tracecmd", fmt, ap);
+	tep_vprint("tracecmd", TEP_LOG_WARNING, true, fmt, ap);
 	va_end(ap);
 }
 
-- 
2.31.1

