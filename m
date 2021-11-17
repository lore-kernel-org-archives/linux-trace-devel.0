Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CCBC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38CFF613A9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Nov 2021 15:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbhKQPoQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 10:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbhKQPoG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 10:44:06 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ED3C061767
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:07 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 133so2672312wme.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 07:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z9jq70DY785RJKiVkynFlhsbyYAZqSl/4WPVwHec/NU=;
        b=UniPcuIM+t9Din2codUD+HfxzpAA850t/jNYvSAxEDKqmZ2fUHN+CxmCrXJcc+Ehga
         gtJcQAxOAtBew+NDxHOz3bWUXYis90B9CXi+wOIHy5Hx5pebSfF5290MRRf/D0Ied+V0
         bdcyJk+pw9e5sIyo5dEGePDbNR7FLI+HOgkVkEdI3g03N8OUzguW/x89yHOTTB7BXv7i
         3vuVaS3FHs1e3S17zGhf0rfeddGfdFtGYWmDF25H3mnyrrISkwN3TtLRUdRxwZT6gOKE
         /WTFa3a5HjmwVbHtwBHzSw4kliEgnb+gFmXog494PFWkkIQAicx3miN0LhCxzmb+Yla/
         afmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z9jq70DY785RJKiVkynFlhsbyYAZqSl/4WPVwHec/NU=;
        b=P08OFXftxPqI7uq4SJ8D9Ez1So91HhPMlOyTUCi2SEh8C/M6MpfD8o3AgyRkJCntYH
         FvA8Sd8l1P9cZm2F19VLUCsJJUPsqwyA2bTR1RymW/O/JpHEO12SOPp+NVp6sslxt4Me
         Denwqp7jHc3DbCA0XL8oGXajs4KhQfLDW3n4Kq/6FBL40V7HOCT00DjEkIv3ybHOujqL
         yJroZFaenqM+74nUNCV3gwGeAJda62dXB+KmYVgwZu/h4bBOIMrTF9IjSXjdnRgTsm6s
         4OAF/pMnaklV4cBdEjWFj76DCD7Jfno8N02gnp2ioxjvkukHz2daU2lfOJeDmCBkAGEt
         LRRA==
X-Gm-Message-State: AOAM531OshPS+tmj5MAWaYMhQ8k7qnNxq/UcJXLjcqm5zB1PBtd+b9eh
        04/gXA3I+1HXwtRdwZBs9usvj1QtkSSxRQ==
X-Google-Smtp-Source: ABdhPJxd9Wi5yDl949YpLziOTo33S20clVe0hJoXIbYZfXOU20aRipLqhgG8yzsJqp7iOGwd7wU7kw==
X-Received: by 2002:a05:600c:a08:: with SMTP id z8mr642300wmp.165.1637163666288;
        Wed, 17 Nov 2021 07:41:06 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d7sm185759wrw.87.2021.11.17.07.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:41:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] [RFC] trace: Add interface for configuring trace ring buffer size
Date:   Wed, 17 Nov 2021 17:41:00 +0200
Message-Id: <20211117154101.38659-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117154101.38659-1-tz.stoyanov@gmail.com>
References: <20211117154101.38659-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace ring buffer page size can be configured, per trace instance. A
new ftrace file "buffer_page_size" is added to get and set the size of
the ring buffer page for current trace instance. The size must be
multiple of system page size, that's why the new interface works with
system page count, instead of absolute page size: 1 means the ring
buffer page is equal to one system page and so forth. The ring buffer
page is limited between 1 and 100 system pages.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/linux/ring_buffer.h |  3 +++
 kernel/trace/ring_buffer.c  | 51 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c        | 47 ++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index d9a2e6e8fb79..53cd7a38b717 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -202,6 +202,9 @@ struct trace_seq;
 int ring_buffer_print_entry_header(struct trace_seq *s);
 int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq *s);
 
+int ring_buffer_page_size_get(struct trace_buffer *buffer);
+int ring_buffer_page_size_set(struct trace_buffer *buffer, int psize);
+
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6bca2977ca1a..9aa245795c3d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5677,6 +5677,57 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_page);
 
+/**
+ * ring_buffer_page_size_get - get count of system pages in one buffer page.
+ * @buffer: The ring_buffer to get the system page count from
+ *
+ * By default, one ring buffer pages equals to one system page. This parameter
+ * is configurable, per ring buffer. The size of the ring buffer page can be
+ * extended, but must be multiple of system page size.
+ *
+ * Returns the size of buffer page, in system pages: 1 means the buffer size is
+ * one system page and so forth. In case of an error < 0 is returned.
+ */
+int ring_buffer_page_size_get(struct trace_buffer *buffer)
+{
+	if (!buffer)
+		return -EINVAL;
+
+	return (buffer->page_size + BUF_PAGE_HDR_SIZE) / PAGE_SIZE;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_page_size_get);
+
+/**
+ * ring_buffer_page_size_set - set the size of ring buffer page.
+ * @buffer: The ring_buffer to set the new page size.
+ * @pcount: Number of system pages.
+ *
+ * By default, one ring buffer pages equals to one system page. This API can be
+ * used to set new size of the ring buffer page. The size must be multiple of
+ * system page size, that's why the input parameter @pcount is the count of
+ * system pages that are allocated for one ring buffer page.
+ *
+ * Returns 0 on success or < 0 in case of an error.
+ */
+int ring_buffer_page_size_set(struct trace_buffer *buffer, int pcount)
+{
+	int psize;
+
+	if (!buffer)
+		return -EINVAL;
+
+	psize = pcount * PAGE_SIZE;
+	if (psize <= BUF_PAGE_HDR_SIZE)
+		return -EINVAL;
+
+	buffer->page_size = psize - BUF_PAGE_HDR_SIZE;
+
+	/* Todo: reset the buffer with the new page size */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_page_size_set);
+
 /*
  * We only allocate new buffers, never free them if the CPU goes down.
  * If we were to free the buffer, then the user would lose any trace that was in
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f9139dc1262c..05fc2712fdbd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9005,6 +9005,50 @@ static const struct file_operations buffer_percent_fops = {
 	.llseek		= default_llseek,
 };
 
+static ssize_t
+buffer_psize_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	char buf[64];
+	int r;
+
+	r = sprintf(buf, "%d\n", ring_buffer_page_size_get(tr->array_buffer.buffer));
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+buffer_psize_write(struct file *filp, const char __user *ubuf,
+		   size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val < 1 || val > 100)
+		return -EINVAL;
+
+	ret = ring_buffer_page_size_set(tr->array_buffer.buffer, val);
+	if (ret)
+		return ret;
+
+	(*ppos)++;
+
+	return cnt;
+}
+
+static const struct file_operations buffer_psize_fops = {
+	.open		= tracing_open_generic_tr,
+	.read		= buffer_psize_read,
+	.write		= buffer_psize_write,
+	.release	= tracing_release_generic_tr,
+	.llseek		= default_llseek,
+};
+
 static struct dentry *trace_instance_dir;
 
 static void
@@ -9458,6 +9502,9 @@ init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("buffer_percent", TRACE_MODE_READ, d_tracer,
 			tr, &buffer_percent_fops);
 
+	trace_create_file("buffer_page_size", TRACE_MODE_WRITE, d_tracer,
+			tr, &buffer_psize_fops);
+
 	create_trace_options_dir(tr);
 
 	trace_create_maxlat_file(tr, d_tracer);
-- 
2.31.1

