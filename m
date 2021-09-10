Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18492C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF589611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhIJNtf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbhIJNte (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:34 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB048C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s25so2639488edw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rgKSGpz75JPloOaC/1DcOk+gg+XSb9yeocHeU0wjVV0=;
        b=Bu18nqmn7KqMt9RT+JL1afVPqpUmApc4TYP2o7fjgZJ3KMYggyTTwMXsJgFfNsmWjz
         +pMB+slQfJ3KwJw61QDRBOhuEqGTv5GPGRDUUmHD7UV7cnmX8xX6CWnG25YAIukfW12o
         5yar/bPJ1xjXiK+infhjdQC6XHmBW7gk9PxLpNhjdY8E11CfRS+L5GAX12soVcGoPu5G
         zmWPb2VleWgUqVjliiDix8pz7xyZKPM/A142msOybgCDYKSfuv0H8glMk+j1rEL32gjO
         Xl54QZ2YTEXSdY5nYQ7HyH56F3tJLtcrmigtsNRQ9uDNAERzbtSSD9VyoiMWRuhwqTyx
         kRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rgKSGpz75JPloOaC/1DcOk+gg+XSb9yeocHeU0wjVV0=;
        b=z9nChthAUgJk96TZHF7qgSX7PKiwEKb5UrD9UfwPAqELafcxNDpCfiT9C4Z/TxfM9V
         Whn5XwTqkZU2eM0BLkzA5V4lfHxvMrHdbvl9s+fe/FWfhAOfkA7L17bv0U6VNgg52xs5
         bVJhbBrK4/Qnr2xYu4F/iEetWUXBfqleylVum9iULz1AynyDG6RO/B0B9PASuH6MVImI
         Wqjt9WgyVpM7PjFap15rTssitvVxY8PkmMB52m42V55GiUYCRWyg+zoNxQRRun2qq4eX
         VbE+ugVPAvqR9qUifEvkuw1GajpYCmzb7x6A2J4evbGSVcPajLyfZfzNYXZixp807XMy
         bMNw==
X-Gm-Message-State: AOAM532MSw6Gtg28PhY5OJ5FXo7l8LRgIHxH6m13zWpL/mfKQaUtABop
        1qGGXawImiJXG+S2sLbdUSHjcdSL+f4=
X-Google-Smtp-Source: ABdhPJy8HZjkVvkS+auJ6POQYSUUkAfQMi2/dD4OiOZYfV4UvkqWEKefubOBOgGMwvGSW0qXlsPQZg==
X-Received: by 2002:aa7:c782:: with SMTP id n2mr9262699eds.77.1631281702422;
        Fri, 10 Sep 2021 06:48:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 21/21] trace-cmd report: Init the top trace instance earlier
Date:   Fri, 10 Sep 2021 16:47:57 +0300
Message-Id: <20210910134757.2863982-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moved initialization of the instance before call to the tracecmd_cpus()
API. This change is required for the upcoming trace file changes, where
CPU count is set when the trace data are initialized.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 02f75cb9..f7ffb89e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1215,6 +1215,11 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	list_for_each_entry(handles, handle_list, list) {
 		int cpus;
 
+		if (!tracecmd_is_buffer_instance(handles->handle)) {
+			ret = tracecmd_init_data(handles->handle);
+			if (ret < 0)
+				die("failed to init data");
+		}
 		cpus = tracecmd_cpus(handles->handle);
 		handles->cpus = cpus;
 		handles->last_timestamp = calloc(cpus, sizeof(*handles->last_timestamp));
@@ -1225,9 +1230,6 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (tracecmd_is_buffer_instance(handles->handle))
 			continue;
 
-		ret = tracecmd_init_data(handles->handle);
-		if (ret < 0)
-			die("failed to init data");
 		if (align_ts) {
 			ts = tracecmd_get_first_ts(handles->handle);
 			if (first || first_ts > ts)
-- 
2.31.1

