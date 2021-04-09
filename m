Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D3EC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C58D5610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhDIPQW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:16:22 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:36110 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234032AbhDIPQV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 11:16:21 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 08:16:02 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 879A520D41;
        Fri,  9 Apr 2021 08:16:06 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Updates to trace_marker functions
Date:   Fri, 9 Apr 2021 11:16:01 -0400
Message-ID: <20210409151604.2224578-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[
  This is on top of:
  https://lore.kernel.org/linux-trace-devel/20210409042739.3179257-1-tz.stoyanov@gmail.com/
]

This is some updates to the tracefs_print*() and tracefs_binary*()
functions. The first patch does some clean ups, the second adds a helper
function to find the right pthread mutex to use, and the last patch adds
a pthread mutex around the modifications of the file descriptors used
for writing to the file.

Note, the lock only protects against the modification of the file
descriptor (opening and closing it). It does not protect against writing
to it (a write updates the file the file descriptor points to, but the
value of the file descriptor - the number - is left unchanged).

It is now safe to use tracefs_v?print() and tracefs_binary_write() along
with tracefs_print_init() and tracefs_binary_init(), where it will
open the file descriptor if it is not open yet, and return it if it is
already opened.

The writes are not safe to use against tracefs_print_close() or
tracefs_binary_close(), and that is up to the application to protect.


Steven Rostedt (VMware) (3):
  libtracefs: Do some cleanups to the trace_marker.c code
  libtracefs: Add helper function trace_get_lock()
  libtracefs: Add lock around modifying the trace_marker file descriptor

 include/tracefs-local.h |  5 +++++
 src/tracefs-marker.c    | 44 +++++++++++++++++++++++++++++++----------
 src/tracefs-tools.c     |  2 +-
 3 files changed, 40 insertions(+), 11 deletions(-)

-- 
2.29.2

