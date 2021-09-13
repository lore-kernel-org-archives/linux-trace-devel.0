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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78FDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED6860F6C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhIMM3a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239998AbhIMM33 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:29 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14BAC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:13 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id g16so14443924wrb.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hIaSg/ThuS+rjVyXJEp0CTM6VFI1pB32pj1o7a+D8Jo=;
        b=CkMNXvOSbnvdxkwvcDpv+nBGOMoIclm2BUAkuWaNmTkgRIjl55YydJ/q5eF+WIJffC
         CBQ8qU7KoxV9IDzqL5oqAAlzTfyvQMAchWRpQLaKNLdEPq3rzh4NeSUVCYKYrs8byUMi
         5FTV5baNsXLIipXRM/BUfdMyqfhYp7a0F+fVJPti7HvnXY44uZVqbzOCjbvRPdbtKihx
         8rBKTMcMRp+80ZkyWh1sw4ZophfkUmqt077SmylLOeIzFkH7Vv/xxy8ac49vhJWNAck0
         oQ/slZpzIWexoqETKFztEo7UyotpySVrJXdhImphvk/NpHvuVNffCThEb+glczuL7s62
         Xp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hIaSg/ThuS+rjVyXJEp0CTM6VFI1pB32pj1o7a+D8Jo=;
        b=p2AxHu7tMm43BP8g3QuNHErSzMT8k2iN2bL1CLq4QGeFHWBgzSoUpcNxz1Pq2dpHdq
         MleUi7+dFYeZmBvJZ6+WLJXPxTqpfHx/c/OHHReH4SA3B8GNJIpa0gE2k/VC+c6XiSMt
         FlJJf0QWR6yaaMD5FeeICS/OkMiIlrfIgezi/Ye6253v3AZ9ovilPO65HHFPFVbvCzJL
         IBw9T4f6VTGJjJRv3l3EtM/W1i5bIdr+CuKVE7awsdVRt4mb7ugd4C1T+0ray1bQ9Q2l
         ORYo+FDpdYenf5HrRm1lV9/RsDgHB0RR8RwIE6O6pbZUk1mZmaO0HP/FP04HScXYDkkG
         Rc9g==
X-Gm-Message-State: AOAM532mJVHQQyFJvNYEb83XDLTUuyVFM43QxLfuIux93Wc37lJ/A9R0
        bn36iyYjcM2LPRqc+9oS270JaNeIXQw=
X-Google-Smtp-Source: ABdhPJyYNSCg47Da6MUvrvWGm9un0FRVioyX90S4jIYBGhUNsqj2Te5kY9f03W9t832doRatEwT2ug==
X-Received: by 2002:a5d:608e:: with SMTP id w14mr12330396wrt.18.1631536092517;
        Mon, 13 Sep 2021 05:28:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 11/21] trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
Date:   Mon, 13 Sep 2021 15:27:49 +0300
Message-Id: <20210913122759.3672494-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

