Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48C4C11F6A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D143261D78
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhF2U4L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235605AbhF2U4J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 16:56:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE991613BE;
        Tue, 29 Jun 2021 20:53:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lyKjj-000UT5-So; Tue, 29 Jun 2021 16:53:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Facilitate adding and removing kprobes
Date:   Tue, 29 Jun 2021 16:53:23 -0400
Message-Id: <20210629205326.117059-1-rostedt@goodmis.org>
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

(Man pages coming after this).

Steven Rostedt (VMware) (3):
  libtracefs: Implement tracefs_kprobe_raw()
  libtracefs: Implement tracefs_kprobe_clear() to remove all kprobes
  libtracefs: Implement tracefs_kprobe_clear_probe()

 include/tracefs.h     |   5 +
 src/Makefile          |   1 +
 src/tracefs-kprobes.c | 242 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 248 insertions(+)
 create mode 100644 src/tracefs-kprobes.c

-- 
2.30.2

