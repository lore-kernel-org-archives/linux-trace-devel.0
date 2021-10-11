Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC5DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F32061039
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 04:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhJKE2m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 00:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhJKE2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 00:28:42 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08665C061570
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id ec8so12812380edb.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 10 Oct 2021 21:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kYgZ2HI1j/TuevF06TjqGZu1L3z66jl8PYtin0o0NTQ=;
        b=iKPpmVY7wyXw6ZIoWGAl3TBAZZAtXECtO9Ok+bpSGmHq30sxZo8qODnBb5nEQaq7Gm
         iYuzs5ySqHBhLZU/O/Hh3ZTRrxL2vAljJqahYs02Q99J9DtSVLZS5WhNrNMtk12yc0aC
         jKBk0wYXk8D7pgWvS7O5jGpuG9z0SsMHFy8biiJQRzSbO3lv4pq1ZZ06B45xSRLa3aek
         DvhZOrB3KFMAUJsZImeDJz5PMqroI1Y4mUPd4XNf23cfrZXW+gYP9r60Ebt/xj+ntUyl
         FSWEaph4t7185FldwfOaRaOn5ihhzpl0sfg/tYNQYQkqh7inP8+puQZFcR1vY9M0Fxsc
         gR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kYgZ2HI1j/TuevF06TjqGZu1L3z66jl8PYtin0o0NTQ=;
        b=6hOFjzxMRjOGkMwQvo55eV05U+eULP6JO9n6oFd6xEBn19zANmqSJ+cDHh7sWC28yW
         iWCk5HOdNc376K9HKQsSoUVmNXW1MeKC/1Q6jO6HxdyyPcv2JB9Zw6f7md/CvBgadqZR
         2K7Cspvz2o/4960nlYtHl6F8sryD8Rusz/YcDGshorypK2Hmi8i+A12UOr+a9wrmnbAy
         uaXXqHdedK8TtiVDtLzwoDpE9MRNqrYaHJfkrcl+L357pmUj/Qrfn1N7tj2N5PcxJ/1r
         gYd4kZWRErheSjkll0lU5dbwU0bYDmBrCoYjv0YoJ42Bfe4WM5ke6JcwpUQIG9O5FyTy
         3EOw==
X-Gm-Message-State: AOAM530NPT+p6EOGXCWmKXrOzmOvauGKvVl7fLPHHmLr8tbLcSbwdS2/
        FBcQ5bT1MCtuoxxPJjfGERF0WeK9pVYeBA==
X-Google-Smtp-Source: ABdhPJw17DxhwJcc6tF5/QQF8KC65aZ65KZ2f45yQYnxs7xr96yZlZP2UbRlWsFWiEW3eENSt5PzOw==
X-Received: by 2002:a17:906:9742:: with SMTP id o2mr22646464ejy.532.1633926401669;
        Sun, 10 Oct 2021 21:26:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j21sm3406532edr.64.2021.10.10.21.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 21:26:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/4] trace-cmd library: Helper logic to update the trace buffer offset
Date:   Mon, 11 Oct 2021 07:26:35 +0300
Message-Id: <20211011042636.1608374-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211011042636.1608374-1-tz.stoyanov@gmail.com>
References: <20211011042636.1608374-1-tz.stoyanov@gmail.com>
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

