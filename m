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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C4EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Jan 2021 16:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DFDC22DFB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Jan 2021 16:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391220AbhAZQM6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 11:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391235AbhAZQMx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 11:12:53 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6A1C0617A7
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Jan 2021 08:12:13 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id r12so23692406ejb.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Jan 2021 08:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTE2P+G++wdLBmtgrSh2rhGrHlh598jwGkdV3USPa+E=;
        b=lTRQrfSnI/sMWUaFmc8Do0F7KiKS0Xz9iuwxqg0mTMU6taFzYH1chwL7aiURBar+gM
         XFXuLdgF3FMXOM5pFYUEKQh3WjK+bzTVDFEr5BqkzdcOk2juZkQXOPZpeVlBkC4kOwlv
         nj4V5HmSeX8AEVsLT9wVLxGrB3sO5qZWNcsMaBoNFCfE3bLsOsrb+wC8wImiYL175J5W
         93oKrITI6Zx93UYeK+YTNSAWrkWBmIqCwv0tcu/nTRvxdsO+xMt3i8RMRdbD8WqSNFzo
         zDMBcKDYEp4wclxWOAAVTPvTzhzn4uOx9I8DhHUvXiclY2aIrhSJ3PPyMolQHh7FIgpw
         74Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fTE2P+G++wdLBmtgrSh2rhGrHlh598jwGkdV3USPa+E=;
        b=EzIn/CevRSVCek+1bjdOr7suqih+yJvL6xw8w2SMe2UzeHiC9q/MizrZXy46Lj/5wj
         hTUWqzynbtCJBIk6krfRJMb8FauI8wGQ7+v0C35wwW0yKqJ71CeVxITW1fheSv/u1aFO
         ugMQEIOhMWFtKqbgczyRGXVfx6/n4+pl7L5sVuAyq1xpGikDohdN6lQAwI3fu32X1MCf
         S9iX3sQzYtvmRUESxkQzaJXwFJCTzEep2siI4nk0Fkr31siu29iDC9+iDuhytjSwZeoT
         UxeI5H41OXVE4lhDiazyzAdVz/pBAe/qC9V7bq5VQekX6SZqmWU70sMpkpGUgGRCEfkT
         Necw==
X-Gm-Message-State: AOAM532jgbo4FjeJlHsJAJVMcj4ERX0+9nPhsayrEruDgR3AIzebHWr5
        pwvayP4+hxnL7qn4X67qgChVbiYb44+5u2dW
X-Google-Smtp-Source: ABdhPJwiWU2+fM1sfs/UVgbtoo7Hm61Ojxwbgxq/FsJzc8Uqw6X/TU/xVhTAxSPfpX2icqHFEEaglw==
X-Received: by 2002:a17:906:4b44:: with SMTP id j4mr3828188ejv.23.1611677531866;
        Tue, 26 Jan 2021 08:12:11 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id de4sm12512203edb.38.2021.01.26.08.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 08:12:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Add missing system includes
Date:   Tue, 26 Jan 2021 18:12:09 +0200
Message-Id: <20210126161209.1086179-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some libtracefs APIs use defines from Linux system headers. These
headers are not included in the tracefs library main header file, which
causes compilation errors when these APIs are used and the required
system headers are not included explicitly by the caller.

Reported-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 3059dbb..f3eec62 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -6,8 +6,10 @@
 #ifndef _TRACE_FS_H
 #define _TRACE_FS_H
 
-#include <traceevent/event-parse.h>
+#include <sys/stat.h>
+#include <fcntl.h>
 #include <sched.h>
+#include <traceevent/event-parse.h>
 
 char *tracefs_get_tracing_file(const char *name);
 void tracefs_put_tracing_file(char *name);
-- 
2.29.2

