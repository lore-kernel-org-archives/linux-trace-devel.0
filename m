Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12629C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D31472360D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgLPUUo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbgLPUUo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:20:44 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12E0823609
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:20:04 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpdHG-000w4p-Sh
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:20:02 -0500
Message-ID: <20201216201938.008772358@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:19:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: Add -rpath to trace-cmd and libtracecmd.so
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Steven Rostedt (VMware) (2):
      libtracecmd: Add -rpath to libtracecmd.so
      trace-cmd: Add -rpath=$(libdir) for trace-cmd to find libtracecmd.so

----
 scripts/utils.mk | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
