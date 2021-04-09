Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77283C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F5E26101D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhDISXb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:23:31 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:52327 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233332AbhDISXb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:23:31 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 11:23:11 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 6A3FB2104E;
        Fri,  9 Apr 2021 11:23:15 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Yordan Karadzhov <y.karadz@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Update option documentation and return pointer
Date:   Fri, 9 Apr 2021 14:23:09 -0400
Message-ID: <20210409182311.2239371-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

This is on top of this series:
  https://lore.kernel.org/linux-trace-devel/20210408140024.13093-1-y.karadz@gmail.com/

Have the trace_options_get_*() functions return a constant pointer as
the bitmask returned points to an internal structure, and should not be
freed or modified by the caller.

Fix the option documentation about how options are related between the
top instance and the created instance.

Move the tracefs_option_mask_is_set() documentation to the other
tarce_option_*() man page and remove the old documentation file.

Steven Rostedt (VMware) (2):
  libtracefs: Have the option mask function return a const pointer
  libtracefs: Document tracefs_option_mask_is_set() with the other
    option functions

 Documentation/libtracefs-option-bits.txt | 90 ------------------------
 Documentation/libtracefs-option-get.txt  | 29 +++++---
 include/tracefs.h                        |  4 +-
 src/tracefs-tools.c                      | 10 +--
 4 files changed, 29 insertions(+), 104 deletions(-)
 delete mode 100644 Documentation/libtracefs-option-bits.txt

-- 
2.29.2
