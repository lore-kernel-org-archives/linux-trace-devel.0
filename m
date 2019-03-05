Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AF2C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF3C20848
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbfCEOj4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:39:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37613 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbfCEOj4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 09:39:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id x10so2773900wmg.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 06:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YeygMsLlMv7wb5bZFSJgMjSgjhS/8Ws01Ad0MJgBvQI=;
        b=Ye/8bZyflydEHNG/CLFITpI01Bo0qCkUH2mikpMONfjvejnnb33cHvuK2cuzlJf86z
         Gpfq1EUlNe0HFzEM8rZG3+0pGdbCE0IHbBUktCEgAt6LM80qZAtNanjG1h0i9GkVz5wX
         Ps26Nb0fHEC1nIjRbNeQEIpG5EbIJGBAPudWMH3RwbjPSZGtS15Ykka4R4/bhkMBYzeS
         fEbjRccLIxiI6thEPl3P3KO0P5L4BVT20ItFJJGJ49nhWKU6JUZVLww387lmXBWvwj+6
         O8DxMvsWPgv90cVEXVlAAQ4pVkYfrmPLrxRvZJitLxLaxtTT/hEcLKOODPu6LlfObGzp
         6AHQ==
X-Gm-Message-State: APjAAAVS0G0O4p22fP8IA3jUjUOxiBJq0i020qBRMgDXvFICJ6kYaaRB
        ImVmpE+okWRrgR6/JoINUp0=
X-Google-Smtp-Source: APXvYqwsCIAsqDoUB5asZPtkACWAcR4gvB4X56F6JbcBHvnU2NdqAQ6LVVOP5nJujuYT6CINXjmUTA==
X-Received: by 2002:a1c:a688:: with SMTP id p130mr3156798wme.53.1551796794182;
        Tue, 05 Mar 2019 06:39:54 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o12sm31908915wre.0.2019.03.05.06.39.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2019 06:39:53 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/3] kernel-shark: Fix a memory leak in the sched_events plugin
Date:   Tue,  5 Mar 2019 16:39:23 +0200
Message-Id: <20190305143924.11056-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190305143924.11056-1-ykaradzhov@vmware.com>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the sched_events plugin fails to initialize not all the
memory allocated for the context of the plugin is freed properly.
The problem gets fixed by using the free_context helper function
defined in the previous patch.

Fixes: 4f392730e ("kernel-shark-qt: Make Sched event plugin use ...")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/plugins/sched_events.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index 0d6de2d..fe13e6a 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -74,8 +74,12 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 
 	event = tep_find_event_by_name(plugin_ctx->pevent,
 				       "sched", "sched_switch");
-	if (!event)
+	if (!event) {
+		plugin_free_context(plugin_ctx);
+		plugin_sched_context_handler = NULL;
+
 		return false;
+	}
 
 	plugin_ctx->sched_switch_event = event;
 	plugin_ctx->sched_switch_next_field =
@@ -320,11 +324,8 @@ static int plugin_sched_init(struct kshark_context *kshark_ctx)
 {
 	struct plugin_sched_context *plugin_ctx;
 
-	if (!plugin_sched_init_context(kshark_ctx)) {
-		free(plugin_sched_context_handler);
-		plugin_sched_context_handler = NULL;
+	if (!plugin_sched_init_context(kshark_ctx))
 		return 0;
-	}
 
 	plugin_ctx = plugin_sched_context_handler;
 
-- 
2.19.1

