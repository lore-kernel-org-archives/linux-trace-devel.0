Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D940C00319
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE1D20848
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfCEOj5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:39:57 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38552 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbfCEOj5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 09:39:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id a188so2768003wmf.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 06:39:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M9JnMyn5P3axmb34AJFL3gpoI921pB4YzqxxZYAOFcU=;
        b=E/wV5wJup9I2jh6tiPBAR1E51pc4JqyxTmSeORJ86bE9EpScCDV8rzVsoQ+onfPaeU
         MYtvDTB8Z6m/Q7UUTdZRhGGxmVRRdLrFCz8soVibNnL+zMBo0DtfblXR296HuwHB5hdJ
         EEOYjJ1DU6WjPepn0XK7rcu5+kVICKlN3MR07rrHHCvBp7MGm8502/y3EXTBriTWYftp
         DvlyKFQNyYKppq2nIuW+ABpwBhS+LKLuLkgfkbpGKhqECJfJZgBpGdfGge6Y4ogDnwsv
         t7PWKr+fyQ4wShOPt+H7tJOs5pSB3e/hjSz/hvLiowDJKcYfdgXFcCNVQlUDVgD/RcII
         1YKQ==
X-Gm-Message-State: APjAAAVA0KzenMn4LMEzQ4FMjPVjxJVtVbFGVaiglgHY+VStOtv3LLxs
        T0zc0xV9tr4Sr78GVAibdn/pXpaO
X-Google-Smtp-Source: APXvYqwnqIDotaWADcBUViyncAoSLZQoxmCSmzXeIUGwkdUZZXPXuhbiUHlDonKT0OOuFD6AL2El5w==
X-Received: by 2002:a1c:cc0c:: with SMTP id h12mr3230587wmb.140.1551796795542;
        Tue, 05 Mar 2019 06:39:55 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o12sm31908915wre.0.2019.03.05.06.39.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2019 06:39:55 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/3] kernel-shark: sched_events plugin init with sched_switch events only
Date:   Tue,  5 Mar 2019 16:39:24 +0200
Message-Id: <20190305143924.11056-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190305143924.11056-1-ykaradzhov@vmware.com>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The sched_events plugin should not be totally disabled when the
wakeup events are missing. The initialization of the plugin must
fail only if the trace.dat file contains no sched_switch events.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/plugins/sched_events.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index fe13e6a..c52fb29 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -104,9 +104,6 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 					   &plugin_ctx->sched_waking_event,
 					   &plugin_ctx->sched_waking_pid_field);
 
-	if (!wakeup_found)
-		return false;
-
 	plugin_ctx->second_pass_hash = tracecmd_filter_id_hash_alloc();
 
 	return true;
-- 
2.19.1

