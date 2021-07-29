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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E80C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FD861053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhG2FKN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbhG2FKM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC577C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x90so6371877ede.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JxTSEBNOlrS5WTwoLvfCQN3gMd4AoS1/057XdddjCRU=;
        b=oMqY01dDCzk+fSRFK8skIYjzLnqrPtPEfmHBB4TLU8aC/oTx7Y3wqofNJW9l8O2Z1o
         xNK5WSofNOrfX4d2bYMJpeAQbggp3VYXYuERrO6rL89i7UnJf+aaPgFUn8yuLtGwWKCG
         Ah3Vg9Afy2DJxiyc75vb8yc4D+kOCTy2nohWenCLzLOVsCcbDSCuE5intDH8LwMhA9U5
         U2qImlngFfdtLMOlphy5eWzOFyXJF8SNwazFX7YljIL5MCNTp0kWBt6KFXjeUao4DO0s
         9PtOsNm7iqvslWDnmxSl3ZDqo2i5LB6Xo97TTL5hfbpFsO/crTSSHlDK4nDdxmMoLiky
         XP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JxTSEBNOlrS5WTwoLvfCQN3gMd4AoS1/057XdddjCRU=;
        b=gydraWNeMgSUInSsGJv4WQK1toZ5AYROvfaubK5Bt2dbxkKYBUrNHtP4GfcOxEWRbb
         Wr+xI5lOfSeVj7THz8SeEfEweQ2ZUJ+87Jm+OY0/HHXWX+sj0qJsQMXVxpNsGQdcfecc
         Ka+fsRHkq8StVqBnS8RTLsseOJUWuBc51S2m2qX2FHIo/o6Z/pXbIMTDut1hDnOZWc+I
         7YiXrYdtfvY9Lgoe6dPBD7Whx8HIPdq9xowI1MpZGGv4RoBoPQMTeT4RNqAQ0Y2nPOlx
         kLTb6L+WO99qgeL7LwfINnHntDXwKK6yUgs+/+zJ7xpit7UzdtpL6iNXtmnLO2kyj4d+
         cbiA==
X-Gm-Message-State: AOAM531pRW8cdqwU2y1gDGU1Wj7T+kGG7k3bWwWbkrkH+iURfnHS2CBs
        IavPxKQRJxusrx0HLHFJKRc=
X-Google-Smtp-Source: ABdhPJwfzQNnUO38nCEVB8tMX4pOcQc6hBG0Bdw4lDP5kXuvUS3AvKXR++BUUrvTatFyyuVb974D9w==
X-Received: by 2002:aa7:de92:: with SMTP id j18mr3895929edv.141.1627535407645;
        Wed, 28 Jul 2021 22:10:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/87] trace-cmd library: Add constructor and destructor
Date:   Thu, 29 Jul 2021 08:08:38 +0300
Message-Id: <20210729050959.12263-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added empty constructor and destructor routines of the trace-cmd
library. They will be used to initialize and free compression context of
the library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b0c98c72..0f49a21a 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -624,3 +624,13 @@ bool tracecmd_is_version_supported(unsigned int version)
 		return true;
 	return false;
 }
+
+static void __attribute__ ((constructor)) tracecmd_lib_init(void)
+{
+
+}
+
+static void __attribute__((destructor)) tracecmd_lib_free(void)
+{
+
+}
-- 
2.31.1

