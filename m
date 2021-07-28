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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F225C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2740F6101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhG1Ndg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236686AbhG1Ndf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06628C0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:34 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id p21so3211500edi.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WjqWfP0gnWvbUJBcsK0qEhbRrb1eFSFaLEQ2DWNepgg=;
        b=p8y36F4JzXMEUM0fFtq4+yKTwyTcymU4M6+s9XW/n4XQN+5JM6vTXiVtpmUPZWQJLs
         2tY2lSB/kSJrw+g+3DgrLN2pXXInrfQuUlykA5sPZPJnDC2f2Q0QLO6S3pMm0iroP91r
         j+WI2oY8iW65dvGsA/pKuroL7UK3jM6nuoqserztMgAf1Xya3HwYAxHN1SlwXgUju4r7
         VHSdpX16Cux2r5R4Nz6h5DQkYzUZGOaeGLBze4AFo/FV2/IEjk971AdvaPR+5fxBpqRk
         vPK5x0pwkcJkENA5UktkvJE097NGnRhXvbTOfayR62TkQ4iAMnOJfaG4VZ/Mk1Lp/8fD
         xwnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WjqWfP0gnWvbUJBcsK0qEhbRrb1eFSFaLEQ2DWNepgg=;
        b=LrSkj5cKZXLayc/rpoMYmyASqHoBylVCs/dYVwwRRzPcvt3/HS9ayHl5MsPbQxplIs
         AuoWjXK6cW+zyWhG7mzOvoHnDVh3jOZH0oLEDaoKSSMeqNJX3OQrAA/v8ucB8h3hbvoP
         aXyWwyjFLpBKk8MaBmG6v2qsGSPdQOKsBgur1XjsKeAlAGs7p5NF00CCYakauz9hacle
         VydcKt7Iqc19YADRDNepsAb1suMz+2WrqPdQSisLnAnQWm3IJPe7KmL0cT3/ic2MIKJ7
         mFMh2fELyvpxhu8SQKZZF9dGXnnH9k3yZhlyz15V32EbDLtSU+PZQtmwbxg4LeiEZS6X
         zEzw==
X-Gm-Message-State: AOAM530Wmyo7i0YAWnjxL/7JMpA2MR+N4rq2QWioXHK8J/b+Gxq2S2mw
        JF4oDXzZwJiCuqqapBX1M8M=
X-Google-Smtp-Source: ABdhPJxzQOgD/mOUeKZ5S6AhgpdoAyuVswqMVydKW5QHxtSBTIm2mcunCdoNhUh7YsFJ8EJP/GsjTw==
X-Received: by 2002:a05:6402:d5a:: with SMTP id ec26mr34711049edb.4.1627479212639;
        Wed, 28 Jul 2021 06:33:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 40/87] trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
Date:   Wed, 28 Jul 2021 16:32:03 +0300
Message-Id: <20210728133250.234140-41-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_proc_kallsyms() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 40 ++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ec717296..14052a11 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -846,9 +846,10 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
+	struct tep_handle *tep = handle->pevent;
 	unsigned int size;
-	char *buf;
+	char *buf = NULL;
+	int ret;
 
 	if (CHECK_READ_STATE(handle, TRACECMD_FILE_KALLSYMS))
 		return 0;
@@ -857,28 +858,31 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 		add_section(handle, TRACECMD_OPTION_KALLSYMS, 0, 0,
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

