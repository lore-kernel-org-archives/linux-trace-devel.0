Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42767C433E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2199620663
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7o8dV65"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGOCaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgGOCaT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:19 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EED6C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:19 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lx13so563097ejb.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZwQuoGpC8/GGDi2D/ZFI+cfkU6KEvdYSRGGypOLXvs8=;
        b=j7o8dV656eoCbEZ6baiDDbAX08BM2hRaRUjrQgeCmlwAt3OdkjvIyUZfou+i9fcJNG
         jHiFDckwUecZDaZT4xWzb6eNq1nRNS9dr9eK8+Xlobx7CsaaBk6eCeKYNPRj7CyMo2Hh
         t7udrtQ2/sBDfgjeu4qAmfxFnC1MHbx0LCAg3GdlNfpiiOKUDRMPt+mLZREFllRLP99A
         n3Z59vPlePLSSpk7hzZST02ZpGDZk1USCC446Xkati9xgFyIGYumG0BgrDDxcfej8ipw
         cQLLqV8knePlL9pn1iCyS5kYQwqJM1fNkQbgMRlGpzE1ORNbza7oUw+tMOrzbtVL+vEb
         fBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZwQuoGpC8/GGDi2D/ZFI+cfkU6KEvdYSRGGypOLXvs8=;
        b=emYCY91rbU0uFxw/tKfdEINE2VUrLVldoaKWNel2xlOp+ljTeIWAP58nKmhQFWQfVm
         kIsK5HGJoGqthIfe+toQJiYdjGtNs3F6fjeMs5D4iomCBA+CVXqX0iQ5bjBqIbdd8aSL
         OfUPv5uysa38K+tQZ9rkeH4gMphRc2w5dyWROxFzDAOLeroVcZolm9FyxFoR9bHBD/QL
         9MBB7ACIZWTqbTybY2IJMAHrPIEyDaaGkgthmkV2gTk1DhxX7m049J9MGTs7eapmwM5p
         WXbL/VG0w7KIvA5XSu8DtcrJe8YfTod2FyljFoK/RerogxYSXyW06RMGYCYZ7NfQ9UWm
         MNzQ==
X-Gm-Message-State: AOAM5335haA7ORb+6aufs9BEwZOtMQitYiv0gEVqjaPiG6qfXkyCoO1o
        fUjdHywEgNyNC9r69EcfzA9psuo3cug=
X-Google-Smtp-Source: ABdhPJzA4AznaTK8YKqKJjxxFJlYf9rJ8kR+5+lZPLvyNBAWhgMfk4KlL4MeK7PhmrNZlFNHdjSyAQ==
X-Received: by 2002:a17:906:c083:: with SMTP id f3mr6876701ejz.530.1594780217847;
        Tue, 14 Jul 2020 19:30:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 4/8] trace-cmd libtraceevent: Improve error handling of tep_plugin_add_option() API
Date:   Wed, 15 Jul 2020 05:30:05 +0300
Message-Id: <20200715023009.2503879-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In case of memory error, ensure all allocated resources are freed.
Do not append broken option in trace_plugin_options list.

Link: https://lore.kernel.org/linux-trace-devel/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com/T/#u
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 03f26c8c..aa868133 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -361,23 +361,25 @@ int tep_plugin_add_option(const char *name, const char *val)
 	if (!op) {
 		op = malloc(sizeof(*op));
 		if (!op)
-			return -ENOMEM;
+			goto out_free;
 		memset(op, 0, sizeof(*op));
-		op->next = trace_plugin_options;
-		trace_plugin_options = op;
-
 		op->plugin = plugin;
 		op->option = option_str;
-
 		if (val) {
 			op->value = strdup(val);
-			if (!op->value)
+			if (!op->value) {
+				free(op);
 				goto out_free;
+			}
 		}
+		op->next = trace_plugin_options;
+		trace_plugin_options = op;
 	}
 
 	return process_option(plugin, option_str, val);
- out_free:
+
+out_free:
+	free(plugin);
 	free(option_str);
 	return -ENOMEM;
 }
-- 
2.26.2

