Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28990C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun,  3 Apr 2022 23:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbiDCXU2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 3 Apr 2022 19:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356897AbiDCXU1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 3 Apr 2022 19:20:27 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D01CD3
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 Apr 2022 16:18:32 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id i15so328158qvh.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Apr 2022 16:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SRoB2sXgMC/1Gz3Vs25/OGWgnjefbAOQUGlm5SaFKk8=;
        b=psFiC/v/+XHFrK1UHZFsE5B3GkthZtNvA6Bg68qpsURJwF6SoJGzyrMOMZuLHlnmS7
         J1G8fDhYtw2GkPCLGLTgfUBgWLmfkFuDvi1Knc88FXmUlf2KuwRmLiNh7SQYD3ydjDqX
         prLrO8Abq/Y2TjeGylv8r9G7adq64E/2nyldw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SRoB2sXgMC/1Gz3Vs25/OGWgnjefbAOQUGlm5SaFKk8=;
        b=u1R0GIWxYW1ThjkRkUgGOUxLBBEPDIXrFQqHVwjSLvfAJs7Y+1G609DX0ErYJu+rws
         EF+m84ei++rEpHGLEnQmB4ieXQbdkLVHUfMP9DkTEfN8fUx+hzWUKOaNwoboDpjPDECn
         SExLf05+x/POr9VsVQSU+u0WBKf16cApREzoc8bMxHRCwCm+fyJyvtyaPKgU3vqaYsOI
         J3/QDNHC3kkHSpA9piUDACMF3OPH9zZcOJRNMn93wQqhrsEEbQeC/DoIU4g6e0zI3/o5
         R5oHg7aIgGhu9jzfTfWh/nsEhWd349yKapKm/065rvAMhg4M3iAU7NIZZkSTUSVTUmIl
         xPAQ==
X-Gm-Message-State: AOAM531j2ag8EvgWu88KqX/hA7MXvYeNC5xgFI0TVhEqUZESdHreVs4y
        /T6+Az64VUD78vsDaCSn1fRhtvydXxIdSQ==
X-Google-Smtp-Source: ABdhPJwnSEVeDrkACgbMs21wstswzMtA4+VirWwup07x1RJ5xgFXFyzxOmx20EsS0nnl4ZZKJGAHuA==
X-Received: by 2002:a05:6214:c87:b0:441:644f:c2a4 with SMTP id r7-20020a0562140c8700b00441644fc2a4mr47715695qvr.7.1649027911332;
        Sun, 03 Apr 2022 16:18:31 -0700 (PDT)
Received: from joelboxx.c.googlers.com.com (29.46.245.35.bc.googleusercontent.com. [35.245.46.29])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm5465304qkb.74.2022.04.03.16.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 16:18:31 -0700 (PDT)
From:   Joel Fernandes <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     vineethrp@google.com, rostedt@goodmis.org, tz.stoyanov@gmail.com,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH v2] trace-cmd: Move trace_msg cache file to memfd
Date:   Sun,  3 Apr 2022 23:18:25 +0000
Message-Id: <20220403231825.1258376-1-joel@joelfernandes.org>
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
 lib/trace-cmd/trace-msg.c                         | 4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

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
index 03b853e..1472f20 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -593,11 +593,9 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
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

