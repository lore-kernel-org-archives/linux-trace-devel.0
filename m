Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FACC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352396AbiASIZW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352370AbiASIZW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:22 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8C8C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:21 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b13so7809129edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IXkaw51kn7nUyPsJb6+9iK15PVRNW362NBd7OxujqKM=;
        b=bOE4it0IV37OaZTQbwRAOpGEOJis4mIOiN5q5RBqFF9Cb1TUWJcLKeH8SHxdQGxeAW
         bVoSSjWcJyo0IS8qAi1zXiDjmxr0y4j3N9rj95o42aoc5R0z3woFPc1D24kIACbYyCg+
         BvifqYHQPZ/4JsG8JPtLu9BcgAOa+P8ixv2TyxEcChBQx1cL9sBBEXK3JUvcHj4o9oxw
         jDKh4pF411jtnCgmpQozKB4lUCZ8zIsRPHo5yOK8oOtOdUEG0csmWVig6Q/5DbnBzATE
         C6d1F08dGJkBT9FK8/Prgb+NXrH1qBe/hwnbaPrCisZS49p+V64FCdQ9VYqkSTWPlMEj
         xYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXkaw51kn7nUyPsJb6+9iK15PVRNW362NBd7OxujqKM=;
        b=gvxzDh4clvRWvQKpxbPHchJHG8rYfzpvO49URRecSrcllunm+7cns3jabOKC9ZhPFf
         jwsWTnFGptmoZJ4YQ1g63KpnwTz+dTOajboPUDpKw/WqWif0ch/Zk9mfRfATU2dN7LhR
         sB8lvjBfEJVeaz0NRe/Dt63G72nJwENAh6pHD3zci7U9InfLgpX8z6wgKZxVU547ircf
         dBOYmVkt2Jl+DfYDSG6haYlYu5m90dPrxNr5vYAlvbPUTqVh4PJES0O6y4CVkxOKzUGG
         I/229ULhgx/ulGrBbFw9qsemLxd42Vojg1/7iT/Sy9C63cuf+2wKfjmlUkUdba9P6sl7
         Se/g==
X-Gm-Message-State: AOAM5329rLMFo+RB/KujNrpdcMOSRTzrYPmyQQwfJUOjY2BUSCU8S68K
        M4lL0CHw3YqYjc9U7ZTRXmLXCWfCFGY=
X-Google-Smtp-Source: ABdhPJznAzIxwbqTwQxS1Ouyg4k/CWR+jeAVVLGldn6O2xhbza+oQ29R3U9g+s90j2qnWoCLWanCnw==
X-Received: by 2002:a17:907:7ba2:: with SMTP id ne34mr12505789ejc.440.1642580720177;
        Wed, 19 Jan 2022 00:25:20 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 10/25] trace-cmd library: Add section header before flyrecord trace data
Date:   Wed, 19 Jan 2022 10:24:52 +0200
Message-Id: <20220119082507.245600-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
index a7329d84..30bf0dd1 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1998,10 +1998,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
 
@@ -2020,6 +2022,13 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -2108,6 +2117,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
-- 
2.34.1

