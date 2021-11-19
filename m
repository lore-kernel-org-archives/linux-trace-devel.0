Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE34DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Nov 2021 11:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5EEE61159
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Nov 2021 11:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhKSL1b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 06:27:31 -0500
Received: from smtp2.axis.com ([195.60.68.18]:55572 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234531AbhKSL1a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 06:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1637321068;
  x=1668857068;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nnLyNY7sxUxbbJ2i6ztxc32WwCrFGNJ3izpmu2LqwfA=;
  b=IKwOj8Ep9PcqLyiHDrHAmUjF2MYvUKLeig5fdCQdw+Y0tPHu5S0d+AwY
   +1yvhJ6Zl1WdMEkJdSrYfwJyUySGrrDGFps3sqAZU79MFxr4TCW3O8pfr
   qj1ggeaRN1WQ21aEYed4IIE0tQwMOUx/0FVBYc8brQcQsjADv3B3YyR8Y
   VIrbVZCEBqDLgHJlU1dVHBlJ0M+Xhu2ZQIn8J7fR8vS7OFao0zZsqkTMN
   o5e1Toi54s9yr/Xo5CH0wVlcKWd0P4M2lO/P9f4qoOL4kl0c1SsMwpfai
   qZHM6G0xHyWE5oGNekVsqc5LjwZod2cPF9EFYQTC0wjGE1fk9EkAbJ4j4
   Q==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <rostedt@goodmis.org>
CC:     <linux-trace-devel@vger.kernel.org>, <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH] trace-cmd report: Avoid crash on unknown event
Date:   Fri, 19 Nov 2021 12:24:20 +0100
Message-ID: <20211119112420.4826-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not segfault if the event cannot be found for some reason and
tep_find_event_by_record() returns NULL.

No extra warning is added since there are others ("UNKNOWN EVENT") which
already make it clear that something is wrong:

 kworker/u8:0-7 [003] 1.245773: sched_stat_runtime: comm=kworker/u8:...
[UNKNOWN EVENT][UNKNOWN EVENT][UNKNOWN EVENT]
 kworker/u8:0-7 [003] 1.245776: sched_switch: kworker/u8:0:7 [120] W...

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 tracecmd/trace-read.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6f43c1d..145c823 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -890,7 +890,8 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		trace_seq_printf(&s, " %-8s", buf);
 	}
 
-	print_event_name(&s, event);
+	if (event)
+		print_event_name(&s, event);
 	tep_print_event(pevent, &s, record, "%s", format_type);
 
 	if (s.len && *(s.buffer + s.len - 1) == '\n')
-- 
2.20.1

