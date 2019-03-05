Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32EDC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD26720848
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfCEOjy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:39:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41929 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbfCEOjy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 09:39:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id n2so9727730wrw.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 06:39:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0rVlCilypZXtg7OYqP+ypxxyEEBDfl2mZysOVwhRsAE=;
        b=nlBRYEJGe0TWRr4GDYU8JE+B2vhBA/z0JRkmoBJGACMNGinfaD9qCgmyDjHo5lMSfA
         dEeRhAt51MDJlDfjZa5TEafFyFsGjGf/qbwekoeCDzGF6bIrGpvcylPOb+wIBN2UUknL
         qSOT2rgovzcCf8X9y9EEFcN6iyvrXCOLJGCvtnXp4zxn0sGaZltUZPU5gQ8zAnBsX2wt
         xBXdAmdau0ABX+l4PWR6O/YhTKQ8zVvOnkhNDtYLaAZJDKk1GC+++jwC9rezwREPgaOZ
         HlYt7gCnKHKfID/PMhdmvWFwTo6tq/1UHCgiBo0K69ziv1Ve86MFMtYMIvHrvirLmmdh
         H7LQ==
X-Gm-Message-State: APjAAAXJwlqDrmlwWFSsa36Q3RKFq1H0C2iQORLQG06JsYEZQv+1v4Ay
        1EC93mrt9bf0QKvWcIs9dX5zBgR7
X-Google-Smtp-Source: APXvYqxi2eBUEiYGgT67UCpbx3UayGBXz82mDPn94kft+Le8ZiK27DEtV4AwwcMJRN/cJ4MCKWWUgA==
X-Received: by 2002:a5d:6785:: with SMTP id v5mr17914891wru.59.1551796792654;
        Tue, 05 Mar 2019 06:39:52 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o12sm31908915wre.0.2019.03.05.06.39.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2019 06:39:52 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/3] kernel-shark: Define free_contex function for the sched_events plugin
Date:   Tue,  5 Mar 2019 16:39:22 +0200
Message-Id: <20190305143924.11056-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190305143924.11056-1-ykaradzhov@vmware.com>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This static helper function makes the code of the plugin cleaner and
easier to read.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/plugins/sched_events.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index 68734d4..0d6de2d 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -39,6 +39,17 @@ static bool define_wakeup_event(struct tep_handle *tep, const char *wakeup_name,
 	return true;
 }
 
+static void plugin_free_context(struct plugin_sched_context *plugin_ctx)
+{
+	if (!plugin_ctx)
+		return;
+
+	tracecmd_filter_id_hash_free(plugin_ctx->second_pass_hash);
+	kshark_free_collection_list(plugin_ctx->collections);
+
+	free(plugin_ctx);
+}
+
 static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 {
 	struct plugin_sched_context *plugin_ctx;
@@ -339,10 +350,7 @@ static int plugin_sched_close(struct kshark_context *kshark_ctx)
 					plugin_sched_action,
 					plugin_draw);
 
-	tracecmd_filter_id_hash_free(plugin_ctx->second_pass_hash);
-
-	kshark_free_collection_list(plugin_ctx->collections);
-	free(plugin_ctx);
+	plugin_free_context(plugin_ctx);
 	plugin_sched_context_handler = NULL;
 
 	return 1;
-- 
2.19.1

