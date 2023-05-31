Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86BCC77B73
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 May 2023 09:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbjEaJyI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 May 2023 05:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbjEaJyH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 May 2023 05:54:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E0D10B
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 May 2023 02:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED1862A03
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 May 2023 09:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF6FC433D2;
        Wed, 31 May 2023 09:54:05 +0000 (UTC)
Date:   Wed, 31 May 2023 05:54:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Douglas Raillard <douglas.raillard@arm.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH] libtracecmd: Fix tracecmd_compress_copy_from() write size
 return
Message-ID: <20230531055401.1f04a9fd@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The amount written to the file returned by tracecmd_compress_copy_from()
is off by 4 bytes. This is because it did not account for the writing of
the number of chunks saved.

Instead of calculating the amount written to the file, as lseek() is used to
find the chunk value and also put it back to the end of what was written,
use the results of lseek() to figure out the amount written.

It appears that the decompression of the sections did not use the size of
the buffer section, but instead used the size inside each chunk. That is,
it read the chunks within the buffer section and based what it would read
from the file by the size of each chunk, and did not use the value defined
in the section header.

Reported-by: Douglas Raillard <douglas.raillard@arm.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217367
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-compress.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 1b852f18d3ab..ca6e03b88e69 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -671,13 +671,13 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 {
 	unsigned int rchunk = 0;
 	unsigned int chunks = 0;
-	unsigned int wsize = 0;
 	unsigned int rsize = 0;
 	unsigned int rmax = 0;
 	unsigned int csize;
 	unsigned int size;
 	unsigned int all;
 	unsigned int r;
+	off_t end_offset;
 	off_t offset;
 	char *buf_from;
 	char *buf_to;
@@ -748,8 +748,6 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 			ret = write_fd(handle->fd, buf_to, size);
 			if (ret != size)
 				break;
-			/* data + compress header */
-			wsize += (size + 8);
 			chunks++;
 		}
 	} while (all > 0);
@@ -766,13 +764,14 @@ int tracecmd_compress_copy_from(struct tracecmd_compression *handle, int fd, int
 	endian4 = tep_read_number(handle->tep, &chunks, 4);
 	/* write chunks count*/
 	write_fd(handle->fd, &chunks, 4);
-	if (lseek(handle->fd, 0, SEEK_END) == (off_t)-1)
+	end_offset = lseek(handle->fd, 0, SEEK_END);
+	if (end_offset == (off_t)-1)
 		return -1;
 
 	if (read_size)
 		*read_size = rsize;
 	if (write_size)
-		*write_size = wsize;
+		*write_size = end_offset - offset;
 	return 0;
 }
 
-- 
2.39.2

