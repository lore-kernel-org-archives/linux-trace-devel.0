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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FEAC48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD91E613E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFJLge (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhFJLgd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:33 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E7DC061760
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:35 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso6336616wmg.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sP2SzL+jTkso72skt+AgZYS5f7e9OZMAJYuOulQ00BI=;
        b=MkM/QzdyEQaIqHBEa2JxNnb8/9+OTZBWOjyX7MPa7JEiqL/yo8JwS4vv+5SgcbYW1p
         RxlOV7d6CPiQOYxoBjGM0a5dy+exxwvbtud7NRiQFiFfIWBVME5w5X5xcuPIEUp3LvKc
         hkORyPdfCjgV7vCZBw3k+abGt6uj7HIfUVo0gjOxqUlXBRf5k433B1oDmFJSbeLU8SFV
         qpLnVyJqGZbe8jPWNknWZW4ltooV/tFOySFkzEa9FvGexCP41+l5sYsVQxbOaqd3LejN
         umDck633wA0qWGW15ppSJ3QcgHUpSumh2+Ks5bIMua4DkWziYrhbRstNMatfbeDC6gIG
         IQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sP2SzL+jTkso72skt+AgZYS5f7e9OZMAJYuOulQ00BI=;
        b=RGaIqA2Y2GtB3z3niEb0a1pHGutpzG1g5GCH+Iv6G7cLg3mJzFBRHXS0m4tIvHJNTU
         U8S4SL2TU9Wg7QRjH+GoTvlNsKlCH3Ugaq1OIBvLZiQWR4WHH9XPdc8tWw7bFPz45Q8X
         Y57qbfUkY6qu7gatyYgHe9lenhTCsOgzkWAzDNkczbi1zxf2cnb4UYPj5YUwzgoZLh7i
         B7KM25D995t6jN7l8ScX8z4rPGHW4xf+RBRltc1WM+gud7GFebjif7CTjDFjx13qu/1Y
         wekrvM91ihHWIi1KjmBX+oLF4t0XxrIEeZO8D7dsz8MlnkskgTCl7+0pm8Gvio51GA7F
         Wj6w==
X-Gm-Message-State: AOAM5333UJtDcu3Pw07JlnQHOe6NSqDScwWAhS6ebKCO8/VR7kUkXES5
        prT4xLY/kRrCGErpvrKD4rE=
X-Google-Smtp-Source: ABdhPJyUATnxeAgxRTwtmJWyjnPOdmM+DZkvzOiDcl3lJ3SKmHHa371yUKPdPFN92zRBWlaiNUuhYw==
X-Received: by 2002:a7b:c20a:: with SMTP id x10mr4501350wmi.141.1623324873785;
        Thu, 10 Jun 2021 04:34:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 05/40] trace-cmd library: Select the file version when writing trace file
Date:   Thu, 10 Jun 2021 14:33:51 +0300
Message-Id: <20210610113426.257931-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new output handler to trace file is allocated, select the proper
file version. If this output handler is based on an existing input trace
file handler, inherit the trace file version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c0aa58cf..bacda23b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -57,6 +57,7 @@ struct tracecmd_output {
 	int			nr_options;
 	bool			quiet;
 	unsigned long		file_state;
+	unsigned long		file_version;
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
@@ -907,6 +908,17 @@ out_free:
 	return ret;
 }
 
+static int select_file_version(struct tracecmd_output *handle,
+				struct tracecmd_input *ihandle)
+{
+	if (ihandle)
+		handle->file_version = tracecmd_get_in_file_version(ihandle);
+	else
+		handle->file_version = FILE_VERSION;
+
+	return 0;
+}
+
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -933,6 +945,9 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	handle->msg_handle = msg_handle;
 
+	if (select_file_version(handle, ihandle))
+		goto out_free;
+
 	list_head_init(&handle->options);
 
 	buf[0] = 23;
@@ -943,7 +958,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (do_write_check(handle, buf, 10))
 		goto out_free;
 
-	if (do_write_check(handle, FILE_VERSION_STRING, strlen(FILE_VERSION_STRING) + 1))
+	sprintf(buf, "%lu", handle->file_version);
+	if (do_write_check(handle, buf, strlen(buf) + 1))
 		goto out_free;
 
 	/* get endian and page size */
@@ -1562,6 +1578,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->pevent = tracecmd_get_tep(ihandle);
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
+	handle->file_version = tracecmd_get_in_file_version(ihandle);
 	list_head_init(&handle->options);
 
 	tracecmd_close(ihandle);
-- 
2.31.1

