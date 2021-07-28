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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3375FC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E60B6101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhG1Ndi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbhG1Ndh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:37 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC00C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id nb11so4659545ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=th3Ym/PrENfYQiogjPXg1dvVX0U8mGwKa1iPRmTHF04=;
        b=K/aApaX1KkOkznhlOxNjfvwFtnsS908C2tXFxYdP3iQKl8lJc6e8NTQLPfK2UQRpXj
         jf9ZBLUdzfJYY1jpxq7jhYYaLnApIG/IVWbq1DcpI8DmE1uloKBUEQBwjsRZKwDCjmlJ
         JeAsn9zwWQj1E7D5m4TYeLrvMfcB7f6EGgGs+YMYp2/uGKb41EOpY/nemDK8AvOQ76It
         Fim2O627qpKeemoZI83t9cs3c9vFhcmxVWYjUChmFa3OvNr6E5zb/rQU4H50SjHR4Mds
         RC1CxDLKUF4YW95JWYj2crtkSKFWJZLxhb1e9kPezSUNtl+W0EXPn9m7744xJsP0pl9e
         0ibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=th3Ym/PrENfYQiogjPXg1dvVX0U8mGwKa1iPRmTHF04=;
        b=bpd4LtiuS9304CyMxD6JJvx99M2skPpbLgcPSXxUvzbq0gFNf1KdJwvDTi7MOFxkVD
         yzgw1WjqZBf3w22yibFZa0ACMVXhtlheyiiQhdiQb+FfKcv8giQGhcv083x8Vlv/iXCF
         e++4px1XsGIxwerumQETduE7MpykpTtMFSxaA/56KzNeYXrdDX5qkSXXKO4HOdJtrfgN
         nZDNKLw3IzZZOEEbD2836+0/wBF8QCC9y/mP/5aCkOgrWBCHVDPpcux6zMIHSnGh0egS
         RJ0NFwkZONF5M0zJkBu3F0lLDKZmMzdsVxP7vUiDLAeJGLpdIQXv3dljzlXsuc1EIXvz
         USOA==
X-Gm-Message-State: AOAM531WiUcULmDHzm0EDZ2+mFnb8ywBy+VLUJe1qtGV+rm05p/eKGr0
        5I+HXmYbL/YOwvcMXGhmbaA=
X-Google-Smtp-Source: ABdhPJzmzAUQUDTdPfjfypg4DOhrodOuOvPTlinjTLVKvc3fIgA+k/ds9as9njp1ajrHMa4fhV0FYw==
X-Received: by 2002:a17:906:2a8e:: with SMTP id l14mr27112443eje.321.1627479214746;
        Wed, 28 Jul 2021 06:33:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 42/87] trace-cmd library: Fix possible memory leak in read_and_parse_cmdlines()
Date:   Wed, 28 Jul 2021 16:32:05 +0300
Message-Id: <20210728133250.234140-43-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 5eaf030e..1cc72092 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3122,7 +3122,8 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = handle->pevent;
 	unsigned long long size;
-	char *cmdlines;
+	char *cmdlines = NULL;
+	int ret;
 
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_CMD_LINES))
 		return 0;
@@ -3131,15 +3132,20 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 		add_section(handle, TRACECMD_OPTION_CMDLINES, 0, 0,
 			    lseek64(handle->fd, 0, SEEK_CUR));
 
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

