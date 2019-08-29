Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C1BC3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9131F23431
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567089705;
	bh=3CEr8NSW0IQIeMf/NA6iIqMWBs+yJrZLrDg3IqafYE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YmwBmoR97sBwTRCcyg0PegGimoLlJiP4XmYS4jEFLbPHHc5pfeTbqai6R8hBzOtBG
	 +L+3Xgb0C1QYWQQIV5EbryQmHO770jDSSLjnHlT4lDt1tULiF9tMKVIarYqxch4J6P
	 VuFN+DypuCT5uktVeP08TNECdKn4pNfcnsWMfWeU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfH2Olf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 10:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbfH2Ole (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 10:41:34 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A695F23430;
        Thu, 29 Aug 2019 14:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567089693;
        bh=3CEr8NSW0IQIeMf/NA6iIqMWBs+yJrZLrDg3IqafYE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5p+abkLS8ALuiMoSSTbT1eV0EzAcjBDErx4f2yhHq8TlpSgv2qhPbrhocabp2Vvh
         RHxrRNvkA7jCozZ6DiYCGOjEiwldWF0SxQmGPs18x2EnBc5OoCkh0cA+sdRGld18Qk
         icEuIIvCCCuvtVtv3V2gAzMnfMWYZxkH/IncerXM=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/37] tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure
Date:   Thu, 29 Aug 2019 11:39:16 -0300
Message-Id: <20190829143917.29745-37-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829143917.29745-1-acme@kernel.org>
References: <20190829143917.29745-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the re-allocation of tep->cmdlines succeeds, then the previous
allocation of tep->cmdlines will be freed. If we later fail in
add_new_comm(), we must not free cmdlines, and also should assign
tep->cmdlines to the new allocation. Otherwise when freeing tep, the
tep->cmdlines will be pointing to garbage.

Fixes: a6d2a61ac653a ("tools lib traceevent: Remove some die() calls")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20190828191819.970121417@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b36b536a9fcb..13fd9fdf91e0 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -269,10 +269,10 @@ static int add_new_comm(struct tep_handle *tep,
 		errno = ENOMEM;
 		return -1;
 	}
+	tep->cmdlines = cmdlines;
 
 	cmdlines[tep->cmdline_count].comm = strdup(comm);
 	if (!cmdlines[tep->cmdline_count].comm) {
-		free(cmdlines);
 		errno = ENOMEM;
 		return -1;
 	}
@@ -283,7 +283,6 @@ static int add_new_comm(struct tep_handle *tep,
 		tep->cmdline_count++;
 
 	qsort(cmdlines, tep->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-	tep->cmdlines = cmdlines;
 
 	return 0;
 }
-- 
2.21.0

