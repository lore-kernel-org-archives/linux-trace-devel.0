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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A38C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01AE8611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhIJNt0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbhIJNt0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:26 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B24C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t6so1157490edi.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oZ9zyduyKBQJt5X+oVV5Fl1EGbPh4yyGk9ma+Swoy2U=;
        b=YkOqwmM9pi+KdDmA40yf5fwbBRlA8mzGGZKQf4TtALIMqafR4//l8ALXbI7EXhsrn1
         WQpDCthxVsf6ZsckquGW8WjtKrEKU1EW0SJsq/uppbJBkZy/iTGXePOtQfTktU69ByQe
         3bylf0Q0mbW/drh8ATD7iz5583rRWpxQ3nYuN5RYTgRTFSOD4mbyDQrWbc244SOJG5hu
         eRTJQ5l0L7hiXhwgwyhaUE/wgwzC6rj7NnRVYXc/+8EcbIUe39/ct5/6eQO0A0iv83m/
         oZBcB+ntv9Y/kpOhuHdPYyU6dXTS9Ua3kUneSODmvceXvafudiWZc0SC10/SEy9nZNKu
         glbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oZ9zyduyKBQJt5X+oVV5Fl1EGbPh4yyGk9ma+Swoy2U=;
        b=gATpiaT950y5ZmzmDXeRWO6wtc8/j158sSABzMHaFzUeHKHDY0louJ6RKjQc0t3Oop
         GHgxecItcOVC5LGo1dmVi6nd0jbjgIXk5ddIKBQIcx9d31MD1rK/oRC5cbtaDW2OAQx2
         32+vLGzS/VFiC67QFFuWlOTXXZucruVa18y1HxnNcEkqCmvmcpo4evwz0XkFVWCZ1zSU
         RQx7E028ggt0RNbzbxGEiKRiywJv9d6bWeqK6WkZYStFIkXC0bypGxd9ZN33qtNPkJ8C
         oxoaTmN3MnVedLetU3ok3Mg2CAiinP5ot93V+a3LnuwL5B/soDZu2lWqPnt/LilvFplv
         Apkw==
X-Gm-Message-State: AOAM533EwHhz1e/9DthgjX2yu2+u5GqjU8R7WflqA8k9LpavQYNnCjgh
        spXmVK9UL1Hfg1ZsBTmYmhbMqlgnql0=
X-Google-Smtp-Source: ABdhPJyHoKF4aG9+P6/NDSQNeABUCQl/jLBgjP1o0d4sTIzDeOFbWVhGKKXnc09p2lSmrmBffmsK/A==
X-Received: by 2002:a50:c949:: with SMTP id p9mr9366186edh.326.1631281693629;
        Fri, 10 Sep 2021 06:48:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 13/21] trace-cmd library: Fix possible memory leak in read_and_parse_cmdlines()
Date:   Fri, 10 Sep 2021 16:47:49 +0300
Message-Id: <20210910134757.2863982-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
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
index fd7690c6..a23ba9c8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3001,20 +3001,26 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
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

