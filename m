Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5B7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A3EA610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhJHEWU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJHEWT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A10C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:25 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z20so30915163edc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xJkoYve7kLwLSBhK66Ud509bLuqnYLaEzGDcpFDMtx8=;
        b=juPA5tZmzIJ0Sfkjqe7GCa889aa7iCAdjcWTQ0Pr7Tnq1thhgV60Sx+L5fcxa44Pn3
         JxKnCF8BDXNFR9pvABgh8/MjngnJE/hmBwUh51U/iKZKdVUR7+mLnhwtX5FM61LIlPgZ
         U/+EjClxA8/Jzsf71nfOi7j5nTMLrEZNcA5A3Tmfw5H6I38qjcZaa8JOaquIQC8oBN5V
         jwMsHvX1Z4JptepM9wQZ3/AC3dmNl+aBtwxuoCjpXTu6qnx/QJ4vwf3GDxf7K4MGB7oC
         BC9jcp5Hw8Bjs7DAMPowbCm1NunbZeWGx96NZR9lOZXDadtQgPrEfbI1plLqU6UxdTIB
         HHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xJkoYve7kLwLSBhK66Ud509bLuqnYLaEzGDcpFDMtx8=;
        b=Ygl/8Y5rna+Dpa6KdnJ+X0Am58BSv/q6e/ZWl0eRpmz59nshptlOtmJueSGZf+dusl
         4jORJScx/KDetNPsQIyofdR3wvN2B9ZpT1PM9GPQ93I28vNHJ74IrWFaG6Zs4S43udyJ
         8qPDq9n5wes2I9xhXBaVG3VVi8c09IGg4AsV5O67tgPiswp8o3OXAMN1FRNgrRX2apON
         CXMmO4m3DGFACyZDbPkDEfEst7831HqPp3pKAOBrrSXGZNo63ih4O6YIvajTo/p/pAkC
         81gyL1VQ5DgeQG9OAJAiuuJfoEYbGhJA8Bd6hgPDh2xO1XVhW4HnjRvfExqLIJpBHzm5
         zb5w==
X-Gm-Message-State: AOAM532GPlpSLt9kJVdJNYQRwMoUMXWjPljE8ZJQg+50o7mcsK6AFfIS
        FVfunr32bcqz8QdYqlz5TcNVb9u08X8eXg==
X-Google-Smtp-Source: ABdhPJxLWmxaXXb1WY0PhOJ/8FrLUA5UqnsAykqWeSNWxxiWXSgEmYAHK3jnIT4QI7c6LTR96KVUpw==
X-Received: by 2002:a17:906:3693:: with SMTP id a19mr1260942ejc.237.1633666823582;
        Thu, 07 Oct 2021 21:20:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 22/25] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Fri,  8 Oct 2021 07:19:55 +0300
Message-Id: <20211008041958.976309-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

CPU data initialization is different for trace files version 6 and 7.
When a new input handler to trace buffer is created, initialize the CPU
data according to the file version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 55 +++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b1b4aaad..bc1f4a87 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4467,34 +4467,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (!HAS_SECTIONS(handle)) {
+		/* Save where we currently are */
+		offset = lseek64(handle->fd, 0, SEEK_CUR);
 
-	/* Save where we currently are */
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to buffer %s offset %ld\n",
-				  buffer->name, buffer->offset);
-		goto error;
-	}
-
-	/*
-	 * read_options_type() is called right after the CPU count so update
-	 * file state accordingly.
-	 */
-	new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
-	ret = read_options_type(new_handle);
-	if (!ret)
-		ret = read_cpu_data(new_handle);
-	if (ret < 0) {
-		tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
-		goto error;
-	}
+		ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
+		if (ret == (off64_t)-1) {
+			tracecmd_warning("could not seek to buffer %s offset %ld\n",
+					  buffer->name, buffer->offset);
+			goto error;
+		}
+		/*
+		 * read_options_type() is called right after the CPU count so update
+		 * file state accordingly.
+		 */
+		new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+		ret = read_options_type(new_handle);
+		if (!ret)
+			ret = read_cpu_data(new_handle);
 
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to back to offset %ld\n", offset);
-		goto error;
+		if (ret < 0) {
+			tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
+			goto error;
+		}
+		ret = lseek64(handle->fd, offset, SEEK_SET);
+		if (ret < 0) {
+			tracecmd_warning("could not seek to back to offset %ld\n", offset);
+			goto error;
+		}
+	} else {
+		if (init_buffer_cpu_data(new_handle, buffer) < 0)
+			goto error;
 	}
 
 	return new_handle;
-- 
2.31.1

