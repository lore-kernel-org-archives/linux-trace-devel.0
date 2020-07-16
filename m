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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E3BC433E7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878CB20775
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OPlfyQZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGPJTd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgGPJTc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:19:32 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4CAC061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:32 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n22so2886086ejy.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vOA7/364VqhUWR8wM7k4GMTaH+ThiUQtUcr8OAdQdbU=;
        b=OPlfyQZ6e/bgDTzZRtxwz8+Z5S+S4NX1n3bqKozgO6IuHPRWgrSCjOnkeMaUCHQIi6
         EK1P6I/UzkEoYSZ4UDTCnCmx+kYuAudUAwZzKofajmQsDjnuqKndauE7LEL78MJHUUSM
         SpNGhboEYLmL9ZNC4sAteV/nf3sth69hZPe7tnKxhi9iqEJUkaBem4Mc7xOKt5ILIBXO
         qbRfncxK6B7ps2bNxJ1+SnpzOB1CpwBiJE9rynt+TKhUhiiDm01oxevX79vKow66Vlfa
         PWDmyQuKRSLVyDWC0giYRWDLRaG2cp+hRoKWmXM4TbMxiUq6St8T+QsRCRnLW9pdHIVw
         jN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vOA7/364VqhUWR8wM7k4GMTaH+ThiUQtUcr8OAdQdbU=;
        b=rjrfHGvh9c1EIutuIC5zVUJ/cKpEAfIKaEtmh0QtliZrZK7n5Pc6GAwKtUZyVngp8Z
         4hY7dY/KqVtWWxtNlBHdii1/mam6V3k6Lt1oH8/sYuQ7uGY7ZjUJ88LWsEA31eStliaD
         aSR2w1wRZ50rIPngTUT0hcyJk4R+m6vIZgeHh5IlcBUTwjxm37FGwkNrYaDzoLsZAnWn
         XJ/Wfzg0BrnsEWpJX7AcqEMCkuPWYl73K0AvhToHQDr1ai1CLbKA48lfCHSchU04tJGL
         7OSk/YkFd9Y8J0XSzw/3DNAiEO3zR/mrYF7RgePogotgNfdx25caWn7v/DUMuBD0cUk8
         5RHg==
X-Gm-Message-State: AOAM532b4XBzMIi6L73IlzjI9sM+7aiYjz2zy1wfoEjQotd8fhjFuoJK
        5DS09nJD5sD0XOiz1yG9nWoE///yGaI=
X-Google-Smtp-Source: ABdhPJzENAs4GJIpOTY7y7VlDfutat+3i1rTxovwtaftfo1ElM0jv5kGXBd5HEQYKeTq+M7eptGTHQ==
X-Received: by 2002:a17:906:8542:: with SMTP id h2mr2744096ejy.517.1594891171359;
        Thu, 16 Jul 2020 02:19:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x9sm4431534ejw.28.2020.07.16.02.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:19:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/8] tools lib traceevent: Improve error handling of tep_plugin_add_option() API
Date:   Thu, 16 Jul 2020 12:19:19 +0300
Message-Id: <20200716091923.2613228-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
References: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
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

