Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3472CC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F9423124
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgLPEh6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgLPEh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:37:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 048D923124
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:37:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOYu-000qfR-Oy
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:37:16 -0500
Message-ID: <20201216043637.453360298@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:36:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] libtraceevent: Add uninstall and fix build dependency of libtraceevent.pc
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven Rostedt (VMware) (3):
      libtraceevent: Add a way to uninstall
      libtraceevent: Update libtraceevent.pc if prefix is different
      libtraceevent: Keep build_install file around

----
 Makefile                 | 42 +++++++++++++++++++++++++++++++++++++++++-
 scripts/Makefile.include |  2 ++
 2 files changed, 43 insertions(+), 1 deletion(-)
