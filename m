Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A14FC48BC2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3456197B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhFYUcl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 16:32:41 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:55896 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhFYUcl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 16:32:41 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 13:15:09 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id E71C320318;
        Fri, 25 Jun 2021 13:15:12 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] trace-cmd: Update verbose logic
Date:   Fri, 25 Jun 2021 16:15:08 -0400
Message-ID: <20210625201511.1206465-1-rostedt@goodmis.org>
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


- Have verbose not require an argument

- Make -V similar to --verbose (but only for numbers)

- Do not force a limit to the verbosity numbers

Steven Rostedt (VMware) (3):
  trace-cmd: Do not require --verbose to have an argument
  trace-cmd report: Have -V take an optional argument
  trace-cmd: Do not enforce upper limit of verbose id

 .../trace-cmd/trace-cmd-check-events.1.txt         |  5 +++--
 Documentation/trace-cmd/trace-cmd-dump.1.txt       |  5 +++--
 Documentation/trace-cmd/trace-cmd-extract.1.txt    |  5 +++--
 Documentation/trace-cmd/trace-cmd-listen.1.txt     |  5 +++--
 Documentation/trace-cmd/trace-cmd-profile.1.txt    |  5 +++--
 Documentation/trace-cmd/trace-cmd-record.1.txt     |  5 +++--
 Documentation/trace-cmd/trace-cmd-report.1.txt     |  9 +++++----
 Documentation/trace-cmd/trace-cmd-set.1.txt        |  5 +++--
 Documentation/trace-cmd/trace-cmd-stack.1.txt      |  5 +++--
 tracecmd/trace-agent.c                             |  2 +-
 tracecmd/trace-check-events.c                      |  2 +-
 tracecmd/trace-cmd.c                               |  7 +++++--
 tracecmd/trace-dump.c                              |  2 +-
 tracecmd/trace-listen.c                            |  2 +-
 tracecmd/trace-read.c                              | 10 ++++------
 tracecmd/trace-record.c                            |  2 +-
 tracecmd/trace-stack.c                             |  2 +-
 tracecmd/trace-usage.c                             | 14 +++++++++++---
 18 files changed, 55 insertions(+), 37 deletions(-)

-- 
2.30.2

