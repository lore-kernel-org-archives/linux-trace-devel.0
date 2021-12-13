Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D93DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Dec 2021 10:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhLMKAl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 05:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbhLMJ6i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 04:58:38 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042F2C08EB26
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:32 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x15so50878828edv.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nT5H9R/pOtRAaqy/oVUuO0tXM2N6pl9SsLnStip9vsg=;
        b=UxwNGFSdPnZp3Jo4Ac3zw9YpAk4zQzQnnHbWBaXNWxH7UDAbO9O4g1Ph1cfiLyjWf/
         gU629Ks15EWUpAinc9rn/1j8dkv3KtoCpvr1og/dSPR+1QWHEIjLk0makkq7WZ1LZL8k
         Oxi4GB9zfIUCWb24UM0D3KNaodP9lcNsZworJVmiIpE9rqUI7fXYKANDNiR7MM+mpr3N
         pXvDotL1ielc03cV/WXabcUYHZSdro0oTSJ2DI6D6YN07rd+3S2nHcjvsU9ZcT78OkTK
         gqIUF7srddivo1gF2a6JtxLproyu3LCnP+Hy8Plt2mp+mpFY4dE6qpWOj7ldVa00jw36
         167g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nT5H9R/pOtRAaqy/oVUuO0tXM2N6pl9SsLnStip9vsg=;
        b=KIXEbuqKT4RlVvqB5WCrSEf5XZ0DJ3Nz9WZmk9MQ7kS++2ErSIHNHkQ6OBhwXTihFm
         oVnUW8qHJ2nw+cyzYx898piEseTs7CqQZXPRS/He3ohE2EKCGyuBT+JDD4X2b/OkB+DQ
         YXy6a8Y+uEK3rgUKA2zl8HiGC4lrq12IEsFDSmAkQr4YP5UBsLMGg2RP7wDxTAR5pdJX
         94Lr4RKOpgH1Zznc2xDvjau/lfhxda5Y8y0jFTOs3ZQOPOGczW/QlLTh+VTGa+hrhTKl
         UMJUSk/sUnu/pAwtShqPN+IY7i72xm3PlJhADNd3PHX/3EAq8KgcA1DJ6qV6LOZerbYQ
         VLRg==
X-Gm-Message-State: AOAM533KPC1GAh8AgqrRFI63lJ15UZs38OUMS1UBUcQjM7PjUUfP4zp/
        4QrE2fLPcwQ2+c9N4wmq/SLXaWLphJQ=
X-Google-Smtp-Source: ABdhPJxRgyGXpyeG4zpMxcDxJ9iDQ2BOkLCUsCPjFF/zxSzz1C3HtIoWf50AhKwpGJV3/xQLqcgElQ==
X-Received: by 2002:a17:906:f43:: with SMTP id h3mr43052592ejj.414.1639388910608;
        Mon, 13 Dec 2021 01:48:30 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id yd20sm5465748ejb.47.2021.12.13.01.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 01:48:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/5] [RFC] tracing: Add interface for configuring trace sub buffer size
Date:   Mon, 13 Dec 2021 11:48:23 +0200
Message-Id: <20211213094825.61876-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211213094825.61876-1-tz.stoyanov@gmail.com>
References: <20211213094825.61876-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace ring buffer sub page size can be configured, per trace
instance. A new ftrace file "buffer_subbuf_order" is added to get and
set the size of the ring buffer sub page for current trace instance.
The size must be an order of system page size, that's why the new
interface works with system page order, instead of absolute page size:
0 means the ring buffer sub page is equal to 1 system page and so
forth:
0 - 1 system page
1 - 2 system pages
2 - 4 system pages
...
The ring buffer sub page size is limited between 1 and 128 system
pages. The default value is 1 system page.
New ring buffer APIs are introduced:
 ring_buffer_subbuf_order_set()
 ring_buffer_subbuf_order_get()
 ring_buffer_subbuf_size_get()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/linux/ring_buffer.h |  4 ++
 kernel/trace/ring_buffer.c  | 73 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c        | 48 ++++++++++++++++++++++++
 3 files changed, 125 insertions(+)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index d9a2e6e8fb79..9103462f6e85 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -202,6 +202,10 @@ struct trace_seq;
 int ring_buffer_print_entry_header(struct trace_seq *s);
 int ring_buffer_print_page_header(struct trace_buffer *buffer, struct trace_seq *s);
 
+int ring_buffer_subbuf_order_get(struct trace_buffer *buffer);
+int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order);
+int ring_buffer_subbuf_size_get(struct trace_buffer *buffer);
+
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 68fdeff449c3..4aa5361a8f4c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -511,6 +511,7 @@ struct trace_buffer {
 	bool				time_stamp_abs;
 
 	unsigned int			subbuf_size;
+	unsigned int			subbuf_order;
 	unsigned int			max_data_size;
 };
 
@@ -5679,6 +5680,78 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_page);
 
+/**
+ * ring_buffer_subbuf_size_get - get size of the sub buffer.
+ * @buffer: the buffer to get the sub buffer size from
+ *
+ * Returns size of the sub buffer, in bytes.
+ */
+int ring_buffer_subbuf_size_get(struct trace_buffer *buffer)
+{
+	return buffer->subbuf_size + BUF_PAGE_HDR_SIZE;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_subbuf_size_get);
+
+/**
+ * ring_buffer_subbuf_order_get - get order of system sub pages in one buffer page.
+ * @buffer: The ring_buffer to get the system sub page order from
+ *
+ * By default, one ring buffer sub page equals to one system page. This parameter
+ * is configurable, per ring buffer. The size of the ring buffer sub page can be
+ * extended, but must be an order of system page size.
+ *
+ * Returns the order of buffer sub page size, in system pages:
+ * 0 means the sub buffer size is 1 system page and so forth.
+ * In case of an error < 0 is returned.
+ */
+int ring_buffer_subbuf_order_get(struct trace_buffer *buffer)
+{
+	if (!buffer)
+		return -EINVAL;
+
+	return buffer->subbuf_order;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_subbuf_order_get);
+
+/**
+ * ring_buffer_subbuf_order_set - set the size of ring buffer sub page.
+ * @buffer: The ring_buffer to set the new page size.
+ * @order: Order of the system pages in one sub buffer page
+ *
+ * By default, one ring buffer pages equals to one system page. This API can be
+ * used to set new size of the ring buffer page. The size must be order of
+ * system page size, that's why the input parameter @order is the order of
+ * system pages that are allocated for one ring buffer page:
+ *  0 - 1 system page
+ *  1 - 2 system pages
+ *  3 - 4 system pages
+ *  ...
+ *
+ * Returns 0 on success or < 0 in case of an error.
+ */
+int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order)
+{
+	int psize;
+
+	if (!buffer || order < 0)
+		return -EINVAL;
+
+	if (buffer->subbuf_order == order)
+		return 0;
+
+	psize = (1 << order) * PAGE_SIZE;
+	if (psize <= BUF_PAGE_HDR_SIZE)
+		return -EINVAL;
+
+	buffer->subbuf_order = order;
+	buffer->subbuf_size = psize - BUF_PAGE_HDR_SIZE;
+
+	/* Todo: reset the buffer with the new page size */
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_subbuf_order_set);
+
 /*
  * We only allocate new buffers, never free them if the CPU goes down.
  * If we were to free the buffer, then the user would lose any trace that was in
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0eb8af875184..867a220b4ef2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9015,6 +9015,51 @@ static const struct file_operations buffer_percent_fops = {
 	.llseek		= default_llseek,
 };
 
+static ssize_t
+buffer_order_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	char buf[64];
+	int r;
+
+	r = sprintf(buf, "%d\n", ring_buffer_subbuf_order_get(tr->array_buffer.buffer));
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+buffer_order_write(struct file *filp, const char __user *ubuf,
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
+	/* limit between 1 and 128 system pages */
+	if (val < 0 || val > 7)
+		return -EINVAL;
+
+	ret = ring_buffer_subbuf_order_set(tr->array_buffer.buffer, val);
+	if (ret)
+		return ret;
+
+	(*ppos)++;
+
+	return cnt;
+}
+
+static const struct file_operations buffer_order_fops = {
+	.open		= tracing_open_generic_tr,
+	.read		= buffer_order_read,
+	.write		= buffer_order_write,
+	.release	= tracing_release_generic_tr,
+	.llseek		= default_llseek,
+};
+
 static struct dentry *trace_instance_dir;
 
 static void
@@ -9468,6 +9513,9 @@ init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("buffer_percent", TRACE_MODE_READ, d_tracer,
 			tr, &buffer_percent_fops);
 
+	trace_create_file("buffer_subbuf_order", TRACE_MODE_WRITE, d_tracer,
+			  tr, &buffer_order_fops);
+
 	create_trace_options_dir(tr);
 
 	trace_create_maxlat_file(tr, d_tracer);
-- 
2.31.1

