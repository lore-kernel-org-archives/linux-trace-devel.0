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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE86BC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F30861370
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhFNHxk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:40 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:43888 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbhFNHxj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:39 -0400
Received: by mail-ed1-f50.google.com with SMTP id s6so45187810edu.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sP2SzL+jTkso72skt+AgZYS5f7e9OZMAJYuOulQ00BI=;
        b=S4haf12kr3TO4abFGlBUhYOhk5asaVXq8a7Eaq6oJziRN4BIcqXz0CU7MotyTNJBZq
         TGJzbFqPDpju/ZKGXLm57W0764ro5edVXMsYK/oa+98bZs56hX/VdDEqLLSOTLHAWzjd
         s0STcfUbf5WrRysIJVSI4Fw8mWuTsjF5dEMckkiPZo7y4V+Gvn7SHDtZEszyncO8g5AW
         ht4G1plEsgN7SWzRE6MMp0T/N2V2xUETscMwvNoz6cb032ALNuNTBjidf6zCC4Fdj+zg
         ThpTRrbJ5LveeWu0UArjy13XOHn3vrhBf+Wva8whFx0I33Y1qG82pL5uJbJfCCnBh0dc
         qj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sP2SzL+jTkso72skt+AgZYS5f7e9OZMAJYuOulQ00BI=;
        b=Z1phzeqrAhk5by7eWDRJPF/jF7t47VIT+2CTt9dHuAp8ZAxsYHJ3p2auOhYVOeBO42
         Ky9lRbTCyPW8B9XYihC8/hWEYiOcSz+USXfNs1jdtyD7K+/yWOQd+M6JbcYt+AgsKL2b
         YOFsoui7mV1pINsngZz/4GsYFHhE6vWu9y4AHklSX+mBXtDUz+49oCcCvQwcRNBipK6p
         wUelCMZsSPoPTLUzRUVRMHqO5+vWn3cB97OzIZTpgtbOATul3t22o4vK6Yefd/l8Q+Pd
         85ISyDkjTmsQ2Jz83Qx1CeoEWZct+6zj+gMBzVhisjXtXQCZTtvpQFSSivG8Xkz40lwg
         Pydg==
X-Gm-Message-State: AOAM5308h3z3C7yjJJ089ftTYczQl3Rq/eXPSh7jB3UHfERgzz9gcMl9
        hdAP7tzlHxMDVpChFHAG+EY=
X-Google-Smtp-Source: ABdhPJxzeksHSJv9Uu7/s5Bx2mDE4Ki/6oRXy2UK1ATKlubPyA4ZeimlIoTp56EsuDiJBrrjZQ7rig==
X-Received: by 2002:a05:6402:31f3:: with SMTP id dy19mr15541436edb.153.1623657036609;
        Mon, 14 Jun 2021 00:50:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 05/45] trace-cmd library: Select the file version when writing trace file
Date:   Mon, 14 Jun 2021 10:49:49 +0300
Message-Id: <20210614075029.598048-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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

