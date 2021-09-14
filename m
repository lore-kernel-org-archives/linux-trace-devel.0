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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300A2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EE3610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhINNOI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNOI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:08 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E8CC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:51 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m9so20182667wrb.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glIMpG3HAPgkuiI7fGRy4IPowDQe4caybI6/I/n9b08=;
        b=le92ZIIS/ayu6LZ37uoWMwGb9riF+EUGKocZAlEKeN4jbg61ObCu1BqMcNovXufh8Y
         yMortKskDjA3w//W2tV8CVGTmOsOHHnzzQ1zai2OH8RM8dVLD83rpIvmOi2m+n1K9euA
         i8gNrjgiAXflvwpdY8OB0h8OpASKiBDQ1yK9nq63152fBHfB07fxUqBaTb/ufm0EK9cj
         xJch+2pxy1JSYps1bcPxYpanXGeZV3DSp/NObQVRZ8zYgOabbkGHGNX9IDN1h9XZXrQv
         hhsmY6Auxe+tdyOMenV09gD2jOhuGT82PHtMFAxF0zh6rkJApjmar1FT6g+gfdE+zTQf
         8Iyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glIMpG3HAPgkuiI7fGRy4IPowDQe4caybI6/I/n9b08=;
        b=xP2dHc/kvMbBkGM1nGquPgmb8WemNOsK/5UUbHaeUjn4MANQVNJGTG4ev4An4C6SRf
         mZUUnMMv8cQJGoOTud3N4qAjOgxn4dy2Y60OtjtcF/yjbOH3ByY2qBo6jDMjnyRtpohM
         Gml11Sn6zZFze8CFT9N+DUtvglwDTC1zGmFVF4QmAJ18hgVSk2YgOHNf6mPGTEMwOS6u
         uaaMiy1l0i1GftNyw1+MKcG/5irghClL2DxE7L9TW+4lah+YgXr/U0RzfXpzelP6xVmz
         1tGL0r6Hd6YwamhxjsCyVftKiXOhyHeObBFJgLDkAM2PfKaFe8LbWOqX5ObfMxMsMgYg
         dSoA==
X-Gm-Message-State: AOAM532K3Oj5v32m5X0tUWKFvgKcYbNyjLfh4+sgSpNp5M/q0qiK2Ddz
        IDKlDpNtY9sof6hznyu7MkpcPI8WpCU=
X-Google-Smtp-Source: ABdhPJwYneiqdCfI4z9i743Rkk9ELj8QrneaZCNP5Opmzb44JOq5aIQfVSxcnmi31gE2UW7F1xsDAw==
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr18984256wro.418.1631625169623;
        Tue, 14 Sep 2021 06:12:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 13/21] trace-cmd library: Fix possible memory leak in read_and_parse_cmdlines()
Date:   Tue, 14 Sep 2021 16:12:24 +0300
Message-Id: <20210914131232.3964615-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_and_parse_cmdlines() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 60d75d47..9fd7e6e8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2999,20 +2999,26 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
 	unsigned long long size;
-	char *cmdlines;
+	char *cmdlines = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_CMD_LINES)
 		return 0;
 
-	if (read_data_and_size(handle, &cmdlines, &size) < 0)
-		return -1;
+	ret = read_data_and_size(handle, &cmdlines, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_CMD_LINES;
+		goto out;
+	}
 	cmdlines[size] = 0;
 	tep_parse_saved_cmdlines(pevent, cmdlines);
-	free(cmdlines);
-
 	handle->file_state = TRACECMD_FILE_CMD_LINES;
-
-	return 0;
+	ret = 0;
+out:
+	free(cmdlines);
+	return ret;
 }
 
 static void extract_trace_clock(struct tracecmd_input *handle, char *line)
-- 
2.31.1

