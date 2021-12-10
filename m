Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A19C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbhLJK6g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbhLJK6f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:35 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BBBC0617A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:00 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r11so28178583edd.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HCjPkWSam/r5jThtNS6O0K8Ypv7UzCnec3noWMHHRkQ=;
        b=jV3nXAXYf4Dq976ttVkhvL+Xn+fkOUQjzzY6DBxjUyrcZkfa/Oc34oGXE3SUK8uvfW
         nkH5e7X5NE488VnIzujNNP/1yZ9RDa+7NumWhdQpFF6cfaBk50UT3sY/ZWs3XAeKMF8q
         FZgqitDhTuhZV/GHKmP7IJ/3CQQHDGBarSXhOWpycszFh10/kN2vYCBfmN/la0JMCIVZ
         ApXMZtX7wVzEvnFc07cdbeXmR6d695ZZt5ZmW6EZwXUhgRqN6GbXvT5qXzeooDp1UR14
         E+yWjmWWffuad8IfmOeWEsGR4dDscpzc4RS3DdbODb88Za87IdZL3EcfIcW3mUPRYgpV
         /BYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HCjPkWSam/r5jThtNS6O0K8Ypv7UzCnec3noWMHHRkQ=;
        b=4TZa1b+E8b647Ea/d18p+Y/wfirsrIqdFx50DqKvIMTB2yhBb4nInGqTH4qIzXgH9Z
         woY6TIT+sfj5gttVPHlwD2oNAbILXBULkfOT351Dw33UxfM7gZE/1vS56W9F/4eicQHP
         s2xhZ/BKeVSkNtpvjVRERg8zNGakBBiLIipBeV7ZSqBugbj9wuQafrG9drSMcYM0AZub
         jmtrg3tFHRlVvmzuGnqH4e65e3LPeGEkwsA1wP8YjuBiJzt+43Rhd2eraV5n64gbK1vM
         VdeaTYx2AbTxboDWYImLn0PJzBGHR1k767c54PfJBDMiaWqelhXASmdpa781NSjVCnNM
         XxJw==
X-Gm-Message-State: AOAM532Ojid2WoD8dLEnOVmRp+wk4cvtxUX8m9v28zYDg1sFv7s9biY4
        Hoxihx9ZtBaOvqNoW8K9j1zpQAREF2A=
X-Google-Smtp-Source: ABdhPJzp820PO1WZgbf4vqTcG2Kyyor8VRZxm8YE3ZnrAThI5ZcEOojMCXF+a05ZXZjmFCvdQjw/6Q==
X-Received: by 2002:a17:907:3e22:: with SMTP id hp34mr23156242ejc.491.1639133699565;
        Fri, 10 Dec 2021 02:54:59 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 10/25] trace-cmd library: Add section header before flyrecord trace data
Date:   Fri, 10 Dec 2021 12:54:33 +0200
Message-Id: <20211210105448.97850-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, write a section header at the beginning of each
section with flyrecord trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6e40c929..44050dc8 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1980,10 +1980,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
 	struct data_file_write *data_files = NULL;
+	enum tracecmd_section_flags flags = 0;
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
 	char *clock;
+	char *str;
 	int ret;
 	int i;
 
@@ -2002,6 +2004,13 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
+		goto out_free;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
+	free(str);
+	if (offset == (off_t)-1)
+		goto out_free;
+
 	data_files = calloc(cpus, sizeof(*data_files));
 	if (!data_files)
 		goto out_free;
@@ -2090,6 +2099,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
-- 
2.33.1

