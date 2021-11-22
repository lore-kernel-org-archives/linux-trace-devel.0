Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2725BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhKVXxM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:12 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7560 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231940AbhKVXxL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:11 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:01 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 5692120367;
        Mon, 22 Nov 2021 15:50:03 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 00/11] libtracefs: Have all man page examples be executable
Date:   Mon, 22 Nov 2021 18:49:45 -0500
Message-ID: <20211122234956.788401-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Fix the man pages, and add a "make samples" that extracts the man page
examples to create executables from.

Note, several man pages do not have a proper example, and those will
need to be updated to have one.

Steven Rostedt (VMware) (11):
  libtracefs: Move creation of sqlhist into new samples directory
  libtracefs: Fix example in the dynamic events man page to compile
  libtracefs/Documentation: Fix man page examples to include the proper
    header
  tracefs/Documentation: Fix example in libtracefs-eprobes.txt to
    compile
  libtracefs: Make samples easily extract man page example programs
  libtracefs: Add new API tracefs_dynevent_get()
  libtracefs/Documentation: Fix example in libtracefs-error.txt
  libtracefs/Documentation: Fix function-filter call to
    tracefs_list_free()
  libtracefs/Documentation: Update libtracefs-hist-cont.txt to new API
  libtracefs: Add all working man page examples to samples
  libtracefs/Documentation: Update stream example to have a parameter

 Documentation/libtracefs-dynevents.txt       | 14 +++-
 Documentation/libtracefs-eprobes.txt         |  6 +-
 Documentation/libtracefs-error.txt           |  9 ++-
 Documentation/libtracefs-function-filter.txt |  2 +-
 Documentation/libtracefs-hist-cont.txt       | 29 +++++---
 Documentation/libtracefs-hist.txt            |  2 +-
 Documentation/libtracefs-kprobes.txt         |  2 +-
 Documentation/libtracefs-stream.txt          | 18 ++++-
 Makefile                                     | 14 ++--
 include/tracefs.h                            |  2 +
 samples/Makefile                             | 69 ++++++++++++++++++++
 src/tracefs-dynevents.c                      | 45 +++++++++++++
 12 files changed, 181 insertions(+), 31 deletions(-)
 create mode 100644 samples/Makefile

-- 
2.31.1

