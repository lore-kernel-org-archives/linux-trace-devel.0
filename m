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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7363C43600
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 896C661285
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhENMT6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhENMTz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64975C061761
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:43 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lz27so3045200ejb.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zUYNHfjMNsJRyZJGjcbcerI76uJyF4Rnzq4Si4Zxp14=;
        b=Sg542uTuYVYzeEW4HT0mRLUFps5pIAU3ljTnx46S/0g89h1n08rIk3QXthJkLsnFHS
         FW1eIltkav1BgzXr/4gnToqteJZzGhQoboKkHXajpxLOthLzhLKkf2ItN2ejJAr3Nbjk
         5WhJLOAvnor2oseWDukJg17Vrws527Fd+n3QS9PiNyoHb93cAgb7rSPXYA/omliBTy1l
         81U94to6VAiiqqf/Ng1Ra0g9t8pBXEM+5NM5IGgAhY68SSp3hzibJTicNwRU11bJtO53
         /WSGPMgxk9hTP+IAf7KxjOz0PRzq9mhHS6m3SLjxFkpJI4shdd4IhATgpiCdTDSl9kEc
         Bohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zUYNHfjMNsJRyZJGjcbcerI76uJyF4Rnzq4Si4Zxp14=;
        b=QjFx7hUk2oNnAaNdEBi4gfvb/Ifwt3hXDNwkjQnR+k51pYcVnfpDW6kw3xWiLqWbc+
         vv+rsvELDqLxOvM4BsVM0cHLqHmG/3MZttC2ro8rLd2FeSyFgtnbpH9SdJAOzQR5MaBp
         INX3fhO54B4MwkkAa7TUhgDkocGy2QqFOkKRuaSnKMsFpSmivXu1Oo9T77moFB+ECKj6
         De1miF0c93bq5kU9GPUbAQwHAnHeJNxByKltwIMo7+lp/QossmZCIiAhViwz0cjgGXpA
         b01XHnnvWKbLhV9mf8PB378bBu7yqYtVjXnFTeeH4JM6/denqoHrVb/VMr2f80EMSVuk
         cEfQ==
X-Gm-Message-State: AOAM531BcA6lJwV4f3pZmjWshi1+RY7nSHWZWfG3SoPunt6sFLcczRmH
        UiUJxbBkeHVnzeZN6OUUy507aNFcOFM=
X-Google-Smtp-Source: ABdhPJzus4t4AB6Mp2jif9ZnTuBPRR8XdnBDKo5TPlQ9aqbOPONgXYGWyMlLSMwD/kufaaVzLVaZYw==
X-Received: by 2002:a17:906:63d2:: with SMTP id u18mr48831243ejk.186.1620994721850;
        Fri, 14 May 2021 05:18:41 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/7] kernel-shark: Check if "trace_seq" was destroyed before using it
Date:   Fri, 14 May 2021 15:18:25 +0300
Message-Id: <20210514121826.161749-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When closing a "tep" data stream we destroy the "trace_seq" object.
However, trace_seq_destroy() sets the buffer to "TRACE_SEQ_POISON"
which is different from NULL.

It is unfortunate that TRACE_SEQ_POISON is an internal definition
of libtraceevent, so we have to redefine it here, but this can be
fixed in the future.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index bc5babb..4a84141 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -29,11 +29,17 @@
 #include "libkshark-plugin.h"
 #include "libkshark-tepdata.h"
 
+/**
+ * The TEP_SEQ_POISON is to catch the use of
+ * a trace_seq structure after it was destroyed.
+ */
+#define TEP_SEQ_POISON	((void *)0xdeadbeef)
+
 static __thread struct trace_seq seq;
 
 static bool init_thread_seq(void)
 {
-	if (!seq.buffer)
+	if (!seq.buffer || seq.buffer == TEP_SEQ_POISON)
 		trace_seq_init(&seq);
 
 	return seq.buffer != NULL;
-- 
2.27.0

