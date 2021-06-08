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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFBAC47082
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED6A16134F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhFHN5Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 09:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbhFHN5X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 09:57:23 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AC7C061787
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Jun 2021 06:55:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d184so1936533wmd.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jun 2021 06:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mZcW/VyvthwwS3Yln3hBopaQYabd9Gfkvtj8854YCm0=;
        b=Jf4w11w5I5Yez9ZJjGt3Z23ds5RdWkIHSdmp6Pu+PyodHNj9SBGBx2xX+I3IVcVLJw
         IAG+WpuPjLNuj0SnTYVbDTTOzm37R8KE4y+rx8ZITjfXNMjFTXHokXOWcarBiEDPBAtO
         Gu/gfKoqJunVSOB2ZENXbz7Ij7rR1xTzZL2Zk/heUjR5SKN6P3NOO9r++MP2s4LisDDP
         F4FjSZWabYmHNw/QnW/HSECYt1exSNWoFaLS3LeWjXPJdW75pEMw2zpEpNyxxPvLdroJ
         C2skOBt9TI3MQbPyMBz3rsqJ5CfU+whbu85gK0+1B4O+sHR/WaTD+QPM4bMmT+VG0DqP
         7JXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mZcW/VyvthwwS3Yln3hBopaQYabd9Gfkvtj8854YCm0=;
        b=DB/LfF0hcLNNpZXY9IISwjdpeUTmkvThnyon05cb+Bq1+KJ4kWbXcb/MTi/W0xv3Xf
         wXuYObyvA/0zIqCip66AZgwvCTZcDXOkd/FA+6mguKGXMOzvkdO3Xn83OoZTHzlO5x78
         GhhPLFj+FN5DfQUQOR3BG0cC0v5IfpYhCFpVa5L1eqiBKLDCSkkZ2wYsXEzezw2Ehbwk
         UCeir02sdDCAe3cpx8g5ymi2FSDbo1+b/G03xeuTwALpO3DbZPEYFCAgArpsHvMOfbQv
         x5R3qG4W/nNKc8f8WOe3OBPFz3LEOGIslP/oVge7J29YLTLQ94M5WybiU3L0ArhJzJ0B
         +rEw==
X-Gm-Message-State: AOAM532MkAlpm9SE1UstgKOGY50AVbASBGJc3JaKL6ICInF6dxlhVb5f
        ejc34l0qii1jwOqAJY+QSxOerCB/b88=
X-Google-Smtp-Source: ABdhPJy2qn/ruceBQy668wNatZKtVGrKs8QmfWtMfwc8f7ojyVVTFuVsVayXTo3L01grrJ2wSRCDzg==
X-Received: by 2002:a05:600c:4f4a:: with SMTP id m10mr10084353wmq.51.1623160517366;
        Tue, 08 Jun 2021 06:55:17 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id w13sm6806973wmi.48.2021.06.08.06.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 06:55:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] libtracefs: Fix event_enable_disable() return value
Date:   Tue,  8 Jun 2021 16:55:01 +0300
Message-Id: <20210608135503.12135-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210608135503.12135-1-y.karadz@gmail.com>
References: <20210608135503.12135-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

event_enable_disable() is a static method used internally by the
tracefs_event_enable/disable() API. The returned value do not obey
the description given in the documentation. Note that "ret" must
be set to -1 right before the beginning of the loop.

Fixes: fc94d1a (libtracefs: Add tracefs_event_enable/disable() API)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/tracefs-events.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 8b2d9ef..0fef64f 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -835,7 +835,7 @@ static int event_enable_disable(struct tracefs_instance *instance,
 	regex_t system_re, event_re;
 	char **systems;
 	char **events = NULL;
-	int ret = -1;
+	int ret;
 	int s, e;
 
 	/* Handle all events first */
@@ -860,6 +860,7 @@ static int event_enable_disable(struct tracefs_instance *instance,
 		}
 	}
 
+	ret = -1;
 	for (s = 0; systems[s]; s++) {
 		if (system && !match(systems[s], &system_re))
 			continue;
-- 
2.27.0

