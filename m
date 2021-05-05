Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5A6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C9B4611EE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhEENns (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 09:43:48 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:58274 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230172AbhEENns (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 09:43:48 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 5 May 2021 06:42:49 -0700
Received: from vypre.com (unknown [10.21.244.11])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 3D70920426;
        Wed,  5 May 2021 06:42:51 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Add API for enabling and disabling events
Date:   Wed, 5 May 2021 09:42:46 -0400
Message-ID: <20210505134248.3583391-1-rostedt@goodmis.org>
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

When writing code with libtracefs, I found that it would be very
convenient to have an easy way to enable and disable events.

This patch set adds:

  tracefs_event_enable()
  tracefs_event_disable()

to allow users to easily enable and disable events in their code.

Steven Rostedt (VMware) (2):
  libtracefs: Add tracefs_event_enable/disable() API
  libtracefs: Update the man page for tracefs_event_enable/disable()
    APIs

 Documentation/libtracefs-events.txt |  36 +++++++
 include/tracefs.h                   |   3 +
 src/tracefs-events.c                | 145 ++++++++++++++++++++++++++++
 3 files changed, 184 insertions(+)

-- 
2.29.2

