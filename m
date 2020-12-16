Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0682C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5723E23719
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbgLPXW0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgLPXW0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 18:22:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27B95238E5;
        Wed, 16 Dec 2020 23:21:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpg76-000xFo-V9; Wed, 16 Dec 2020 18:21:44 -0500
Message-ID: <20201216231942.127326802@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 18:19:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/6 v2] trace-cmd/kernelshark: Fixed build, cleanups and fix kernelshark
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sent out a v1, but the change log of patch 2 had issues that quilt 
could not deal with, and was rejected. The v1 had just the first
three patches. This series has more to handle KernelShark v1 building.

Steven Rostedt (VMware) (5):
      trace-cmd: Move add_event_pid() out of #ifndef NO_PTRACE
      trace-cmd: Add #include <fcntl.h> to trace-cmd-private.h
      trace-cmd: Add a make-trace-cmd.sh script to simplify creating a trace-cmd package
      trace-cmd: Do not have local builds of libtraceevent or libtracefs use system headers
      kernelshark: Build libtraceevent and libtracefs locally

Yordan Karadzhov (VMware) (1):
      trace-cmd: Re-enable the build of KernelShark v1

----
 Makefile                                          | 24 ++++++++++++------
 PACKAGING                                         | 30 ++++++++++++++++++++++
 kernel-shark/CMakeLists.txt                       |  1 +
 kernel-shark/build/FindTraceCmd.cmake             | 29 +++++----------------
 kernel-shark/src/libkshark.c                      | 14 ++++++----
 kernel-shark/src/libkshark.h                      |  2 +-
 lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
 lib/traceevent/Makefile                           |  6 +++++
 lib/tracefs/Makefile                              |  8 ++++++
 make-trace-cmd.sh                                 | 31 +++++++++++++++++++++++
 tracecmd/trace-record.c                           | 12 ++++-----
 11 files changed, 115 insertions(+), 43 deletions(-)
 create mode 100644 PACKAGING
 create mode 100755 make-trace-cmd.sh
