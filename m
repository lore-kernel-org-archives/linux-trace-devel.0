Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8C3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiENCzX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E5D34A026
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1518861E1F
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE23C341CB;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XND-N7;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 20/26] trace-cmd library: Add tracecmd_prepare_options()
Date:   Fri, 13 May 2022 22:47:50 -0400
Message-Id: <20220514024756.1319681-21-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a new interface tracecmd_prepare_options() that can be used by
tracecmd_msg to update the next options before flushing over the network.
Once the last options is written to the network, it can not be updated to
point to the next options section.

The tracecmd_prepare_options() will update the last options in the file to
point to the offset of the next one (before they are written). The
location of the next options must be known (obviously), but this means
that the data can be flushed over the network before the next options are
written. The use case is where there's options that need to be added when
the trace is done, but the beginning of the trace file is already sent out
over the network.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 90 +++++++++++++++++--
 2 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ef2351e8491f..28fa712c4de8 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -333,6 +333,7 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle);
 
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
+int tracecmd_prepare_options(struct tracecmd_output *handle, off64_t offset, int whence);
 int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_write_meta_strings(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ca7132e113c0..1fc41424eca7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -69,6 +69,7 @@ struct tracecmd_output {
 	unsigned long		strings_offs;
 
 	unsigned long long	options_start;
+	unsigned long long	options_next;
 	bool			big_endian;
 	bool			do_compress;
 	struct tracecmd_compression *compress;
@@ -1841,6 +1842,66 @@ static int write_options_v6(struct tracecmd_output *handle)
 	return 0;
 }
 
+static int update_options_start(struct tracecmd_output *handle, off64_t offset)
+{
+	if (do_lseek(handle, handle->options_start, SEEK_SET) == (off64_t)-1)
+		return -1;
+	offset = convert_endian_8(handle, offset);
+	if (do_write_check(handle, &offset, 8))
+		return -1;
+	return 0;
+}
+
+/**
+ * tracecmd_pepare_options - perpare a previous options for the next
+ * @handle: The handle to update the options for.
+ * @offset: The offset to set the previous options to.
+ * @whence: Where in the file to offset from.
+ *
+ * In a case of cached writes for network access, the options offset
+ * cannot be written once it goes over the network. This is used
+ * to update the next options to a known location.
+ *
+ * tracecmd_write_options() must be called when the offset is at the next
+ * location, otherwise the data file will end up corrupted.
+ *
+ * Returns zero on success and -1 on error.
+ */
+int tracecmd_prepare_options(struct tracecmd_output *handle, off64_t offset, int whence)
+{
+	tsize_t curr;
+	int ret;
+
+	/* No options to start with? */
+	if (!handle->options_start)
+		return 0;
+
+	curr = do_lseek(handle, 0, SEEK_CUR);
+
+	switch (whence) {
+	case SEEK_SET:
+		/* just use offset */
+		break;
+	case SEEK_CUR:
+		offset += curr;
+		break;
+	case SEEK_END:
+		offset = do_lseek(handle, offset, SEEK_END);
+		if (offset == (off64_t)-1)
+			return -1;
+		break;
+	}
+	ret = update_options_start(handle, offset);
+	if (ret < 0)
+		return -1;
+
+	handle->options_next = offset;
+
+	curr = do_lseek(handle, curr, SEEK_SET);
+
+	return curr == -1 ? -1 : 0;
+}
+
 static int write_options(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
@@ -1849,6 +1910,7 @@ static int write_options(struct tracecmd_output *handle)
 	unsigned int endian4;
 	bool new = false;
 	tsize_t offset;
+	int ret;
 
 	/* Check if there are unsaved options */
 	list_for_each_entry(options, &handle->options, list) {
@@ -1857,18 +1919,34 @@ static int write_options(struct tracecmd_output *handle)
 			break;
 		}
 	}
-	if (!new)
+	/*
+	 * Even if there are no new options, if options_next is set, it requires
+	 * adding a new empty options section as the previous one already
+	 * points to it.
+	 */
+	if (!new && !handle->options_next)
 		return 0;
 	offset = do_lseek(handle, 0, SEEK_CUR);
 
+	if (handle->options_next) {
+		/* options_start was already updated */
+		if (handle->options_next != offset) {
+			tracecmd_warning("Options offset (%lld) does not match expected (%lld)",
+					 offset, handle->options_next);
+			return -1;
+		}
+		handle->options_next = 0;
+		/* Will be updated at the end */
+		handle->options_start = 0;
+	}
+
 	/* Append to the previous options section, if any */
 	if (handle->options_start) {
-		if (do_lseek(handle, handle->options_start, SEEK_SET) == (off64_t)-1)
-			return -1;
-		endian8 = convert_endian_8(handle, offset);
-		if (do_write_check(handle, &endian8, 8))
+		ret = update_options_start(handle, offset);
+		if (ret < 0)
 			return -1;
-		if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
+		offset = do_lseek(handle, offset, SEEK_SET);
+		if (offset == (off_t)-1)
 			return -1;
 	}
 
-- 
2.35.1

