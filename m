Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B9BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446BC22363
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="seycrpfI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgFVHqC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgFVHqB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 03:46:01 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40191C061794
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:01 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so12808687edm.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jV8W0Vp/Cx9Zq1uqsKCfHMgcfN3/0lr6Ep7ZmX6dfk=;
        b=seycrpfIoFtC2KYbSQQ4WXKrQ7xYFQxnOyETcwRlZY9yW6JSzpyA73VT+8XPwXAH2U
         0wZKUIs1h7sj+NdoxiB3xursYJPRpT4tEhxlHNzR0tkJEZqMMbDKGXk+B2y4O9kKIFzc
         AuYxJKtdguUm8uoz5CM5zOys/qHIKvkHDtkNiIwryms2ecJrv4lV2begNfnk6I3bG1ZL
         DlPlotdL/5BeW+em3kFpnowIbdJKJWCS/vU3K0BlUhlsbPUpY39Fil5dhsUrmmKvLErR
         sQpfzNf0xWk1g1A4+NIVQ/0Ip8pZM7zOX7ZCBRR+rWjZk0tki8HTj7ukdOPwkktRva/Q
         5vmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jV8W0Vp/Cx9Zq1uqsKCfHMgcfN3/0lr6Ep7ZmX6dfk=;
        b=YlYyuw+vzKQHzu3Hg4KD4nCpD+JajWJsBa5lPZ8yMEtdU511ohBNcY0mvDLDZRuv+m
         kcQozy/o80ksxxDXTJJpdA2bCh8/yq5epLKpyEqGL1Gdmhu9LjQBh7k68IW+0aiJWy5M
         ipeMCYMaKK7R+WY47SQR3FxIxOg6dkwOilz4yf/m5LpXpOoJmxEfxBxNa7itDsD/YL4Z
         k5Tqtv0lMXLxN2f2HgTN8NGiQDU4k4eL0utw5jlBgZ0m9oo0h+ur27UYxS5fgx53P11n
         w8awIDql+DY2HJggk6Td5TEFyrCkxSgKvFRo3r/gFCUNzLMVMXJCLe4ri3KPtiCSLKkA
         vlXA==
X-Gm-Message-State: AOAM530VGC3lwERX6XuBLHWlvwMQI1aNBpzq40TjEkJsmVkCL0C/EZOr
        /2zQGyRFqTX+gVQUTjNfAHg=
X-Google-Smtp-Source: ABdhPJwYIHPMIlakbsyo18CGoDJWr4n6NxK6PKrAvamSuMpuuv0qMMe0bl7NSW70CV+i8RAAN+XLsg==
X-Received: by 2002:a05:6402:7d4:: with SMTP id u20mr15386856edy.30.1592811959998;
        Mon, 22 Jun 2020 00:45:59 -0700 (PDT)
Received: from localhost.localdomain ([151.251.241.148])
        by smtp.gmail.com with ESMTPSA id k23sm11094048ejo.120.2020.06.22.00.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:45:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] trace-cmd traceevent: Fix memory leakage in filter_event
Date:   Mon, 22 Jun 2020 10:45:52 +0300
Message-Id: <20200622074554.151747-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622074554.151747-1-tz.stoyanov@gmail.com>
References: <20200622074554.151747-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Hewenliang <hewenliang4@huawei.com>

It is necessary to call free_arg(arg) when add_filter_type() returns NULL
in filter_event().

Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Link: http://lore.kernel.org/lkml/20191209063549.59941-1-hewenliang4@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/parse-filter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index f3cbf86e..20eed719 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1228,8 +1228,10 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
 	}
 
 	filter_type = add_filter_type(filter, event->id);
-	if (filter_type == NULL)
+	if (filter_type == NULL) {
+		free_arg(arg);
 		return TEP_ERRNO__MEM_ALLOC_FAILED;
+	}
 
 	if (filter_type->filter)
 		free_arg(filter_type->filter);
-- 
2.26.2

