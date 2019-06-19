Return-Path: <SRS0=4yZ8=US=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D67C31E49
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 11:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 718A32084A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 11:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdsgsTFo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfFSLt1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 07:49:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35408 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfFSLt1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 07:49:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so1511625wml.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jun 2019 04:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Phh2QwSxRue9Mx26KY3mBbUT9cJOTC3hgoWDSyhjhwY=;
        b=mdsgsTFozVPfAU+sv6qcnIE46rzXklZOJyo8faLxYH/+FeE2YgZ49YNkWJ17/JfRQt
         Kw0l+HQgCbDPYGUDOww7ISaGWZc2HqY4N6fKdLKa+xIhHNgK2h8ymE0/R2ebPqsmbv4/
         P/LiYFpP0LLkBlX+M22RMerGXj3GanP4/TFDWKmIINNZ7pRUm1lE7l+47+cy/FKycRiV
         zCoIBhzMgdsMwhVq9/v7Mk2i+L2BibDjaBhTzMhUDCphF8TxA7tP9GAtp4nFjAKhGU1a
         p3Z8/W5MbZqY8MYR11cCJNox+qv0hoRES7ixNltIHZssCEMWRHKojWtO5Dlox+0G9mBV
         9LbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Phh2QwSxRue9Mx26KY3mBbUT9cJOTC3hgoWDSyhjhwY=;
        b=eBCM1x5rFh7SfVrgdIQgP7TrMg4clg1pyyiglEFGo04fFM30BwZwrXB1i6kIgFt6Lm
         gg7i5WeCDve2EWPjX83qffpzBahWLO3QrwUBNF5hrTVfF1Rr/xdasiIZqmKsCB9jWRoT
         uY3nI5y3FdF7Nw6wmWI2S91LgHWyWVGdeLZOV/kf/ryu4PF6nHWPbRXLeDg5fPYvbawT
         BSwUdIlF04RFQc7Yo/6XfwygrgRTUHYBARcQyYpyrFkQ5EeN9AhWBZ4cE1i+/5KWdscU
         qzkUtQFQcrZBArwPf/9JYvrMzQxnLQ5i+6SoCg74IUe/lDDvhuRWfCrX26tHZNz8yjPY
         eJrQ==
X-Gm-Message-State: APjAAAVwhA0k5nicdnG4nC3xl9owqqwTyDuNpturV6oGv31ZYAvKrHa3
        O5C+u34ud6NqjA3meeAeafYjs+n2UBM=
X-Google-Smtp-Source: APXvYqx3TgiElYpCr/QHUBjWV9eW7xSnShQP+I9ql1htz849AGIWC27CO50GugFw5vZL5wo675ZSzw==
X-Received: by 2002:a1c:b757:: with SMTP id h84mr8443203wmf.127.1560944964936;
        Wed, 19 Jun 2019 04:49:24 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x11sm1313270wmg.23.2019.06.19.04.49.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 04:49:23 -0700 (PDT)
From:   tz.stoyanov@gmail.com
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] trace-cmd: Do not free pages from the lookup table in struct cpu_data in case trace file is loaded.
Date:   Wed, 19 Jun 2019 14:49:22 +0300
Message-Id: <20190619114922.3169-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

A major speed regression in trace-cmd v2.8 is reported by Johannes Berg
when parsing a huge trace.dat file:

"I have a ~1.7G file with just under 620k events (not exactly big by our standards),
and parsing speed (with -N to disable plugins) goes from ~4.5 seconds on commit
1ad32c24746 to >>4.5 minutes (I aborted there) on master.
I was talking to Steven about another issue, and he pointed me to
commit c2fc2bc296f7. Reverting that on master makes it take ~2 seconds,
so that'd actually be an improvement."

Proposed solution: do not free pages from "struct page **pages" lookup table
in struct cpu_data, in case a trace file is loaded. This reverts the behavior
for this use case, as it was before commit c2fc2bc296f7.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203411
Fixes: c2fc2bc296f7 ("trace-cmd: Fix crash when trace-cmd is executed with args profile -F sleep 1")

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7acecf3..32af20c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -987,15 +987,17 @@ static void __free_page(struct tracecmd_input *handle, struct page *page)
 
 	free(page);
 
-	for (index = cpu_data->nr_pages - 1; index > 0; index--)
-		if (cpu_data->pages[index])
-			break;
-	if (index < (cpu_data->nr_pages - 1)) {
-		pages = realloc(cpu_data->pages, (index + 1) * sizeof(*cpu_data->pages));
-		if (!pages)
-			return;
-		cpu_data->pages = pages;
-		cpu_data->nr_pages = index + 1;
+	if (handle->use_pipe) {
+		for (index = cpu_data->nr_pages - 1; index > 0; index--)
+			if (cpu_data->pages[index])
+				break;
+		if (index < (cpu_data->nr_pages - 1)) {
+			pages = realloc(cpu_data->pages, (index + 1) * sizeof(*cpu_data->pages));
+			if (!pages)
+				return;
+			cpu_data->pages = pages;
+			cpu_data->nr_pages = index + 1;
+		}
 	}
 }
 
-- 
2.21.0

