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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975FCC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79C0861450
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhD2ECQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 00:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbhD2ECP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 00:02:15 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C91C06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:27 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id j28so12828102edy.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jh94CVkyZ80NZk00QNKScK1pMRGjLPh+Cdp2ACcN1r0=;
        b=MFzxsQZsBTMUQPcjB02Fl7T6nmacLo2qwWByACh7fYUZOUM13LdJssCsy1b7Y9DaQY
         2vPJJjJQV7MZBrBvUYKSJqp4AN2TshNS7YWo1JL3DeC/lCdGOy7x8RQYmfIOLRXS4Hfq
         wCbNQ7w6cVpop3rm1oODKRQD8sHLAjEkzvqShlNchM0FoG/QH1bPI1cBeAOp1OgWyNJO
         2wZD8jv93/NKjrPs0uZ4gGQt8mYuD+OhFjkOW7zOr+HcUDy/I3yhHI1qONwFpxesuKZ6
         9pnDU6+ZQl9h2/coHitgpDwcfz1WiNzVLkZJKNj4YAAJrS7PXCh9UfxQf9KQesv83e6V
         1oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jh94CVkyZ80NZk00QNKScK1pMRGjLPh+Cdp2ACcN1r0=;
        b=HwH1bSlAsS7tOR/oIf/kZ3wQcaBzDENYihOoUTfq7EtiOSK/doYAw7CTDJJXyuxnnf
         47i4AG9D/WjwMK6A2Zt/x8WTFHkG+RQBliiyX7T7wV4xbfJJ/0HsoLTtR46bPmUbtYMq
         pE+bodKvK4FBKSUHR2d3h2s28xuKDceZxx42UtO7qpEo7nE5xuvQzO9xqGiHowl3fqqh
         LHPLg9GN3w+2dsqnEjfkYN30S2VbQfREbvZWKRlArr2gWLhiHm+d8mUgosxEMISelOX4
         JInmwPPB2eIaRZEcRfwpjXGYbqlQH3dahz8bCVvtxJFMMTS8u5H72TGhhJhFe8QnTkLT
         SejA==
X-Gm-Message-State: AOAM5324MnfuCp5G+yBnFPd6vH/4D6i+RM4HX7pqcrf3F0yQGU+YG/VE
        IBuL108sod08m2xtB5PprMQ=
X-Google-Smtp-Source: ABdhPJwyvMF7Uk11eP8AnNC3AQwxnB24t5BkVmu/ERJtW+Q21RJfgnYKKYVRrluagqfEvSuI/AhFmg==
X-Received: by 2002:aa7:df0b:: with SMTP id c11mr15143362edy.288.1619668886535;
        Wed, 28 Apr 2021 21:01:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1040740ejl.38.2021.04.28.21.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 21:01:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/7] trace-cmd library: Select the file version when writing trace file
Date:   Thu, 29 Apr 2021 07:01:17 +0300
Message-Id: <20210429040119.843617-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210429040119.843617-1-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
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
index 9231c319..f36718f1 100644
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
+		handle->file_version = tracecmd_get_file_version(ihandle);
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
@@ -1602,6 +1618,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->pevent = tracecmd_get_tep(ihandle);
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
+	handle->file_version = tracecmd_get_file_version(ihandle);
 	list_head_init(&handle->options);
 
 	tracecmd_close(ihandle);
-- 
2.30.2

