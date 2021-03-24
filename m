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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F3BC433E1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF43061A0A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhCXNF1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbhCXNEk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:40 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E946C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:40 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k8so24363747wrc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oMjD439qNlAB7PqKNkhqf7Z0VI4YUDEnQeZeV/0WHzA=;
        b=VKMeFHYFMaEtsmgBPRExQOvHMfmJ6uZ2bd1VsuOKfnfcOEztlF1qBAoQVEFsfYCsXQ
         FwULvld9dhnEdQvhEV0cggdkZFqrM2d7wWzX/nmx0lFNVtm9ZwjyXdYzDoRj+YkBT8nx
         ruJJ8uRTW3ZlsPxu/7c+dAhgN5wuSVcLpA1v6SIH7tUHhN3GEmJeXbbtglGapSRV5HVs
         joVuR0Nxwf0zabKqyKp0tv8hEmS62oLIDJ+dP0EOLyFkvDXxgm042+MZlbwn65vXRO7a
         fhj4r2QYevecbl/mSRENZc1uupIKPvURzoJHgdzQ1m9ISxjHFiXc3zNy8sQpwsFBBDce
         +fNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMjD439qNlAB7PqKNkhqf7Z0VI4YUDEnQeZeV/0WHzA=;
        b=OWz6sZWmIb8J35Hn8mOGgP6XhWAMInpccoLiz03OAtmYL8zXsoVzjacaH4vc8h9lOU
         n9iDDBvjaYs5YWECX22d+uEz4JD9twXk6w0caTtGsyuceNqDhFNcqY4YRUDNbrrMMDsF
         qkGXEyiXC+9ktb/xKUTve6SJYH+VVFEpn8fypjWkWshF1Kq/4AnGG1GjeUuHB/67YcCD
         tNb9/TAqo+OZ7qAsIRRTShEVH0HTBD/aJBZNb5DvcMT4GMQH2Efdx0pYuF6azvHtjS9p
         ONMcvfJfjQCrGRlYBqT4UX8MIq8ax2zl/pn93+cFQWWpQQfjAb2B9bqMjY9D2LzjNHtK
         tmyQ==
X-Gm-Message-State: AOAM531e2QITR2asoai0VP7iYbXj/w/4E8Ca3h+HtV0wbppyay3BSzDL
        TzgWQRit3WuBvIjM/PooEEw=
X-Google-Smtp-Source: ABdhPJwi34ZjU0zH+0LdEjHx9uzj/1OvZmc6r0LfEDCFq1X9NfngS+1uYp7WvMulK63EavCwxQRA9Q==
X-Received: by 2002:adf:ed49:: with SMTP id u9mr3394167wro.337.1616591078883;
        Wed, 24 Mar 2021 06:04:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 12/23] trace-cmd: Remove unneeded multiply in events timestamp reading
Date:   Wed, 24 Mar 2021 15:04:07 +0200
Message-Id: <20210324130418.436206-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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

