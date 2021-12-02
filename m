Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77936C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhLBMg1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346987AbhLBMg1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:36:27 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0AFC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:33:04 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x15so115231133edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+cwRbIwuoZEoyKcE+k5ZGc5ve+d995rwGCr1GRVh+ks=;
        b=kiux8cwautBiXBC4jf1wKXSSKN0JUTcnnAPGmI6i/MoQH4W/C5iuu8ZqUifMoXhE45
         BpSyhYdIR+RvtokSepIAIY0hvNEAL+rw5XjQnMoN9LsYRSMb8ZFG8LqO3tmEh7PpW2AN
         t6jiCSOGwDAwK1xdNlG+NXWYSmF+JT+xXF1DLqxffvnovaPDSZ/3XHpK7MM+SS6rq2cm
         Uo12bgPjRc/ZngeaVjxa26LoPctZsptSzFzfzYqUlLJHiUpWY0nNhM82WYOJPRKP6KUj
         Qs//SeBEnZWqXP2ekFyV9VjwOAdtG5XuF/NDRR9AWAjDRgLPdePq14geZBlL/xDZmXiY
         XkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+cwRbIwuoZEoyKcE+k5ZGc5ve+d995rwGCr1GRVh+ks=;
        b=kauZaeQx0oOmmdC2ngb27QvhVL4rT52akHxJuhQmWVJ1FxvpQK2/BqXAc3uuSNVSgf
         hRlQoQidLy0pNGKrRMS6+PzHzQgbgOntpB5olUaSaqEY+6FqV/578eMi3haS4ujRVFzf
         HfMNNXKCnXa43UUAVaQ/5YO0wj2Y7qxeopD9rOJexapPhk4sXMPOeqZDt5Zac0J9RJ3a
         DL9PT0dJ7+9ycsEqbstm/PugA6qulhNUBrPIcqML6BNrqZ0+flvU8t50K0UV76Di4yNX
         T9efRymPpNxAw5X2ejPm2ebqGzzSUpsOhrxp793OPkytxEKzEZf1wVU2ziipdwE0/EJy
         o2rQ==
X-Gm-Message-State: AOAM530jKZ9X1LxHA7g7hNWvDbC19sIz9M1EAx8bvXfJstDOzfw3oxT5
        UbfYNdNXwraV8szmd8X5kL80H5tkU38H+Q==
X-Google-Smtp-Source: ABdhPJzmnPY2CyFqhF4qsny/q2WQlTxS45pPAJn9jvQiHZcpvP2NMa9N5VrDpMyxtM6w7/b58WThUQ==
X-Received: by 2002:a17:907:7664:: with SMTP id kk4mr14592578ejc.319.1638448383203;
        Thu, 02 Dec 2021 04:33:03 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g9sm2188420edb.52.2021.12.02.04.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:33:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/2] trace-cmd library: Use the real trace buffer page size
Date:   Thu,  2 Dec 2021 14:32:59 +0200
Message-Id: <20211202123300.44401-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202123300.44401-1-tz.stoyanov@gmail.com>
References: <20211202123300.44401-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 37 +++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8751e168..0edd0c52 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1195,6 +1195,41 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
+static int get_trace_page_size(struct tracecmd_output *handle)
+{
+	struct tracefs_instance *instance;
+	struct tep_handle *tep = NULL;
+	int psize, size;
+	char *buff = NULL;
+
+	/* In case of an error, return user space page size */
+	psize = getpagesize();
+
+	instance = tracefs_instance_alloc(find_tracing_dir(handle), NULL);
+	if (!instance)
+		goto out;
+
+	buff = tracefs_instance_file_read(instance, "events/header_page", &size);
+	if (!buff)
+		goto out;
+
+	tep = tep_alloc();
+	if (!tep)
+		goto out;
+
+	if (tep_parse_header_page(tep, buff, size, sizeof(long long)))
+		goto out;
+
+	psize = tep_get_sub_buffer_size(tep);
+
+out:
+	tracefs_instance_free(instance);
+	tep_free(tep);
+	free(buff);
+
+	return psize;
+}
+
 /**
  * tracecmd_output_create_fd - allocate new output handle to a trace file
  * @fd: File descriptor for the handle to write to.
@@ -1219,7 +1254,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = getpagesize();
+	handle->page_size = get_trace_page_size(handle);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
-- 
2.33.1

