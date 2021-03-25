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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAD7C433FB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD0961A23
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhCYGli (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbhCYGlK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:10 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B644C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:10 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x16so1109077wrn.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oMjD439qNlAB7PqKNkhqf7Z0VI4YUDEnQeZeV/0WHzA=;
        b=AJbGqIIMjLeG7JzlqR2aRE6fUziKOUtAP5E2nmdJS+RyoQ9t/c22WJguMEfGgaCW6J
         2HUy5XcxWgTH2UdBGIPmTKaVCaimndjg9Vp03Kgw6C9Eai7LjVUKVxI9vm03IVff3CP5
         t5xeWVOooXVKK0uxzkW8HAfGtJMJ3hPfF/kadpsDtyObCUZfoMCvNbrKuYlnfzvpg23p
         ksKCy0Hbs5GHueV2Gm44+ASkD25Pn4U6zsBP2VhVSLyhb4R9ycXwKlLcmWg5i69/snDD
         GgKFGSXiZtTz3YHh0B5aHfJp3uy2HXPKmGqMfPZ7OsIodpmDXlMiqxzRj1WStGZ4k33l
         d3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMjD439qNlAB7PqKNkhqf7Z0VI4YUDEnQeZeV/0WHzA=;
        b=j12uVynwgxu3gLdLdUmpd7clygFSpJOT5Cp1VAUDQ4i29vMom+O5yNiP47bDOAekt7
         g6MDCk5IJcXl5k1j2bO9fe8I683ZN33sVysOjyDujyAeLi1AuvEW0Zs6+Irg+6mfYfRC
         qfDFVJqrl3KvFyGLsKtNZECUHArr/P8aOtRneQk0Y3bvEMylTyZFEwqtTChmdnOeniGp
         OkARs+nrCXUuYhijmjrTfQqrYg46UL4F4oa8fhcV4pJLmaaLPLEuy9PuY4m20oClSnx8
         nyXvdaR+uFIrDUH3V40R8roM39gQUYs8CfllXHtcFuA8/cXQgx600pLsmyjBt3OnOG86
         GtPw==
X-Gm-Message-State: AOAM531wkH45oCMuYNgn91/nf/q78QE05apWMAvGcu2YJQdf4Oey4wLe
        JDCmMqCnSXE1302ehuC85oY=
X-Google-Smtp-Source: ABdhPJx1C0s8TRQXAvL5nV9yCZcORRT8/YjnIMxwv8crYSIQD0h/7mQFG9WUa6F9+NlTrLgILWDMaw==
X-Received: by 2002:a5d:6cab:: with SMTP id a11mr7143401wra.419.1616654469069;
        Wed, 24 Mar 2021 23:41:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 12/23] trace-cmd: Remove unneeded multiply in events timestamp reading
Date:   Thu, 25 Mar 2021 08:40:44 +0200
Message-Id: <20210325064055.539554-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the event timestamp is converted to seconds, the local variable
that holds this timestamp is converted to seconds also. As this
variable is not used in the function later, this conversion in not
needed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 67915f25..be8a7919 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1932,10 +1932,8 @@ read_again:
 
 	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
-	if (handle->ts2secs) {
+	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
-		ts *= handle->ts2secs;
-	}
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.30.2

