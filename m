Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5580C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Dec 2022 19:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiLOTCP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 14:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiLOTCK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 14:02:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437D415831
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 11:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3CA2B81C4D
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Dec 2022 19:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4758AC433EF;
        Thu, 15 Dec 2022 19:02:06 +0000 (UTC)
Date:   Thu, 15 Dec 2022 14:02:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v1 1/2] libtracefs: Move initialization below a null
 test.
Message-ID: <20221215140203.103faf50@gandalf.local.home>
In-Reply-To: <20221215183151.2685460-1-irogers@google.com>
References: <20221215183151.2685460-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 15 Dec 2022 10:31:50 -0800
Ian Rogers <irogers@google.com> wrote:

> Computing the address from a NULL pointer results in undefined behavior
> which things like undefined behavior sanitizer promote into real
> failures.

I thought commit aff006d4af0c7 ("libtracefs: Do not initialize with NULL
offsets") was suppose to fix this.

Oh, I think I may have forgotten to remove the check against dynevent!

Does this work instead?

-- Steve

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 48bb26a96c58..7a3c45ce25a3 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -713,9 +713,6 @@ dynevent_info(struct tracefs_dynevent *dynevent, char **system,
 			&dynevent->address, &dynevent->format };
 	int i;
 
-	if (!dynevent)
-		return TRACEFS_DYNEVENT_UNKNOWN;
-
 	for (i = 0; i < ARRAY_SIZE(lv); i++) {
 		if (lv[i]) {
 			if (*rv[i]) {
