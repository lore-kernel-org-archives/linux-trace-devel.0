Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64213C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E5361181
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhDHVZQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:25:16 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:20422 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231862AbhDHVZP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:25:15 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 14:25:00 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 7AF84212B3;
        Thu,  8 Apr 2021 14:25:03 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/5] libtraceevent: Copy parsing functions from trace-cmd
Date:   Thu, 8 Apr 2021 17:24:55 -0400
Message-ID: <20210408212500.2058159-1-rostedt@goodmis.org>
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


Currently, trace-cmd does the work of parsing kallsyms, saved_cmdlines,
and printk_formats and feeding it to the libtraceevent tep handle. When
starting to write code snippets that work directly with libtracefs and
libtraceevent, I found that I need this functionality as well. But this
code doesn't need libtracecmd. As these files exist in /proc and in the
tracefs directly, just like we have events and headers that get parsed
by libtraceevent, add this functionality directly to libtraceevent, as
libtraceevent is made to parse files for processing of events, and all
of the above do exactly that.

Changes since version 1:

 - Make this a patch series.
 - Updated gitignore to ignore created files. The documentation
   directory become impossible to examine with git status.
 - Move all the man pages into libtraceevent-parse-files.txt as it
   become obvious after writing the man page for
   tep_parse_printk_formats(), that they should all be grouped together.

Steven Rostedt (VMware) (5):
  libtraceevent: Update gitignore
  libtraceevent: Fix dependencies in Documentation Makefile
  libtraceevent: Add the API tep_parse_kallsyms()
  libtraceevent: Add the API tep_parse_saved_cmdlines()
  libtraceevent: Add the API tep_parse_printk_formats()

 .gitignore                                  |   5 +
 Documentation/.gitignore                    |   3 +
 Documentation/Makefile                      |  24 +--
 Documentation/libtraceevent-parse-files.txt | 149 ++++++++++++++++++
 src/event-parse.c                           | 161 ++++++++++++++++++++
 src/event-parse.h                           |   3 +
 6 files changed, 336 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/.gitignore
 create mode 100644 Documentation/libtraceevent-parse-files.txt

-- 
2.29.2

