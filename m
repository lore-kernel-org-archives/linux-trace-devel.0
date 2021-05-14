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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD1CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5460A6145A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhENM3s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhENM3s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:29:48 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD801C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:28:35 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id c22so16308359ejd.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XodEC0qPq5bPy+VYFdMYHOFABmFR80Uqtn1SgyO6YVs=;
        b=cj54516WGScCya1iDhiUHsq15YYI1RYq7ByUcxnVGJquiStyyEi0WvVbAeDn2Yvemc
         bw1XDw3cOB56czwuj0u59rPd9Wm9XPymRmcVxGCwGlEYZ/lNPHQmdfsLzmWkIug4syn+
         5gV26QTJLate67M6PZ14HiEUbN2qPt6qwStElkQEuSSyWf7mKg5KM9oZ6wcCy6HiAmBz
         Yfc4IWbG/h6dZ+Zn4Ns5n4Ax1sAswhnyRd4Fa6WXb9Qz4WPfNEJIZlcMvPzXNwWGH0t0
         6hsenLadDUXQO/x0gRuhz3hSuAhcIfZbjHUVyuZ9+ySkx8tg86csv3DcS2lXz8NyP7bF
         OBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XodEC0qPq5bPy+VYFdMYHOFABmFR80Uqtn1SgyO6YVs=;
        b=ls560jBHFYZgCHXg9GQIPe9oGCsBaQTMxO8yv2ZwYc/g7GK/qZ7+l+QZd19oYcGACg
         j3++T7T34Niw2MpVIn5yWptBXupv3b4Sj2gm4q+GuTk6Ax0Iq+m2hbN3HiQz+Hjx8R4c
         NOOyeNq2YwbZpKeiOQ0aLJgqH2EfXYWuYeZJuFRZn44BvGvM+MHYrNZzZ5xmCSjMQAx7
         z0piwMpwi+xUVW55PQZDANIspVBIZ5rdhzQSQN8Qmv0J0j+kwVovod5uQRgviBRiKWkw
         tn/k7TjJlpRm9DZgrCxskF4Jq9JaHcI/gl5GiP660ybOlsYLVEGDXeQvHPrYYRmQtwOy
         6GiA==
X-Gm-Message-State: AOAM530QyXUBaQO2yqXU1TqU+jBaPU4zzlCuJxLSw8THJSafBIUPn32o
        OHoqJemjrhSYUevcoMlJRj0=
X-Google-Smtp-Source: ABdhPJzuSgd2LX7MpHkv/3H3pX1LpJsswSvFbI659/GXi7CyhkacCyRPiQAx+kX9GtSXhqsCWnAl+A==
X-Received: by 2002:a17:907:768c:: with SMTP id jv12mr11320991ejc.215.1620995314713;
        Fri, 14 May 2021 05:28:34 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id yw9sm3526468ejb.91.2021.05.14.05.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:28:34 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtraceevent: Better warning print-out
Date:   Fri, 14 May 2021 15:28:25 +0300
Message-Id: <20210514122825.162203-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I see no new line when the messages are printed from KernelShark.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/trace-seq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/trace-seq.c b/src/trace-seq.c
index 8d5ecd2..6aee07a 100644
--- a/src/trace-seq.c
+++ b/src/trace-seq.c
@@ -22,7 +22,7 @@
 #define TRACE_SEQ_CHECK(s)						\
 do {									\
 	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
-		      "Usage of trace_seq after it was destroyed"))	\
+		      "Usage of trace_seq after it was destroyed\n"))	\
 		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
 } while (0)
 
@@ -85,7 +85,7 @@ static void expand_buffer(struct trace_seq *s)
 	char *buf;
 
 	buf = realloc(s->buffer, s->buffer_size + TRACE_SEQ_BUF_SIZE);
-	if (WARN_ONCE(!buf, "Can't allocate trace_seq buffer memory")) {
+	if (WARN_ONCE(!buf, "Can't allocate trace_seq buffer memory\n")) {
 		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
 		return;
 	}
-- 
2.27.0

