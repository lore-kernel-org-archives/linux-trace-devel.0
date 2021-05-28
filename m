Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B56FC47087
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 May 2021 11:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B9B613D1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 May 2021 11:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhE1Lj3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 May 2021 07:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbhE1LjT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 May 2021 07:39:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E954C061760
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 May 2021 04:37:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x8so2967243wrq.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 May 2021 04:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtX+D+T/iZTFRUyL7KYn3u4u4j24sclR0wXdN7AZnIA=;
        b=ey2WX1VnANP3XwZdcWwyN11W4VutOxjpG+j1gjL3zytRo+H9qbUeAC7QkLvtvSw/WU
         tyhqT4dcNqHcWuTg5h96/eAKju/4cAuctwUZ0Vgs9j6fmt+EBpVYgXZ8sWakU3nMNF70
         9OeBYWMrvSMIOVvAApR+ewqFsEow6sojoa/ZYGa+F+WyfkQ6+pyUkv61e/r/iytQmf0M
         2e4PI+Pp3Mdu5XKIne7SUJehK3jesPKHSwYG0mbfMzANS5hcwVy3FdTSuCEs9jHyW4Bc
         rdR9pfaJLdmFSYVJPiZ60HScc7nSayG9DdervilLFzs4ha/9yL8JOsh9SWUJ9eJmbxgW
         hgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dtX+D+T/iZTFRUyL7KYn3u4u4j24sclR0wXdN7AZnIA=;
        b=O9THxiQQHBKJZOvk0wVIr0ABZCCJgxklx3sIXugdi5aYsX5UHImy8Cl7lFg59QD3Wr
         GNli9cgj3oAUtfS9f3RYEAReH/mU0QsVEBS/JwT0NcX+Tli6bLK8lWNgeF2m1m8+4oym
         gY8Jrl4bh+q6A2E+amAMKuhplP4FKXe7qzG/w7YT0jVMHuCwOQTMeg35i/Aw0MhOh+nk
         cuGyFJHFIZlCc5QplSIFDDA8Bl1yzi5PoboQFpUuc3foqoSV9p+/PegyiI1ufqCnKY0I
         14N/w6PwcPY5qWInLQITSrZ5vhuUWeeVGMuFmgXRBOj9LSDnGElC8AGkuu3Ja9ebv5eM
         xj+g==
X-Gm-Message-State: AOAM5313hmYYJ4lIGx0wRm9XJgwl/kl1zLoaxI7t2tiyCMe4OlsFSyb8
        PbgGSRHdIGzk+z4/Y/fZfTY=
X-Google-Smtp-Source: ABdhPJwE3xFicTq987Iubq1tr3bhiT5wpLtwcQEj69m04Fe9oDdpmPaxw5ZPzEfXke6RcOzi7LZtyQ==
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr8240121wrx.419.1622201863787;
        Fri, 28 May 2021 04:37:43 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id l8sm7552655wry.55.2021.05.28.04.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 04:37:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Fix event_enable_disable() return value
Date:   Fri, 28 May 2021 14:37:31 +0300
Message-Id: <20210528113731.167831-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

event_enable_disable() is a static method used internally by the
tracefs_event_enable/disable() API. The returned value do not obey
the description given in the documentation for some specific use-cases.

Fixes: fc94d1a (libtracefs: Add tracefs_event_enable/disable() API)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/tracefs-events.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 55316c6..9adfd25 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -833,12 +833,12 @@ static int event_enable_disable(struct tracefs_instance *instance,
 	regex_t system_re, event_re;
 	char **systems;
 	char **events = NULL;
-	int ret = -1;
+	int ret;
 	int s, e;
 
 	/* Handle all events first */
 	if (!system && !event)
-		return enable_disable_all(instance, enable);
+		return enable_disable_all(instance, enable) < 0 ? -1 : 0;
 
 	systems = tracefs_event_systems(NULL);
 	if (!systems)
@@ -858,6 +858,7 @@ static int event_enable_disable(struct tracefs_instance *instance,
 		}
 	}
 
+	ret = -1;
 	for (s = 0; systems[s]; s++) {
 		if (system && !match(systems[s], &system_re))
 			continue;
-- 
2.27.0

