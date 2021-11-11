Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB7BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C531761268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhKKPQU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbhKKPQT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:16:19 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790BFC061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:30 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z21so25430460edb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tzsmstlg0ZzNpH1rWdQrLwIZFTMRkXSVe17LfN+CKoA=;
        b=SyOWpGnfjEB6XsEhDqeEPJO17RkUK1O5a3zIhKnwPoulvoLDki8K+uhhVk1vv9ueA7
         0aUY4bkN9iGSCSmVavtcctqGk12uVONEysjlhGWWqXzF3njlYmTV3JIHEMxvAR1HVBTZ
         mFyPPJRLNs5zvmMM0wrP47sR7ifUEKzwxd0TYDvW14JPirJt2Mo4333x3wDVjtSy5OUM
         wGK+DVsI/HKuJ07zhunaOCjzY9XTjha2cyw5RY6+Ls76eQgfTMUj50/s4nvvN1dHn+BX
         5E6MoSL+zqd9BbUaYxKZeWbBbPYaQ/iNnuociwJGNVkc3A4XiDAziGzRbJ9KRZhBkVWK
         KzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tzsmstlg0ZzNpH1rWdQrLwIZFTMRkXSVe17LfN+CKoA=;
        b=7DEy+QvbL9Eup/K0XrQU46w7FP+8KZk4hLcp3yF2W6fIqjgBCIRhnQvXYYjg8ivHY6
         52JH96oLm3n9UlDsOVpgtUEGr3XCKuivH8hCHzFpAoQQo2qc9UL4TLfR7Y56XSih5DLS
         SlYH0tB4WrrYUJSUZAYDQnhHSVZg/U2B6Cz9EOY+zch5ZsLLG4FP75GQ6Pk3MmmcnRzq
         gxWUN6FHS9dNSKW+yIlUL4l96OoWVXH5AsXQP7Q/Db5ED5SzUnq6dZovHBccqGmnVMHY
         3n83y2IfQfH7mP+e9b+6anfs4GBNS4r3LdxCvzr4W9L71ptmHmzmYlgDaHm9QYqRfinQ
         ccxg==
X-Gm-Message-State: AOAM530Vs+KT0yjbDLSFKD+gjLROITA+UdzIByKe44iZcfn8HXYvg0ka
        qvO7sIjAftbM6of8G/l/JwEZAGE5nGRMZw==
X-Google-Smtp-Source: ABdhPJwonvp8Rph0oQKBdIEtbjbmvd1Gp+oA3mTQmW8VWGc8v3MuXsdPFunxaW2edwR0d8ujgtpEyA==
X-Received: by 2002:a50:c449:: with SMTP id w9mr10579507edf.299.1636643609083;
        Thu, 11 Nov 2021 07:13:29 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg17sm1429686ejc.72.2021.11.11.07.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd library: Use the real trace buffer page size
Date:   Thu, 11 Nov 2021 17:13:25 +0200
Message-Id: <20211111151326.87227-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151326.87227-1-tz.stoyanov@gmail.com>
References: <20211111151326.87227-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When new output handler is created, it assumes that the trace buffer page
size is equal to the system memory page size. This assumption is valid
for the current ftrace implementation, but it may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This commit depends on:
 [PATCH] libtraceevent: A new API for trace page size
 https://lore.kernel.org/linux-trace-devel/20211001062338.2389024-1-tz.stoyanov@gmail.com/

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 52 +++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a029678b..08fa485d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1189,6 +1189,56 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
+static int get_trace_page_size(struct tracecmd_output *handle)
+{
+	struct tep_handle *tep = NULL;
+	tsize_t psize, size;
+	char *path = NULL;
+	char *buff = NULL;
+	int fd = -1;
+	int r, s;
+
+	/* In case of an error, return user space page size */
+	psize = getpagesize();
+
+	path = get_tracing_file(handle, "events/header_page");
+	if (!path)
+		goto out;
+	fd = open(path, O_RDONLY);
+	if (fd < 0) /* old style did not show this info */
+		goto out;
+
+	tep = tep_alloc();
+	if (!tep)
+		goto out;
+	size = get_size_fd(fd);
+	if (!size)
+		goto out;
+	buff = malloc(size);
+	if (!buff)
+		goto out;
+
+	s = size;
+	do {
+		r = read(fd, buff, s);
+		if (r > 0)
+			s -= r;
+	} while (r > 0 && s);
+	if (s)
+		goto out;
+	if (tep_parse_header_page(tep, buff, size, sizeof(long long)))
+		goto out;
+	psize = tep_get_trace_page_size(tep);
+out:
+	tep_free(tep);
+	free(buff);
+	if (path)
+		put_tracing_file(path);
+	if (fd >= 0)
+		close(fd);
+	return psize;
+}
+
 /**
  * tracecmd_output_allocate - allocate new output handler to a trace file
  * @handle: file descriptor to an empty file, it can be -1 if the handler
@@ -1213,7 +1263,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = getpagesize();
+	handle->page_size = get_trace_page_size(handle);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
-- 
2.33.1

