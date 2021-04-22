Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09552C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF237613E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhDVVSn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:18:43 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:51679 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236877AbhDVVSm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 17:18:42 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 22 Apr 2021 14:18:03 -0700
Received: from vypre.com (unknown [10.21.244.251])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 84310203F0;
        Thu, 22 Apr 2021 14:18:06 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Nicolas Sterchele <nicolas@sterchelen.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/3] trace-cmd: Add more ways to view options
Date:   Thu, 22 Apr 2021 17:18:00 -0400
Message-ID: <20210422211803.862397-1-rostedt@goodmis.org>
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

When testing the func-norepeats patch series from Yordan, I wanted a way
to see what options were enabled for all tracers without having to
enable a tracer first.

Change trace-cmd list to look at the options in the options directory
instead of the trace_options file, as the trace_options file only shows
the options for the current tracer and global options. The options
directory shows all options since Linux 4.4.

Add -o to stat to display the options, as stat lets you see instances
where as list does not.

Changes since v1:

 - Included the --full patch, to remove flags from a die() call.
 - Removed extra changes that did not belong to this patch series.
 - Rebased on top of the --full patch.

Steven Rostedt (VMware) (3):
  trace-cmd list: Add --full to show print fmt of an event
  trace-cmd list: Use tracefs to help find events for -e
  trace-cmd list: Add ftrace events to listing of events

 Documentation/trace-cmd/trace-cmd-list.1.txt |   5 +-
 tracecmd/trace-list.c                        | 179 +++++++++++++++++--
 tracecmd/trace-usage.c                       |   1 +
 3 files changed, 168 insertions(+), 17 deletions(-)

-- 
2.29.2

