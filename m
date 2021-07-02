Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970D4C11F6A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89CC261425
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhGBD5T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 23:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234968AbhGBD5R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 23:57:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E0A461416;
        Fri,  2 Jul 2021 03:54:46 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzAGL-000eH6-5p; Thu, 01 Jul 2021 23:54:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v4 0/7] libtracefs: Facilitate adding and removing kprobes
Date:   Thu,  1 Jul 2021 23:54:36 -0400
Message-Id: <20210702035443.154729-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

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

Changes since v3: https://lore.kernel.org/linux-trace-devel/20210702031022.154146-1-rostedt@goodmis.org/

 - Silly me used "stat(KPROBE_EVENTS)" to see if the kprobe event
   file existed, but KPROBE_EVENTS is not a full path. Should have
   used tracefs_file_exists() since that's what it's made for.
   My testing missed this, because I forgot to push the changes to
   my test machine, and I tested the code with old logic.

Steven Rostedt (VMware) (7):
  libtracefs: Implement tracefs_instances()
  libtracefs: Implement tracefs_kprobe_raw()
  libtracefs: Implement tracefs_kretprobe_raw()
  libtracefs: Implement tracefs_get_kprobes()
  libtracefs: Implement tracefs_kprobe_clear_all() to remove all kprobes
  libtracefs: Implement tracefs_kprobe_clear_probe()
  libtracefs: Add man pages for kprobe functions

 Documentation/libtracefs-kprobes.txt | 275 +++++++++++++++++++++
 include/tracefs.h                    |   9 +
 src/Makefile                         |   1 +
 src/tracefs-instance.c               |  78 ++++++
 src/tracefs-kprobes.c                | 349 +++++++++++++++++++++++++++
 5 files changed, 712 insertions(+)
 create mode 100644 Documentation/libtracefs-kprobes.txt
 create mode 100644 src/tracefs-kprobes.c

-- 
2.30.2

