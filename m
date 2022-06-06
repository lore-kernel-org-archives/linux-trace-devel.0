Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC110CCA483
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jun 2022 19:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiFFTaI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiFFT36 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 15:29:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF37160FA
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DFA6B81AE2
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 19:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A59C3411E;
        Mon,  6 Jun 2022 19:29:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nyIQE-001Oys-50;
        Mon, 06 Jun 2022 15:29:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Harald Seiler <hws@denx.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/6] libtracefs: Add libtracefs.a to dependency of sqlhist
Date:   Mon,  6 Jun 2022 15:29:49 -0400
Message-Id: <20220606192953.334315-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220606192953.334315-1-rostedt@goodmis.org>
References: <20220606192953.334315-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As sqlhist is statically linked to the libtracefs.a file, it should be
rebuilt if the libtracefs.a is updated. Because sqlhist.c is extracted
from the man pages, it does not get the automatic dependency updates like
the rest of the source tree has.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/Makefile b/samples/Makefile
index c1392fbbb12b..6628679e6227 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -46,7 +46,7 @@ sqlhist: $(sdir)/sqlhist
 $(TARGETS): $(sdir)
 
 # sqlhist is unique and stands on its own
-$(sdir)/sqlhist: $(bdir)/sqlhist.c
+$(sdir)/sqlhist: $(bdir)/sqlhist.c $(LIBTRACEFS_STATIC)
 	$(call do_sample_build,$@,$<)
 
 $(sdir)/%: $(bdir)/%.o
-- 
2.35.1

