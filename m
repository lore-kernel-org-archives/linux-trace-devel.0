Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF37C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3188961990
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhC3AbJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhC3Aat (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:30:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 110B561935
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Mar 2021 00:30:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2HP-003TLU-Rn
        for linux-trace-devel@vger.kernel.org; Mon, 29 Mar 2021 20:30:47 -0400
Message-ID: <20210330003026.434340915@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:30:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] libtracefs: Some clean ups
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



Steven Rostedt (VMware) (2):
      libtracefs: Fix dependencies in Documentation Makefile
      libtracefs: Add .gitignore files

----
 .gitignore               | 10 ++++++++++
 Documentation/.gitignore |  4 ++++
 Documentation/Makefile   | 24 +++++++++++++++---------
 3 files changed, 29 insertions(+), 9 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 Documentation/.gitignore
