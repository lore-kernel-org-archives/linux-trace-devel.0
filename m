Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9B8C7618F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 19:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70BC421743
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 19:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfGQT1q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 15:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbfGQT1q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 15:27:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79D9021743;
        Wed, 17 Jul 2019 19:27:45 +0000 (UTC)
Date:   Wed, 17 Jul 2019 15:27:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel-shark: Initialize the data-related fields of
 the model
Message-ID: <20190717152744.50b450cf@gandalf.local.home>
In-Reply-To: <20190717152646.0798bdc7@gandalf.local.home>
References: <20190717085306.12393-1-y.karadz@gmail.com>
        <20190717085306.12393-2-y.karadz@gmail.com>
        <20190717083709.4a56867c@gandalf.local.home>
        <3117115a-5468-1b26-9a89-d871f43a1289@gmail.com>
        <20190717092818.34329697@gandalf.local.home>
        <00e8b2e5-2112-0681-7cbb-a3919ddd63c8@gmail.com>
        <20190717152646.0798bdc7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


And here's the version that claws-mail didn't line wrap :-p

-- Steve

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH] kernel-shark: Initialize all fields of struct kshark_trace_histo

The function ksmodel_init() is to initialize the kshark_trace_histo
structure to zero. Currently it does it via each field. It is safer to use
memset() that will guarantee that the entire structure is set to zeros or
NULLs if new fields are added. This is required because there's places in
the code that check if a field is NULL or zero to determine if it should be
set or not.

Link: http://lkml.kernel.org/r/20190717085306.12393-2-y.karadz@gmail.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204195

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/libkshark-model.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 18f9c691..6c54e1e1 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -36,13 +36,7 @@ void ksmodel_init(struct kshark_trace_histo *histo)
 	 * Initialize an empty histo. The histo will have no bins and will
 	 * contain no data.
 	 */
-	histo->bin_size = 0;
-	histo->min = 0;
-	histo->max = 0;
-	histo->n_bins = 0;
-
-	histo->bin_count = NULL;
-	histo->map = NULL;
+	memset(histo, 0, sizeof(*histo));
 }
 
 /**
-- 
2.20.1

