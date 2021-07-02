Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D9DC07E9D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F35961422
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhGBUUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhGBUUD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 16:20:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6E4561423;
        Fri,  2 Jul 2021 20:17:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzPbN-000i0I-Me; Fri, 02 Jul 2021 16:17:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v7 00/10] libtracefs: Facilitate adding and removing kprobes
Date:   Fri,  2 Jul 2021 16:17:17 -0400
Message-Id: <20210702201727.169080-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add a tracefs_kprobe_raw() to facilitate adding kprobe events. It's
denoted as "raw" because it still requires knowing the complex format of
a kprobe, but at least it helps with other formats:

 p:[[system/]event] addr fmt

The user only needs to know the "fmt" part above, and not worry about
what file to open, or how to open it.

Also add a tracefs_kprobe_clear() to clear all kprobes and a
tracefs_kprobe_clear_probe() to clear an individual kprobe. Both have a
"force" parameter, that if set, will then try to disable the kprobe in
all instances (including the top) and then remove the kprobe(s).

Changes since v6: https://lore.kernel.org/linux-trace-devel/20210702185616.167778-1-rostedt@goodmis.org/

 - Fixed some utest cases that used strcmp() when it should have used
   !strcmp().

This should be the last version before I push (I hope!)

Steven Rostedt (VMware) (10):
  libtracefs: Implement tracefs_instances()
  libtracefs: Implement tracefs_kprobe_raw()
  libtracefs: Implement tracefs_kretprobe_raw()
  libtracefs: Implement tracefs_get_kprobes()
  libtracefs: Add helper function to parse kprobes
  libtracefs: Implement tracefs_kprobe_info()
  libtracefs: Implement tracefs_kprobe_clear_all() to remove all kprobes
  libtracefs: Implement tracefs_kprobe_clear_probe()
  libtracefs: Add man pages for kprobe functions
  libtracefs: Update the unit tests to use the kprobe API instead

 Documentation/libtracefs-kprobes.txt | 297 ++++++++++++++++
 include/tracefs.h                    |  17 +
 src/Makefile                         |   1 +
 src/tracefs-instance.c               |  76 +++++
 src/tracefs-kprobes.c                | 485 +++++++++++++++++++++++++++
 utest/tracefs-utest.c                | 195 +++++++++--
 6 files changed, 1042 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/libtracefs-kprobes.txt
 create mode 100644 src/tracefs-kprobes.c

-- 
2.30.2

