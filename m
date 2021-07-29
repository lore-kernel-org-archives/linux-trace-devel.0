Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA331C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9240261053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhG2FKq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:46 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C337C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:43 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id da26so6430781edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lYegybilv5zGZHqg9ZytbAQzubrYWhUWz1c5hZSVIVY=;
        b=OgYDPEOpN18ZGgZNabV+eo4FyiNTaCxncVrXJZxtZe4QTBo9hGPfj0mml0nnSTgH21
         gWhyFrggyqUKW6jd+yyF68iNOPf1EDt5HDk9bdgZNkSdQ+zYHwq2VHAo224DoK5Zzlei
         Wza6CBDlRBp7trj7QPRk8VfKVvdnYgzlCRVBauy/qgH7SnGFqn7RyybYH7rGN32UJd8M
         LYZhGxwGDY1hXVtRXMcbtNnYGnfSAVg8eA6/9SRv2/4U+tRce2XedTfY4N0CBTyjCTXI
         iolBeoqZ1XSwob9JpNm2UeEhe3JuozvFySKtDHj0/H+Pct6F4J6KBfjSvz19xuYT//lj
         l3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lYegybilv5zGZHqg9ZytbAQzubrYWhUWz1c5hZSVIVY=;
        b=B7s4XMNzBSE3dYQAzghwMULjCW5406fWGA/OIuqW9Gk2Ar3zCHtY0q3aF24jDNLoxt
         9UqGPx180YVA3bYkKtQBtTJAYJiyfQdUXVmIxmwQ0+vGF7ySkY7Iud1v3cIYj/jh9Qn/
         SU+ClbW0WiN9/iVM30ZREHWHOW9QhHzWtV/TMfNf4HG6v4BIg1xe85aDzbLrYuzh47Fv
         kAVcH8d17RbJyTpwyF3chF7hrbNlhYzslqDcBWcj6SUnPGs6xsSHYSD2omNfyUuURYcK
         jTKuz9nDeRGPMMk+mP13nUK/GsUulJlAi3YKBF8RDcj7HEbuEVR6yGDdX6jjsnN0ekom
         aX/Q==
X-Gm-Message-State: AOAM531gMX3lnpjgT8wQHhCIYZvwMilctaH/jauFtzFPCwikNSq0qN2F
        32mitotdsZkNXJ6tcD5odh8=
X-Google-Smtp-Source: ABdhPJwljkE8Z5hIVhK3xWMEWx4IDuwqGRifK3pBnWlkyVAR+X/4QqKf1YYynuWYkLvujM+YM5V3BQ==
X-Received: by 2002:a50:f1c7:: with SMTP id y7mr3960555edl.386.1627535441807;
        Wed, 28 Jul 2021 22:10:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 41/87] trace-cmd library: Fix possible memory leak in read_ftrace_printk()
Date:   Thu, 29 Jul 2021 08:09:13 +0300
Message-Id: <20210729050959.12263-42-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_ftrace_printk() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 99aa33ae..5557e772 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -887,7 +887,8 @@ out:
 static int read_ftrace_printk(struct tracecmd_input *handle)
 {
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_PRINTK))
 		return 0;
@@ -896,29 +897,33 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 		add_section(handle, TRACECMD_OPTION_PRINTK, 0, 0,
 			    lseek64(handle->fd, 0, SEEK_CUR));
 
-
-	if (read4(handle, &size) < 0)
-		return -1;
-	if (!size)
-		return 0; /* OK? */
+	ret = read4(handle, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_PRINTK;
+		goto out; /* OK? */
+	}
 
 	buf = malloc(size + 1);
-	if (!buf)
-		return -1;
-	if (do_read_check(handle, buf, size)) {
-		free(buf);
-		return -1;
+	if (!buf) {
+		ret = -1;
+		goto out;
 	}
+	ret = do_read_check(handle, buf, size);
+	if (ret < 0)
+		goto out;
 
 	buf[size] = 0;
 
 	tep_parse_printk_formats(handle->pevent, buf);
 
-	free(buf);
-
 	handle->file_state = TRACECMD_FILE_PRINTK;
+	ret = 0;
 
-	return 0;
+out:
+	free(buf);
+	return ret;
 }
 
 static int read_and_parse_cmdlines(struct tracecmd_input *handle);
-- 
2.31.1

