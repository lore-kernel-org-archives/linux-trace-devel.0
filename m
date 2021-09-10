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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0904FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1427611CB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbhIJNtW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhIJNtN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:13 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E9DC061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 9so2564594edx.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q/XpTU2XhoHbHAqoA8x/vtqptp62mgjiQRNtFM2Rvqo=;
        b=QlA5EgGykBdC0yuDHgoHIf6dfTaUmFgKl8EDdN+rtnLLyKlhD/yU0xhdCYDxpBCqXy
         7MVflQ7TkbeMzEjWN3AWVKkooIiZHQCXdB4pRqF8qm933nWUqzIU+9kO/t1d5sclYESR
         ZqWYzsND7C0xRT4atdM1YSmNvhCk5w5LFq/Xw1NTN2k/4Bwymx9sMkuMF0cl3xYvNFSn
         vGxhM6Wtop5P+jtnRwTyw2PxD++sMXMpZe6CrWI08quWf+k0l+7eBjIBMW+haAHwFn7i
         uk/m6BWWs0V8B70LIOlwk0fcHgZYTD5e5MftXZchflgfH31ir1KM0k1CaEcg7WyVo9Q9
         GEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/XpTU2XhoHbHAqoA8x/vtqptp62mgjiQRNtFM2Rvqo=;
        b=bty+FJkfcMGchK+Mw3hV5m41z67OH2lNb+WCspRsIw22ic1wdcUCwap0TYUYw3mK1C
         6KAUgek+yfyZ4H0dQyhUV+BC8Xw/GjjcZf9VuLZnUe+qZzgQGNxuXZsDgXj3b5kFNphb
         lvO56pfJkLRSse436Ah2OSVTJzj0sK+Azuc85d1zx91Vj3C7uwj39NC0Fq3q8ts0DsAf
         jqi67MeKKoGKV9pB+Q/iOwHDULO2dTIcYezLI8lAacA/+UhFdxeAco9truAtns11DF2d
         0HXLtevpYeaLypMC1lDByTUo0m2ytmTepnWoXqI3cGk0ZDRvvDvkKrEnwuD/LbhKPMWQ
         RgWg==
X-Gm-Message-State: AOAM532eWzISibrSTRksKdzBTZrLDxbsHYMjCIwpYx62l6s1WqM/jVg2
        u4p2jnQ3tsO70KeSRfnA67ZE82u057E=
X-Google-Smtp-Source: ABdhPJwtVH2t7bjMYvuIG7nuc1tZVWXzNJFcvXXI406xDf4ndZCy5ILScNVx/wJ6UZGyTcTPt5qejQ==
X-Received: by 2002:a05:6402:2695:: with SMTP id w21mr1244207edd.182.1631281680770;
        Fri, 10 Sep 2021 06:48:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/21] trace-cmd library: Read option id with correct endian
Date:   Fri, 10 Sep 2021 16:47:37 +0300
Message-Id: <20210910134757.2863982-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The id of a trace option is 2 bytes short integer. When reading it from
the trace file, use the tep handler associated with the file, if
available, to convert the option with the correct endian order.
A new helper function is introduced to read and convert 2 byte integer.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ac57bc4f..0dbcdbdc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -336,6 +336,18 @@ static char *read_string(struct tracecmd_input *handle)
 	return NULL;
 }
 
+static int read2(struct tracecmd_input *handle, unsigned short *size)
+{
+	struct tep_handle *pevent = handle->pevent;
+	unsigned short data;
+
+	if (do_read_check(handle, &data, 2))
+		return -1;
+
+	*size = tep_read_number(pevent, &data, 2);
+	return 0;
+}
+
 static int read4(struct tracecmd_input *handle, unsigned int *size)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -2660,16 +2672,15 @@ static int handle_options(struct tracecmd_input *handle)
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
-		if (do_read_check(handle, &option, 2))
+		if (read2(handle, &option))
 			return -1;
 
 		if (option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
-		if (do_read_check(handle, &size, 4))
+		if (read4(handle, &size))
 			return -1;
-		size = tep_read_number(handle->pevent, &size, 4);
 		buf = malloc(size);
 		if (!buf)
 			return -ENOMEM;
-- 
2.31.1

