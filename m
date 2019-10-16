Return-Path: <SRS0=FY51=YJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78446FA372B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Oct 2019 22:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E18521848
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Oct 2019 22:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571264594;
	bh=qWfBUTlJZjz1IqhkpVnjzoy7Ub2LpDcTgsvcw0X1Oxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=r9OxuKlKO0PUosuYntk9X30j1hC3qhmecIuXcRY9eVbpFV82cc3UktVENCfYBq2Jb
	 W105Ih82Ehk4O2aSsulRCLDecfEQrPWQPv5lWCfVH8oMdVmvxYfJj7pEp5/9EhiJXm
	 7qvAuKfA36c8c0o1j/zkVWRSr6jlu8bB/TISCvrg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394795AbfJPVxC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 17:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437220AbfJPVxB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:01 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B5B3218DE;
        Wed, 16 Oct 2019 21:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262780;
        bh=qWfBUTlJZjz1IqhkpVnjzoy7Ub2LpDcTgsvcw0X1Oxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNaxBVNek4OCkRJ8HXN61x9axQn1KKiGI4gX2QNgp2ldiuV2J7lYoaupQutNOgE4p
         I+3ADeB4ZZ7fLZDRCNVskfRQAk/AQajmC9CCg45AsA09RuvmcSX78rt2ZUEaHPRWMd
         m8CtQuEXg6SIEczwAlEOykxcvbYy7Lf1pMypRJcg=
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
Subject: [PATCH 4.4 21/79] tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure
Date:   Wed, 16 Oct 2019 14:49:56 -0700
Message-Id: <20191016214750.099225959@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
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
index df3c73e9dea49..9954b069b3ca2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -265,10 +265,10 @@ static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
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
@@ -279,7 +279,6 @@ static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
 		pevent->cmdline_count++;
 
 	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-	pevent->cmdlines = cmdlines;
 
 	return 0;
 }
-- 
2.20.1



