Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9927C432BE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC895611AD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbhHTXv3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 19:51:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51052 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbhHTXv3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 19:51:29 -0400
Received: from usagi.middle.earth (ethbase.usagi.not.afront.org [IPv6:2620:137:e001:0:1897:4108:901b:c660])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AA5754D0F1497;
        Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
Received: from usagi.middle.earth (localhost [IPv6:::1])
        by usagi.middle.earth (Postfix) with ESMTP id 4AB7229B3021;
        Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
From:   "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [Patch v2] Fixing build issues found while working on packaging
Date:   Fri, 20 Aug 2021 16:50:41 -0700
Message-Id: <20210820235043.1450620-1-warthog9@eaglescrag.net>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two issues that came up during packaging of HEAD:
1) sqlhist needs a more explicit dependency on the bison parts
   pre-existing.  This will likely be less of an issue later when
   those don't need to be generated on every build.  For now, a 
   more explicit dependency (in the right place in the make file now in
   v2) resolves this SMP build issue

2) libtracefs.a generation does and `rm -f` and then genrates the
   archive.  Something about that will sporadically cause ar to get
   confused and throw an error about reading files.  Making the rm more
   atomic (mv an then rm) either adds enough of a delay to mask the
   problem, or clears this up correctly.

This clears up the major SMP build issues I'm seeing at least.

- John 'Warthog9' Hawley (VMware)


