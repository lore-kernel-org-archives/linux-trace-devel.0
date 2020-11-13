Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAC4C388F7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA67A22240
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:30:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=axis.com header.i=@axis.com header.b="IPbS/P90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgKMNaC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 08:30:02 -0500
Received: from smtp2.axis.com ([195.60.68.18]:36976 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgKMNaC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 08:30:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=962; q=dns/txt; s=axis-central1;
  t=1605274202; x=1636810202;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7gBAdAP0JwXkReIsBWTtCs168e4RZFbN8th5G+8QUZo=;
  b=IPbS/P90esUdUDU6HxBliGtU//Ck5erIwIRomvkVKW/jaZp9zDzgcuDG
   Iyw8Wfaz0Tyw9niCc6rKEagPod1kmbYCzx6DDSoLlNlVSY0bHe9XgNxaf
   rkHf9zg3CwmoxgkDPZGyrucyGvx6y7ctnESvtRnGxi0zeZ4619b802/KK
   LkycKYaZtfF68l9dWY2n8VSJnAr7NggxTiOVr9hKKMKGcpeFiadt3KDMZ
   ZIVYlb89As6ngpSPxmiOzr7aLWOZM3d7MZd8qAe3OkS9iLDP1f8pE25g6
   5YZeRfJnNxhb4f92NYVw2BGCuKg9UcnvW70al4AnOtAohaf5YvDQrHDzn
   Q==;
IronPort-SDR: y9t0e/zBwn8Iij2rZKjrDFpeivflb/5DEAISM4sB/kUkl1rQnSptslAF6KsPK58XdpB2Dtk4pG
 ypGhzgNrniBRDW3+o94jQi9rjATFqC0Xo6MNmrn1yzjdKUjxGji70TsNRm+q1x8Yha9kflNDEH
 RkXx18gIENi9RZMbbBLlzhsiMXXHjg+ZqC1zL01VybiEXKqwFR3nqMeFTaAZGdXGw/z1olhAPR
 nULsp0uIDVJuuz0HU22lOjfHx91YDpzw6iGeJWBkz5x48dDVNml1+hY/ZQQvMLWE3Rk5jBQhW6
 yak=
X-IronPort-AV: E=Sophos;i="5.77,475,1596492000"; 
   d="scan'208";a="14505761"
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <rostedt@goodmis.org>
CC:     <linux-trace-devel@vger.kernel.org>, <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [PATCH] trace-cmd libtraceevent: Fix bprint '#' parsing
Date:   Fri, 13 Nov 2020 14:29:53 +0100
Message-ID: <20201113132953.2371-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix handling of '#' in bprint format specifiers.

For example, with this:

 trace_printk("jiffies %lu pending %#x\n", jiffies, pending);

Before:

  bprint: __do_softirq: jiffies 4294919108 pending x
  ...
  bprint: [FAILED TO PARSE] ip=... fmt=... buf=ARRAY[]

After:

  bprint: __do_softirq: jiffies 4294919108 pending 0x4
  ...
  bprint: __do_softirq: jiffies 4294919109 pending 0x4

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 lib/traceevent/event-parse.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 06fa3dd..a62d2f7 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -4456,6 +4456,8 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 				goto process_again;
 			case '.':
 				goto process_again;
+			case '#':
+				goto process_again;
 			case 'z':
 			case 'Z':
 				ls = 1;
-- 
2.28.0

