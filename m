Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965A3C0018C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC59235F9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgLPUMP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727414AbgLPUMP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:12:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 104CB235F9
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:11:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpd93-000vt0-T1
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:11:33 -0500
Message-ID: <20201216201106.170659791@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:11:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/8] libtracefs: More Makefile updates to make packaging the library easier
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Steven Rostedt (VMware) (8):
      libtracefs: Clean up tracefs.h
      libtracefs: Use $(objtree) instead of $(OUTPUT) for ld.so test
      libtracefs: Do not hardcode location of libtraceevent
      libtracefs: Use $(obj) instead of $(OUTPUT) for libtracefs.pc file
      libtracefs: Allow the pkg-config libs and cflags prefix to be overwritten
      libtracefs: Remove unneccessary TRACE_LIBS variable
      libtracefs: Have only one definition of overriding CFLAGS
      libtracefs: Add -rpath to libtracefs.so

----
 Makefile               | 30 +++++++++++++-----------------
 include/tracefs.h      |  4 ++--
 libtracefs.pc.template |  4 ++--
 scripts/utils.mk       |  2 +-
 4 files changed, 18 insertions(+), 22 deletions(-)
