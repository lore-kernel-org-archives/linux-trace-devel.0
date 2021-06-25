Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AE6C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C264861952
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFYWUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:20:04 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:28181 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhFYWUE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 18:20:04 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 15:17:38 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id C5DD820327;
        Fri, 25 Jun 2021 15:17:41 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeross1994@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtracefs: Updates to tracefs_tracer_set()
Date:   Fri, 25 Jun 2021 18:17:35 -0400
Message-ID: <20210625221739.1215557-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Make tracefs_tracer_set() have an optional argument to allow for custom
tracers, for newer or custom kernels.

Update errno values.

Cleanups and documenation.

This is based on top of Sameer's patch:

  https://patchwork.kernel.org/project/linux-trace-devel/patch/1621351602-3703-1-git-send-email-sameeross1994@gmail.com/

Steven Rostedt (VMware) (4):
  libtracefs: Add custom tracer to tracefs_tracer_set()
  libtracefs: Fix the errno values of tracefs_tracer_set()
  libtracefs: Check tracer parameter first in tracefs_tracer_set()
  libtracefs: Add documentation for tracefs_tracer_set/clear()

 Documentation/libtracefs-tracer.txt | 221 ++++++++++++++++++++++++++++
 include/tracefs.h                   |   3 +-
 src/tracefs-tools.c                 |  46 ++++--
 3 files changed, 258 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/libtracefs-tracer.txt

-- 
2.30.2

