Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BC1C4345D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E30E207DD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 01:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbgGVBSn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731649AbgGVBRz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 21:17:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6FBF22D2C;
        Wed, 22 Jul 2020 01:17:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jy3OM-005sF4-MT; Tue, 21 Jul 2020 21:17:54 -0400
Message-ID: <20200722011754.570002872@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 21 Jul 2020 21:16:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 15/23 v3] tools lib traceevent: Fix reporting of unknown SVM exit reasons
References: <20200722011628.925541477@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

On AMD, exist code -1 is also a possible value, but we use it for
terminating the list of known exit reasons. This leads to EXIT_ERR
being reported for unkown ones. Fix this by using an NULL string
pointer as terminal.

Link: http://lkml.kernel.org/r/5741D817.3070902@web.de
Link: http://lore.kernel.org/linux-trace-devel/20200702174950.123454-7-tz.stoyanov@gmail.com

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Ported from trace-cmd.git ]
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/plugins/plugin_kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/plugins/plugin_kvm.c b/tools/lib/traceevent/plugins/plugin_kvm.c
index de76a1e79d9e..51ceeb9147eb 100644
--- a/tools/lib/traceevent/plugins/plugin_kvm.c
+++ b/tools/lib/traceevent/plugins/plugin_kvm.c
@@ -245,7 +245,7 @@ static const char *find_exit_reason(unsigned isa, int val)
 		}
 	if (!strings)
 		return "UNKNOWN-ISA";
-	for (i = 0; strings[i].val >= 0; i++)
+	for (i = 0; strings[i].str; i++)
 		if (strings[i].val == val)
 			break;
 
-- 
2.26.2


