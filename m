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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3A3C433E8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38366206C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZTYG2u4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGPJU2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgGPJU2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:28 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41094C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:28 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id dg28so4242523edb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hcz6JMCY2WohNVrTck3zudmbEe34LQkHVJbEtMwC8vw=;
        b=qZTYG2u4/XPzcUw9fiN1Bsefb/5pZTIbhrvkkwN4iJ1GG0CCj2ZwbwS2/Lqkz6p4TB
         i9YXjajFE6nT6swaWMs4ep9oXbPksqVADubDEPhXQT46w0gdgPxSzoWzC4FukC2seWSE
         FQGIGVn6oazsHuzmQCRY8O365FdGB4jQ/cQaWmLuTESyilD94OlHYJzLFsbAK07ioIgL
         O5TFonMFFIFHFquSUIjzDS19CXWiBIZcbHtRAEesBCjV4WnGuKjj1/gfKDfomMTAJXDa
         /VvqsIvVPeq8nRgPt1oj2LDBPj3q+YPdGCFC/gKmSgjXIaw+lPI5iQrA9TCVXRH/TKSS
         5omQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hcz6JMCY2WohNVrTck3zudmbEe34LQkHVJbEtMwC8vw=;
        b=YO3T1tfxd6+QLXpP/KIFWEzjn4wspF1Eb3+BSYuYHkZ04BhbFoM12SaO0J3a7DOR67
         cRh9p4ZklwzcR1vg56eet0VDBk9sQc7XeieYaZUuBjUni7Eb3f6WYmWYMxLRrA7dWKmz
         iIN442aCnozQAxy38GwqZqu8Zzt1ki0CplnNG9jZFEYM5aPhCDlMh5WGsUZQMWP30Et2
         3xiHw1Tmyibjq0FLLIMvlUHBGAlNs3uAb/67Kwv8GnmNy2cjWP8FREfM0DawV8yrd3J0
         RFdGQNWS2KJcIhJqzT6CSdOCs/BxmHmlndLWITHCIwoqwtUbzuda/tMdVbb0cLCJQsfP
         mD5g==
X-Gm-Message-State: AOAM530g0HtWMsOmC6Pl5Txprtrxj5IoKgpw7CtkakGaEBgBObzFvust
        saXdTzlkUWXHrjhY6IQM5ws=
X-Google-Smtp-Source: ABdhPJzPR3C3smYkQm0B8YH10SDm1Gc8aQjOaw2wH3TVmJuY9YYhedSApz1J6/Y4TwAylPlutdagPw==
X-Received: by 2002:a50:ab5c:: with SMTP id t28mr3551106edc.209.1594891227050;
        Thu, 16 Jul 2020 02:20:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 8/8] tools lib traceevent: Handle possible strdup() error in tep_add_plugin_path() API
Date:   Thu, 16 Jul 2020 12:20:14 +0300
Message-Id: <20200716092014.2613403-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
References: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Free allocated resources and return -1 in case strdup() fails in
tep_add_plugin_path() API.

Link: https://lore.kernel.org/r/CAM9d7chfvJwodpVrHGc5E2J80peRojmYV_fD8x3cpn9HFRUw2g@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-9-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index f0877a7e3e8d..e7c2acb8680f 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -665,6 +665,10 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
 		return -1;
 
 	dir->path = strdup(path);
+	if (!dir->path) {
+		free(dir);
+		return -1;
+	}
 	dir->prio = prio;
 	dir->next = tep->plugins_dir;
 	tep->plugins_dir = dir;
-- 
2.26.2

