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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551D1C433E2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 315A720BED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ftvVnWYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgGNKae (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgGNKad (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:33 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CCDC061794
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id br7so7140997ejb.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/PgwyIv2vHoWG0mPE0Hb/mlAaSJmCHcX1IdjRgbhDqU=;
        b=ftvVnWYYgR0c7uYtUHwt8xbdZ9cjy19taN/wvQ8jp+u3fRZo55mdAyJrxeTdYDx/Lq
         LOMQ85wxV5hJ5w9k3di1DLHW9IDe7ZQOsRP3P0Pwizv8t0oawX6sDYAaDVtVZUNXKh2G
         EZBaUnNM1eGUpgNZ056pMPamw0nNThTiompgjGr4o8j3z9eCIjHpQIrIRz4TFJUuhKkZ
         9OS6tDUrFmd/0uAhGjnBuFMPndvNVQ4SFplSCLu0sLgbcFE2n9u5otHrSS9AEgfj3wj7
         e/m64nMmJc7DA9uLyhOwiYMIidP3jLMgYaZM8TFIO9m/xbQYfYixmPy22Zo/Dxdi9pt0
         TlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/PgwyIv2vHoWG0mPE0Hb/mlAaSJmCHcX1IdjRgbhDqU=;
        b=nUN4x0Hy669vDAsaWShmBMgNst8R29eAL8DRJF57Tr1tG6cp6CkZUnGqj1ixW4t6GM
         dqqpeb53HFjz6w4dKdd0+1VGLZTKPC6WBE5IjrG+p31Lg/hDa2AEMgzspzNlVHV0ZFa6
         inzFK72h53K+BvU5lYYfIKeBLVEc7IELxgu+yZRm/TidC3/ZBPA8COofoNutgYaaTyPL
         iCTyx5dVHWW7w2Kl6uoqaKA7dcuo9NxWtfQaTbTJcXbAdrmPlmtGs6RoesZID8dc3Cv0
         fNMOfPI1nax+AnjZDZIgpEge4jO+0Yyd91SgGvpi7VtQxmfD1mM/Jj6uJ1uxUR66cr1U
         hOOw==
X-Gm-Message-State: AOAM533/1LM2dzfrq9bkkJu/gA0yY1mpqRXHSl/wqWyd0s+dbqo8wRWm
        gMlopvzbq5SQsQ8u7rOB2S8=
X-Google-Smtp-Source: ABdhPJxcRMxpUszishbtkEB2bHLckRnttzzvX62KYfGOhZc1d6Cl7jCDJPDe/PxFq6uB5TC5EA/Wpg==
X-Received: by 2002:a17:906:6004:: with SMTP id o4mr3913196ejj.411.1594722631894;
        Tue, 14 Jul 2020 03:30:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 1/8] trace-cmd: Document tep_load_plugins_hook()
Date:   Tue, 14 Jul 2020 13:30:20 +0300
Message-Id: <20200714103027.2477584-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add description of tep_load_plugins_hook() traceevent API.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 30c1526d..c11636ce 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -544,6 +544,22 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
+/**
+ * tep_load_plugins_hook - call a user specified callback to load a plugin
+ * @tep: handler to traceevent context
+ * @suffix: filter only plugin files with given suffix
+ * @load_plugin: user specified callback, called for each plugin file
+ * @data: custom context, passed to @load_plugin
+ *
+ * Searches for traceevent plugin files and calls @load_plugin for each
+ * The order of plugins search is:
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_FIRST
+ *  - Directory, specified at compile time with PLUGIN_TRACEEVENT_DIR
+ *  - Directory, specified by environment variable TRACEEVENT_PLUGIN_DIR
+ *  - In user's home: ~/.local/lib/traceevent/plugins/
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_LAST
+ *
+ */
 void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 			   void (*load_plugin)(struct tep_handle *tep,
 					       const char *path,
-- 
2.26.2

