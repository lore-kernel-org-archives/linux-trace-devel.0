Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5114BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B565613B0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245341AbhDPVaq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:30:46 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:57465 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235451AbhDPVaq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 17:30:46 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 14:30:15 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id E93AB20884;
        Fri, 16 Apr 2021 14:30:19 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd list: Include ftrace in event listings
Date:   Fri, 16 Apr 2021 17:30:16 -0400
Message-ID: <20210416213018.3890036-1-rostedt@goodmis.org>
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

I'm constantly needing to look at the event formats of ftrace events
(like the function event or print event), but trace-cmd list does not
include them, as they can not be enabled by trace-cmd record/start.

By default, trace-cmd list -e, wont show ftrace events, but if a regex
is added to the search: trace-cmd list -e print, then it will now list
those events in ftrace. This is useful for:

 # trace-cmd list -e ftrace:function -F
system: ftrace
name: function
ID: 1
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:unsigned long ip; offset:8;       size:8; signed:0;
        field:unsigned long parent_ip;  offset:16;      size:8; signed:0;

Steven Rostedt (VMware) (2):
  trace-cmd list: Use tracefs to help find events for -e
  trace-cmd list: Add ftrace events to listing of events

 lib/trace-cmd/trace-input.c |   6 +-
 tracecmd/trace-list.c       | 150 ++++++++++++++++++++++++++++++++++--
 2 files changed, 149 insertions(+), 7 deletions(-)

-- 
2.29.2

