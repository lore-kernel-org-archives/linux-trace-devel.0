Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62D5C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF02661222
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhDPRYA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:24:00 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:55932 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233606AbhDPRX7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 13:23:59 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 10:23:30 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id DD07A20454;
        Fri, 16 Apr 2021 10:23:33 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd: Add more ways to view options
Date:   Fri, 16 Apr 2021 13:23:28 -0400
Message-ID: <20210416172331.3870833-1-rostedt@goodmis.org>
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

When testing the func-norepeats patch series from Yordan, I wanted a way
to see what options were enabled for all tracers without having to
enable a tracer first.

Change trace-cmd list to look at the options in the options directory
instead of the trace_options file, as the trace_options file only shows
the options for the current tracer and global options. The options
directory shows all options since Linux 4.4.

Add -o to stat to display the options, as stat lets you see instances
where as list does not.

Steven Rostedt (VMware) (3):
  trace-cmd list: Have -o read the options directory instead of file
  trace-cmd stat: Update the usage and man pages
  trace-cmd stat: Add -o option to show options

 Documentation/trace-cmd/trace-cmd-stat.1.txt | 16 +++++-
 tracecmd/include/trace-local.h               |  1 +
 tracecmd/trace-list.c                        | 58 ++++++++++++++++++--
 tracecmd/trace-stat.c                        | 14 ++++-
 tracecmd/trace-usage.c                       |  5 +-
 5 files changed, 84 insertions(+), 10 deletions(-)

-- 
2.29.2

