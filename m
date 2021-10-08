Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5DFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5752460F6B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238030AbhJHERT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbhJHERP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:17:15 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B26C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:15:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g8so31211462edt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kYgZ2HI1j/TuevF06TjqGZu1L3z66jl8PYtin0o0NTQ=;
        b=KC5Bi4maqvClq0QS8wbcKs4GD7x7jqrlb1H/YViwu4oOjFpwuwng+6M9sQyxrHaAvR
         ai7xVENFGdQdjf6Bpgb5b/H6wD/T+4xAmxYU5R601pcevjTf2i3uFcd872v60VaO3rVX
         3hMKgBNfC1sTpsmutniE7kyeN+YfgLNKuwbq5qRef4JOz4RtZ2LZCFi6b4L+At7PtGHW
         y6HP6wqnjKR4QRlFgiYFCcy/EZX7klmJM6XG1wryrm08eHhLVNlLd/qJDPNjpnWfRqBk
         taPj3VVKlsKliFXhZl/y0KLJwdukfqm7eX1F/w791MtYOID+GY32Dp5zXQC3aslpbRPy
         c/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYgZ2HI1j/TuevF06TjqGZu1L3z66jl8PYtin0o0NTQ=;
        b=NjNPkTEp8jmT1otQXRqlrsYOiVQGvsKvCk5K6UaysisAnUNfGRyDqzbM5UBBzfnfm7
         n4muiZiCGzNByEYVM0izXYMRwFOQZsG94pwemSFMT5NOlMVcOluvB6rx9MuSbcSSt2NC
         /yFeJL1TAlq/mBcFbH4ea5BsDw65z+Y/tfkdPWlzAFcksilqA8k/usGBRtCgw48jGVgg
         eL3pnpXf7VwPAmSPNmfwI3M/U0KHtbtSOuwsYYyQp0kRK/RLEihcNNGnrFjYfjGnLkty
         8P/IV3VCcnIrx8O/9wwVD26rokPxTk+MvMSoMmUqLzzTVezxyqq8AQ3hTzGbPmLdGkpC
         DX2Q==
X-Gm-Message-State: AOAM530IDkLnNL8+CI1yVRYq6pMB6GKmwdZpdJ8QpxyJUIoRkXbqxh5J
        stf5JXDO8RwhNrffzoMwXS23xRoLTkuDgA==
X-Google-Smtp-Source: ABdhPJzmgKJeS+WlMI1BhVnWFI3JaKUeCAZ86H/MOQAwCaO577HHqFppyrHSVTxIOtGAc3HHFsdtUA==
X-Received: by 2002:a17:906:12c6:: with SMTP id l6mr1188211ejb.373.1633666519820;
        Thu, 07 Oct 2021 21:15:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w15sm459614ejb.4.2021.10.07.21.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:15:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd library: Helper logic to update the trace buffer offset
Date:   Fri,  8 Oct 2021 07:15:13 +0300
Message-Id: <20211008041514.974537-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041514.974537-1-tz.stoyanov@gmail.com>
References: <20211008041514.974537-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new helper functions can be used the update the trace buffer
metadata with the real offset within the trace file, where the buffer
data are stored.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 49 ++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1f144d28..17607b93 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1395,6 +1395,20 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
 	return 0;
 }
 
+static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
+{
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		if (!strcmp(name, buf->name)) {
+			if (!buf->option)
+				break;
+			return buf->option->offset;
+		}
+	}
+	return 0;
+}
+
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	int ret;
@@ -1487,6 +1501,41 @@ out:
 	return ret;
 }
 
+static int update_buffer_cpu_offset(struct tracecmd_output *handle,
+				    const char *name, tsize_t offset)
+{
+	tsize_t b_offset;
+	tsize_t current;
+
+	if (!name)
+		name = "";
+
+	b_offset = get_buffer_file_offset(handle, name);
+	if (!b_offset) {
+		tracecmd_warning("Cannot find description for buffer %s\n", name);
+		return -1;
+	}
+
+	current = lseek64(handle->fd, 0, SEEK_CUR);
+
+	/* Go to the option data, where will write the offest */
+	if (lseek64(handle->fd, b_offset, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("could not seek to %lld\n", b_offset);
+		return -1;
+	}
+
+	if (do_write_check(handle, &offset, 8))
+		return -1;
+
+	/* Go back to end of file */
+	if (lseek64(handle->fd, current, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("could not seek to %lld\n", offset);
+		return -1;
+	}
+	return 0;
+}
+
+
 static char *get_clock(struct tracecmd_output *handle)
 {
 	struct tracefs_instance *inst;
-- 
2.31.1

