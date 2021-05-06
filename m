Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ADAC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 16:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21E561090
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 May 2021 16:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbhEFQxH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 12:53:07 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:5919 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236101AbhEFQxG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 12:53:06 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 6 May 2021 09:52:03 -0700
Received: from vypre.com (unknown [10.21.244.124])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 167CE2028F;
        Thu,  6 May 2021 09:52:05 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/4] trace-cmd list: Include ftrace in event listings
Date:   Thu, 6 May 2021 12:51:59 -0400
Message-ID: <20210506165203.3889058-1-rostedt@goodmis.org>
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

Changes since v2:

 - Fixed cover letter subject and body, as v2 referenced listing of options?
   https://lore.kernel.org/linux-trace-devel/20210422211803.862397-1-rostedt@goodmis.org/

 - Broke up patch: https://lore.kernel.org/linux-trace-devel/20210422211803.862397-4-rostedt@goodmis.org/
   To separate out the adding of the helper function "match_system_events()"
   from the functional change of listing ftrace events.

 - The diff of this patch set compared to v2 is the same (no functional changes).


Steven Rostedt (VMware) (4):
  trace-cmd list: Add --full to show print fmt of an event
  trace-cmd list: Use tracefs to help find events for -e
  trace-cmd list: Add match_system_events() helper function
  trace-cmd list: Add ftrace events to listing of events

 Documentation/trace-cmd/trace-cmd-list.1.txt |   5 +-
 tracecmd/trace-list.c                        | 179 +++++++++++++++++--
 tracecmd/trace-usage.c                       |   1 +
 3 files changed, 168 insertions(+), 17 deletions(-)

-- 
2.29.2

