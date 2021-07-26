Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B3CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E108660F5E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbhGZPsh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 11:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238502AbhGZPsb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 11:48:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09D5560F4F;
        Mon, 26 Jul 2021 16:29:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m83TO-0022kw-J1; Mon, 26 Jul 2021 12:28:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] trace-cmd: Clean up library and KernelShark remnants
Date:   Mon, 26 Jul 2021 12:28:54 -0400
Message-Id: <20210726162857.487153-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Remove leftover remnants of building KernelShark, libtraceevent and
libtracefs from the trace-cmd Makefiles.

Steven Rostedt (VMware) (3):
  trace-cmd: Remove traceevent/ and tracefs/ from include headers
  trace-cmd: Remove leftover traces of libtraceevent in Makefiles
  trace-cmd: Remove remnants of KernelShark build

 .gitignore                                    |  1 -
 Makefile                                      | 39 ++-----------------
 include/trace-cmd/trace-cmd.h                 |  4 +-
 .../include/private/trace-cmd-private.h       |  2 +-
 lib/trace-cmd/trace-util.c                    |  4 +-
 python/Makefile                               |  2 +-
 6 files changed, 9 insertions(+), 43 deletions(-)

-- 
2.30.2

