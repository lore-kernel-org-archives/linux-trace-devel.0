Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155A5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 23:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiBUXOe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 18:14:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiBUXOe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 18:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5686566
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 15:14:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C76ECB8125F
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 23:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5079CC340E9;
        Mon, 21 Feb 2022 23:14:07 +0000 (UTC)
Date:   Mon, 21 Feb 2022 18:14:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] trace-cmd: Show uncompressed size at end of record
Message-ID: <20220221181405.2dae5930@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of showing just the size of the compressed data at the end of the
record, also show the uncompressed size, but only for when compression is
done. It also lets the user know that the file is compressed, as the
writing of the compressed data takes much longer than just appending the
data straight.

CPU0 data recorded at offset=0x161000
    17123100 bytes in size (101777408 uncompressed)
CPU1 data recorded at offset=0x11b6000
    13519375 bytes in size (81039360 uncompressed)
CPU2 data recorded at offset=0x1e9b000
    14297750 bytes in size (91959296 uncompressed)
CPU3 data recorded at offset=0x2c3e000
    3926 bytes in size (20480 uncompressed)
CPU4 data recorded at offset=0x2c3f000
    13216913 bytes in size (78225408 uncompressed)
CPU5 data recorded at offset=0x38da000
    11489333 bytes in size (67829760 uncompressed)
CPU6 data recorded at offset=0x43d0000
    9342842 bytes in size (54976512 uncompressed)
CPU7 data recorded at offset=0x4cb9000
    14085776 bytes in size (94261248 uncompressed)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e7915aa6376e..de9198a54cea 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2452,9 +2452,14 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 			if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
 		}
-		if (!tracecmd_get_quiet(handle))
-			fprintf(stderr, "    %llu bytes in size\n",
+		if (!tracecmd_get_quiet(handle)) {
+			fprintf(stderr, "    %llu bytes in size",
 				(unsigned long long)data_files[i].write_size);
+			if (flags & TRACECMD_SEC_FL_COMPRESS)
+				fprintf(stderr, " (%llu uncompressed)",
+					(unsigned long long)data_files[i].file_size);
+			fprintf(stderr, "\n");
+		}
 	}
 
 	if (HAS_SECTIONS(handle) &&
-- 
2.34.1

