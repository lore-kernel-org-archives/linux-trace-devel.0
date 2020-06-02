Return-Path: <SRS0=8+AL=7P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A19C433DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB604207ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Jun 2020 14:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGWMfTik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgFBOSV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 10:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBOSV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 10:18:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48EAC08C5C0
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Jun 2020 07:18:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j10so3573125wrw.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Jun 2020 07:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fzjowpvh2Pi6KtACb2XyjwLGsViu1RiXohbLUScu+Uc=;
        b=PGWMfTikUQCT+kHB/haVCBvZFqPErUI3Rmf8qZs7QpKYBSnu3sWDwVT8/LTBgICiqo
         gf8yxwRXjybKitCp9o+nphCdI09ubVyFMZKbn6A1ertl9OpLk/ffmargLqU8A9ELZSmO
         4KKtDvKieDPyk3UfrGXF99wXjCX5qK2R+8zGx+5acESGu6TT6nt7G7N8wBhnqI0spKkx
         mnS9Cxj5QtSnGU2vFDZvmBr+b4c9nuVYxVXyNXtCHzrxYy6p9WQY7ibJrXy3E0FVTzWX
         K8pdnFxNgyWN01dDgW7onyyMJHDO5QHo3Pg68B8jZFqtdOQsnzOY/HxZQvQqi+v9oOaM
         e9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fzjowpvh2Pi6KtACb2XyjwLGsViu1RiXohbLUScu+Uc=;
        b=kRexYZz7cF1o5tKmgVoRTAYd1C01XzHPKAieuxP3q2ITYVhKHLJp12Fq+srhcqkZPh
         dJuI1aVmBnZwis6NQFivO3JD6xgqZTubSWiE0/mmTpsOlmvNaSRUkg3/5GTNzuCYowAJ
         k7OVKgF7fCXAdlRsTJeUQsnVaocun8MnYlq1N8RzEgF6yTTOqH9Q2103nr9cnt3pD1hF
         rPK4an77YqymLXwtK4P0r6a5t/pdLa+btKoTTqSlQI6M3hJ84xNwYQmOeqLGXy3shcvt
         BUx/7P/kwUv7AXRVDMnevMZf8OEX0exPhWBT4zTTcAB5lesLLtjTOn4dCpSo8BT3Y5f4
         cTIA==
X-Gm-Message-State: AOAM531z9yIY9z18sY1RqzR9CywpdOVMIvOKYDsp9mgsqM8bu8if9C+I
        YukH9tZfM1Azo30ViT1bv9zKiczBYJI=
X-Google-Smtp-Source: ABdhPJw8uIRJ9viI1kR0HukcSssjJgG2Wjh2MCdkFJ3YGNdSAEz4bSBFH3UfrOhyWlgMBc7HQWFMSw==
X-Received: by 2002:adf:fd4f:: with SMTP id h15mr26221053wrs.397.1591107498397;
        Tue, 02 Jun 2020 07:18:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 23sm3884730wmo.18.2020.06.02.07.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 07:18:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Add description of "-G" option
Date:   Tue,  2 Jun 2020 17:18:15 +0300
Message-Id: <20200602141815.80269-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented "trace-cmd record -G" option in man page and in the usage output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-record.1.txt | 4 ++++
 tracecmd/trace-usage.c               | 1 +
 2 files changed, 5 insertions(+)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index f5ecad5c..99d1a156 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -312,6 +312,10 @@ OPTIONS
 
     See trace-cmd-profile(1) for more details and examples.
 
+*-G*::
+    Set interrupt (soft and hard) events as global (associated to CPU
+    instead of tasks). Only works for --profile.
+
 *-H* 'event-hooks'::
     Add custom event matching to connect any two events together. When not
     used with *--profile*, it will save the parameter and this will be
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 0c0e12f4..63d6eb41 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -53,6 +53,7 @@ static struct usage_help usage_help[] = {
 		"          --module filter module name\n"
 		"          --by-comm used with --profile, merge events for related comms\n"
 		"          --profile enable tracing options needed for report --profile\n"
+		"          -G when profiling, set soft and hard irqs as global\n"
 		"          --func-stack perform a stack trace for function tracer\n"
 		"             (use with caution)\n"
 		"          --max-graph-depth limit function_graph depth\n"
-- 
2.26.2

