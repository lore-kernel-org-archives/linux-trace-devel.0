Return-Path: <SRS0=o8EP=YD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB983C4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 08:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC1420679
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 08:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570697610;
	bh=dIkt0vLKrtVJ+hQhnXmuOhdKk9aVdewU/JuwAz9hb5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SU6TcDrMPN4MNI+YQRBQznGeZQNyq2H+UbIwJwUb7fD7x4vV5QZDRBOhpo9pRRy3X
	 7fHbQRwbFatWvhMmM26MHrSEWPLoigoTis6MuLsY1VUCdwjQBz9S7k0GKpfBsnTrHT
	 a6gLQ8hc/2Z7GIwFjFz/9ZyfXevh964z9MRw4j+o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbfJJIxZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 04:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390138AbfJJIvl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 04:51:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A813B20679;
        Thu, 10 Oct 2019 08:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697501;
        bh=dIkt0vLKrtVJ+hQhnXmuOhdKk9aVdewU/JuwAz9hb5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxZ97PO9WdxEFaQdvNHUC/SKZORdmM2TcXBaYAAFSKRhNKBlocQDN7vHePaWfgF5h
         lJGalMgdVFD4VInWEo5XMc4x4tFli2l0hQfue7F/Q+lOWYLDfae+A0Zm9Mwp9lT4rQ
         /lwmJ/S9Y3s4PBrGydFaOoHxDDxSMwdGgYQ2qy3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 50/61] tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure
Date:   Thu, 10 Oct 2019 10:37:15 +0200
Message-Id: <20191010083521.214463081@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit e0d2615856b2046c2e8d5bfd6933f37f69703b0b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 7989dd6289e7a..8211e8010e09b 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -268,10 +268,10 @@ static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
 		errno = ENOMEM;
 		return -1;
 	}
+	pevent->cmdlines = cmdlines;
 
 	cmdlines[pevent->cmdline_count].comm = strdup(comm);
 	if (!cmdlines[pevent->cmdline_count].comm) {
-		free(cmdlines);
 		errno = ENOMEM;
 		return -1;
 	}
@@ -282,7 +282,6 @@ static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
 		pevent->cmdline_count++;
 
 	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-	pevent->cmdlines = cmdlines;
 
 	return 0;
 }
-- 
2.20.1



