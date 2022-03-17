Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9A4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Mar 2022 20:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiCQU46 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiCQU45 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Mar 2022 16:56:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEAC5F6E
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Mar 2022 13:55:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 996B261983
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Mar 2022 20:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4179C340E9
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Mar 2022 20:55:38 +0000 (UTC)
Date:   Thu, 17 Mar 2022 16:55:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Fix tracecmd_read_at()
Message-ID: <20220317165537.46d5685b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The compression logic set all the file_offsets for the cpu_data to zero to
just use absolute offsets. But this breaks tracecmd_read_at() that has a
requirement that every record in a handle has a unique offset. This
includes records on different CPUs.

Make the file_offset unique and start at a new page boundary from the
previous cpu_data. Use next_offset in the input handle to keep track of
the last stored cpu_data and set the next cpu_data file_offset to it.

Also slightly restructure the input handle structure to be a little more
compact.

Fixes: 5113584096350 ("trace-cmd library: Initialize CPU data decompression logic")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index aa40d2451ab6..56410fb0c228 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -158,11 +158,12 @@ struct file_section {
 
 struct tracecmd_input {
 	struct tep_handle	*pevent;
-	unsigned long		file_state;
 	struct tep_plugin_list	*plugin_list;
 	struct tracecmd_input	*parent;
-	unsigned long		flags;
+	unsigned long		file_state;
 	unsigned long long	trace_id;
+	unsigned long long	next_offset;
+	unsigned long		flags;
 	int			fd;
 	int			long_size;
 	int			page_size;
@@ -1349,6 +1350,8 @@ static void *read_zpage(struct tracecmd_input *handle, int cpu, off64_t offset)
 	int pindex;
 	int size;
 
+	offset -= cpu_data->file_offset;
+
 	/* Look in the cache of already loaded chunks */
 	list_for_each_entry(cache, &cpu_data->compress.cache, list) {
 		if (CHUNK_CHECK_OFFSET(cache->chunk, offset)) {
@@ -2665,8 +2668,11 @@ static int init_cpu_zfile(struct tracecmd_input *handle, int cpu)
 	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
 		return -1;
 
-	cpu_data->offset = 0;
-	cpu_data->file_offset = 0;
+	cpu_data->file_offset = handle->next_offset;
+	handle->next_offset = (handle->next_offset + size + handle->page_size - 1) &
+		~(handle->page_size - 1);
+	cpu_data->offset = cpu_data->file_offset;
+
 	cpu_data->file_size = size;
 	cpu_data->size = size;
 	return 0;
@@ -2688,12 +2694,15 @@ static int init_cpu_zpage(struct tracecmd_input *handle, int cpu)
 	cpu_data->compress.count = count;
 	cpu_data->compress.last_chunk = 0;
 
-	cpu_data->file_offset = 0;
-	cpu_data->file_size = 0;
+	cpu_data->file_offset = handle->next_offset;
+
 	for (i = 0; i < count; i++)
 		cpu_data->file_size += cpu_data->compress.chunks[i].size;
+
 	cpu_data->offset = cpu_data->file_offset;
 	cpu_data->size = cpu_data->file_size;
+	handle->next_offset = (handle->next_offset + cpu_data->size + handle->page_size - 1) &
+		~(handle->page_size - 1);
 	return 0;
 }
 
@@ -4249,6 +4258,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	read4(handle, &page_size);
 	handle->page_size = page_size;
+	handle->next_offset = page_size;
 
 	offset = lseek64(handle->fd, 0, SEEK_CUR);
 	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
-- 
2.35.1

