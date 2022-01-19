Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACFCC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352524AbiASIeS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350260AbiASIeS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:34:18 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0613AC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:34:18 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 30so7714929edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j19yq5YEQ90SbgY9iFXnYa0iEAhqoVNiWN1V4hI+MLA=;
        b=pQiY9cyX25pXE24Vmm/YgiBCKM5CUR1Po21DY7psUkNS5k5l7Q+L1OitDwdCE17f7q
         u6QUQWcQJmFrWWVOVw0HnaPgbF26H/6xKRlTZLw1EZMpr5lc5uxpOfYYOrAQ8+xknLgf
         CDCpJpOA210EJsrDaXVnzd1kwD+ZlWMC+bR5o1jNeueJAD1FJywHz9dxh+4Rn4DCyxDc
         fJ3c7xRP14YEhpP+jZaVekZtJOuAtMY+W4BMXmWJQJJruvl7+1ZMJzL/jylhN8JlyB9Z
         BOV5F8NHjTWwFfynuOzaN2zO90WexHp1rSmioUkEZHEMlZR+vAJGGW3uXELGTLq20+/t
         YbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j19yq5YEQ90SbgY9iFXnYa0iEAhqoVNiWN1V4hI+MLA=;
        b=op0Z2ZIKX5gtHy3lJD52Fbg+JqtwQNdwUW1N8z2+y5B2GQ+Z0ZITFmga/TZWCbDKDe
         PpjPUn8Sj61bqSXIM8BF04uLgIuLfAzQJmdXoNWJL+zIEiLwG259CGusLEhpT9Xkgj1b
         1Wi6jhXZLS89qa6tk6byeC93ByMG56KNvJ2Zzhz4EWftDqXnqs/5Ib2ixzLJu7sAuH6Q
         L4zmp5wpWkKbawzZmlIatYERxDaiHnaDOcnmoaZM/xzEttyQvnPf5lFNGTDyePLUVEB4
         UnTtWKA4DhAKhGdguwA7rVg0vinw9KaCQ8NM3zm7pjj8N5LYRC0tN3PWyERuMqjAxJ5x
         RyYA==
X-Gm-Message-State: AOAM53267XO6sKGX3Nt2YbnEkL01nB+a7rxWNCMVoDms9jjJMfBqXFX0
        lKtOfvSX5OXL8zcJ4ZnD013yZ63LvZw=
X-Google-Smtp-Source: ABdhPJxRL9seVrqkxQrq5OMUgguT8KJVhkW0BiYFlHu0wD5pDJcngbULMrqbCtlVN/VEi+1Hz3+EZg==
X-Received: by 2002:a17:907:3f93:: with SMTP id hr19mr1097394ejc.57.1642581256459;
        Wed, 19 Jan 2022 00:34:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 10sm6177380ejy.174.2022.01.19.00.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:34:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 1/2] trace-cmd library: Use the real trace buffer page size
Date:   Wed, 19 Jan 2022 10:34:12 +0200
Message-Id: <20220119083413.246539-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083413.246539-1-tz.stoyanov@gmail.com>
References: <20220119083413.246539-1-tz.stoyanov@gmail.com>
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
index 0323da75..d901c32e 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1279,6 +1279,41 @@ static int write_compression_header(struct tracecmd_output *handle)
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
@@ -1303,7 +1338,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = getpagesize();
+	handle->page_size = get_trace_page_size(handle);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
-- 
2.34.1

