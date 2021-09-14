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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DDAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10F5610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhINNOG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhINNOG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F7C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:48 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d6so20125851wrc.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hIaSg/ThuS+rjVyXJEp0CTM6VFI1pB32pj1o7a+D8Jo=;
        b=eyr+aMPR9P7AaYiahN3Ov9qEvHgNTuHpHedl07Rpq76sjwtK0952HtPkHpjni5bsr+
         vvyfORR5JE0gytSLsi5z0lAFQAdZ5AbX9Ufh22bNetJ/f8/TsZskQAlmL8jxhsOoVJky
         NRJL9ltIdl+ZY6o/eiLNQuBUoJYc3wpyb0Ap0Kxicxgp6jdvx6+9CBYMPDlP2d/wO+BS
         fq0mb2ClspqrZPku4x2ep5k8z5VXyZwu+u7SnDeFNx/qVfS07LYyvV6Pzx5KEGG/7S6e
         7CjvW26GiWurkJ1+rw7iuYyj815YxcFCcGSu3AcJ6/EXanK43ogZ9nqbQxIm5jdXsuHF
         1gpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hIaSg/ThuS+rjVyXJEp0CTM6VFI1pB32pj1o7a+D8Jo=;
        b=gJ/3gkdCkoxJwCSi8k6O0xs+4Uv5+Xsp354TdVJ6NHJB6vSfGPk0RgeZrchQZPCYEo
         VC6Ge1ifv/5mazVdb6oLD9YV0X8PNhLDaA9uy3v96vG9l3i1H6l96rPdgUHDT2CSUm7j
         Oit6Z0Ldv9oWjo02r18e9KykGZks/v4rIXh07Hp/PYWcdok007L6wvkLFWZ+GqX/yAZe
         TOWSo9rdiZr/6VqV2eWWEO6qvo54KJJmFzlL2Vs2ZlJwRZS7eHP6NGSVUkTdEc48KNso
         FDu55wejxF/fWGwFfdTEIOOCU7/ecYGRFVC0gryYDzynfP4oxD/hcaDYXiUNnx+Z4KbS
         QBHQ==
X-Gm-Message-State: AOAM5300Drtttc0tEL06aBprVd6Y0WEzg3bPSqGOwAGRpVzNYAUEtFnV
        82VWH27OmzhPIoaIqU8PL3pkwG0NSSA=
X-Google-Smtp-Source: ABdhPJwvg1lYaU+1+8ybAnF/iA9nJmxnpvJJ4Fqps/GSIPMj0vcuOtLhU3c3bSAf9qzvSUubiFCpZQ==
X-Received: by 2002:adf:f6c7:: with SMTP id y7mr7132108wrp.44.1631625167426;
        Tue, 14 Sep 2021 06:12:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 11/21] trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
Date:   Tue, 14 Sep 2021 16:12:22 +0300
Message-Id: <20210914131232.3964615-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_proc_kallsyms() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 39 +++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 32358ce9..9b23063e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -739,34 +739,39 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
+	struct tep_handle *tep = handle->pevent;
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (handle->file_state >= TRACECMD_FILE_KALLSYMS)
 		return 0;
 
-	if (read4(handle, &size) < 0)
-		return -1;
-	if (!size)
-		return 0; /* OK? */
+	ret = read4(handle, &size);
+	if (ret < 0)
+		goto out;
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
+		goto out; /* OK? */
+	}
 
 	buf = malloc(size+1);
-	if (!buf)
-		return -1;
-	if (do_read_check(handle, buf, size)){
-		free(buf);
-		return -1;
+	if (!buf) {
+		ret = -1;
+		goto out;
 	}
-	buf[size] = 0;
-
-	tep_parse_kallsyms(pevent, buf);
+	ret = do_read_check(handle, buf, size);
+	if (ret < 0)
+		goto out;
 
-	free(buf);
+	buf[size] = 0;
+	tep_parse_kallsyms(tep, buf);
 
 	handle->file_state = TRACECMD_FILE_KALLSYMS;
-
-	return 0;
+	ret = 0;
+out:
+	free(buf);
+	return ret;
 }
 
 static int read_ftrace_printk(struct tracecmd_input *handle)
-- 
2.31.1

