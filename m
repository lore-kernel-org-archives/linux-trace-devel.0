Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C68C433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8642074B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="INAvKLhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgGPJUY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgGPJUX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:23 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E179C08C5C0
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:23 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so5776351ejd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vOA7/364VqhUWR8wM7k4GMTaH+ThiUQtUcr8OAdQdbU=;
        b=INAvKLhPuDdJuBKiBoir3rZNAws8aH/Fzk7PFu91dr2pmhLk6gG+0c8Y99rOddDWm/
         g5jvB7A6Rbugxzpa+xkhUhupwt8G8hqPR5F3C8DeCFdfiJ+qvRoL0ZWbKfUJtI4ngnPV
         DDqEpLE++F5chqLMMF1RXQt5b+DXA7yOMMIutOS4z9rJE1/0pTBipoESH07vQfQR89Rb
         K79tALQBAukdw2zFazFSTuSFyg8K8zWwXTlFQxIC3qTqAUKoqcju9bOki7+UAFbm4uXn
         7xML3LEv4Nldx3ZzOxORk3w5ACER0ZlHTkQApWkqTb9hmjIfWfknoBeIglpwhbjKPWGP
         RtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vOA7/364VqhUWR8wM7k4GMTaH+ThiUQtUcr8OAdQdbU=;
        b=Dk/rljcjoidx4kIjtpwV4TDDXjOgPdn0JMU7BPORf0a7s36b4nLRF2/pERYUHBgwNR
         +ttZUASoXeGrzT+nP9q67DsuKhK9RdLvEhpVVCRUPwmeiyMraOZCChVCMiKJlx1YGndC
         j7GmJxCBGHU82nPjmPL5h/AXFX1OmH5lkbgaJYglPmZqzrA3IOWIzZB720/5lQ/MmOE9
         E+T8r6xKhgYWwAQhV7AKgHh/oWRBEnKvm6fMa19pJttPDSJF2RlunnCOSKCyPXmaCNiz
         MGTCp1sb53+I79TXNKRMIRvPtyvMlG0qJ80MEeksAkXxh2b+18OuUuMuI3nsCBIvWQ7a
         OLGg==
X-Gm-Message-State: AOAM531pUFrv5YoD57zqJUVU5l2Z41HD9t/wzAylqmhvs3EOxh/QPlHe
        cOOnauIxLzwSF82NwQA5FeksNboALYo=
X-Google-Smtp-Source: ABdhPJyjzhQqrYEhjF9XY8jXRgQu4As+yHX0M5sqeXdQxJ3E3UqZygrWDuqTZTaMBI3ATPtz90t6AQ==
X-Received: by 2002:a17:906:f2c4:: with SMTP id gz4mr2777166ejb.484.1594891221993;
        Thu, 16 Jul 2020 02:20:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 4/8] tools lib traceevent: Improve error handling of tep_plugin_add_option() API
Date:   Thu, 16 Jul 2020 12:20:10 +0300
Message-Id: <20200716092014.2613403-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
References: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In case of memory error, ensure all allocated resources are freed.
Do not append broken option in trace_plugin_options list.

Link: https://lore.kernel.org/r/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-5-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index f8d253a61970..6b84b9c4e6ba 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
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

