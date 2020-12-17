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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A29C3526C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841D7238E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgLQJqq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgLQJqp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:46:45 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A29C0617A7
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:04 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id e25so5132789wme.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TTsxa3xOVrS59dJlI+cTyeWy4OmCG8j9RFEIbJ64/NE=;
        b=VSaOPzgguSwHR9BXkFnWaNpkkpddrnQhcL9hRcZfkQc+tmx2yUOWaTfOQY/AJwYJ0t
         Jm5uI/MFJAgwtWtXh4gzCB+Wjr68SSiXqKCv7WcjX6d140qzEiXFTNRs0YGQ9sHEfOAz
         Z3O9T5vh7M6OWYWKMDl+hzyJwN6H4N9VVNefq9jbi7+v1TvvplLuS4Dqt0kfKuPA7duA
         F2f1V8mz+oaO86kMv8rMzOcO0hKy5hsjhR8mbUh1pEpK4glrpCG5qysNhB8jwacBq6JM
         +j4vZe/KYZVFrv5/IiIO4MgjM+17md/HuUcMSd2Rf104T/oK6VrGM2c022LWzPRsoJW/
         yIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TTsxa3xOVrS59dJlI+cTyeWy4OmCG8j9RFEIbJ64/NE=;
        b=Q5hE15H12ffXu7BYAh4XLjeFw6ilohnHWdEZ+X22nZQWpSiaAwMKbwUsnQRa+VEcWj
         79/lbHA8aN4A0s+5wfdlK8ZKGCmtfQzBfx8QIziv06djzQiz9/So6UrGgXdCjBNV/giR
         ncxPZNAuGW0Cgdd/z1SICEyEdR4BjJTMlrKUHXXwrKg2IFERK6zdx6ddVpz58Svw9d9G
         rPkW5h9bx0oBuG+P8DeDhr9CKBnS/B+TKp7SX/0TKzBZw7bpRNFm6yoddD/tdWj1F594
         13v6HmU++9dnImdmKkLd8CEjLBZ8wknknBctwjhoWYrULeRne/OaRLWNM+1M3doBsrGI
         Vq3Q==
X-Gm-Message-State: AOAM531YcLgAwywCI9sbk+3zsUARi6AQpygqnlNKMVz48Lyoae8T5d10
        8WvExmxHpqRDCuofMiaFbcK9KHBgGgdgAg==
X-Google-Smtp-Source: ABdhPJzU5SKGapNyzKI0CK2yFJCo6WvX2bw8nj9+XXa3mLmfKUtEce5yzU+X3Pf+iEm+v6W8PnFuQw==
X-Received: by 2002:a7b:c397:: with SMTP id s23mr7517267wmj.63.1608198363677;
        Thu, 17 Dec 2020 01:46:03 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y2sm6267377wma.6.2020.12.17.01.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Change tracefs_tracers()to accept NULL pointer
Date:   Thu, 17 Dec 2020 11:46:01 +0200
Message-Id: <20201217094601.1401930-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

In order to be consistent with the other libtracefs APIs, the
 char **tracefs_tracers(const char *tracing_dir);
function is changed to accept NULL pointer as valid input argument.
If NULL is passed, the tracers of the top instance are returned.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-events.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 8cdec8e..58fa153 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -406,6 +406,9 @@ char **tracefs_tracers(const char *tracing_dir)
 	int len;
 	int ret;
 
+	if (!tracing_dir)
+		tracing_dir = tracefs_get_tracing_dir();
+
 	if (!tracing_dir)
 		return NULL;
 
-- 
2.28.0

