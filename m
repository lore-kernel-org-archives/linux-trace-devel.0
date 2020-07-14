Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C79C433E7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8295720BED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCruk4G2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgGNKah (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgGNKag (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:36 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A780C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:36 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so16457444edz.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iE9gll+SY41Am9ztFMMTcM8u+I8iQO5hjgDgbWgQkCM=;
        b=dCruk4G28LqdzOX3wOAilctFuH0bCDRyxPKoUPd9U+ARxRV0f0dNKWPOEQ7z3ryqXi
         n90uevGcWBDXBR1RQvEWJ1BGTLuzURgRrFcd7zQqHiCiPaQyV2AD1h/8+RDueif7+DIM
         jp4xhT57KUSr9NKzzUa47gUwkkeJ11YJjNFLMyJifvWHYuIQ0ONnBoquG4bkYOMjv5ln
         G27WUtCcoC9ByNY68hRo1mWQhrcB+pQuVUpgmDMJaqVPSbFOn4NBn2jSxekQ0zii2fcC
         37SvOV4TxBUZ56WnfNab+s7crUnRvFJktQP6+YgoS79dCs50o+DfRTwwFiz2s8f87HBv
         e63w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iE9gll+SY41Am9ztFMMTcM8u+I8iQO5hjgDgbWgQkCM=;
        b=Zz1zzMmZwpRzbgJJIoGaDgYUwG/UhOxfJDagLvGZbHE1ZDQUp245O2ZPGBolJK/JMo
         NgpLfjSfhTKpQH+O06WBJE9thF4CPycjwAu59KE4Y4kR8NXTquPpPyPR5LEN+sHqIt09
         KRppmoueSf2OPAb6UajYpFWOvHgTU+MDlkgIax1pJAN06K5bM/Jr5UybuErmSS3UsDb2
         gX6XgS5YcbmIk2/oiKj8gVU3ey9PLwuBXxhImP7PZo7pEAnu310+Gqm/CpI2+LVtQLVg
         fh6Y37QTS+sNNkxJHEiYCHIXf40EhOR/wvBj63ONmM1m9LNNE0lGtuJIQz4McoCIgj4U
         71QA==
X-Gm-Message-State: AOAM533dDbZkms4q0BQkmuKE+tr3wSPEe3k1UkihlUp2lMYB2qTsYY3F
        vrC1tkc905wqIx/WDpedYs0=
X-Google-Smtp-Source: ABdhPJwTOj4Y5vH6d/xRIwQoc3wnwTItwuwP/4s56C+YoUer8pCiQOtkw8j2g9X2pinuhdsrNI9wkg==
X-Received: by 2002:a05:6402:1803:: with SMTP id g3mr3564557edy.377.1594722635429;
        Tue, 14 Jul 2020 03:30:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 4/8] trace-cmd: Improve error handling of tep_plugin_add_option() API
Date:   Tue, 14 Jul 2020 13:30:23 +0300
Message-Id: <20200714103027.2477584-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In case of memory error, ensure all allocated resources are freed.
Do not append broken option in trace_plugin_options list.

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

