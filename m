Return-Path: <SRS0=o+Or=4W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAD2C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Mar 2020 17:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2260E20848
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Mar 2020 17:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgCERq6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 12:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCERq5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 12:46:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B881E20848;
        Thu,  5 Mar 2020 17:46:56 +0000 (UTC)
Date:   Thu, 5 Mar 2020 12:46:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Adjust host_trace_info structure to be better
 packed
Message-ID: <20200305124655.0738a585@gandalf.local.home>
In-Reply-To: <20200304091220.30936-8-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
        <20200304091220.30936-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Move the unsigned long long trace_id out from between the boolean
sync_enable and the int ts_samples_count, which removes the gap in the
structure, making the structure size drop from 32 bytes to 24, as displayed
by pahole.

Before:

struct host_trace_info {
        _Bool                      sync_enable;          /*     0     1 */

        /* XXX 7 bytes hole, try to pack */

        long long unsigned int     trace_id;             /*     8     8 */
        int                        ts_samples_count;     /*    16     4 */

        /* XXX 4 bytes hole, try to pack */

        struct ts_offset_sample * ts_samples;            /*    24     8 */

        /* size: 32, cachelines: 1, members: 4 */
        /* sum members: 21, holes: 2, sum holes: 11 */
        /* last cacheline: 32 bytes */
};

After:

struct host_trace_info {
        long long unsigned int     trace_id;             /*     0     8 */
        _Bool                      sync_enable;          /*     8     1 */

        /* XXX 3 bytes hole, try to pack */

        int                        ts_samples_count;     /*    12     4 */
        struct ts_offset_sample * ts_samples;            /*    16     8 */

        /* size: 24, cachelines: 1, members: 4 */
        /* sum members: 21, holes: 1, sum holes: 3 */
        /* last cacheline: 24 bytes */
};

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

This is why I'm picky on ordering of fields in data structures.
I'm sure there's many more places we can update here.

-- Steve


 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2f0274d9..a1241f4b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -83,8 +83,8 @@ struct ts_offset_sample {
 };
 
 struct host_trace_info {
-	bool			sync_enable;
 	unsigned long long	trace_id;
+	bool			sync_enable;
 	int			ts_samples_count;
 	struct ts_offset_sample	*ts_samples;
 };
-- 
2.20.1

