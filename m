Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923D8C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F5B613E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhDVVIJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:08:09 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:20411 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhDVVIJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 17:08:09 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 22 Apr 2021 14:07:29 -0700
Received: from vypre.com (unknown [10.21.244.251])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 416E32046C;
        Thu, 22 Apr 2021 14:07:33 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Nicolas Sterchele <nicolas@sterchelen.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd: Add gcc printf format specifier
Date:   Thu, 22 Apr 2021 17:07:28 -0400
Message-ID: <20210422210730.857958-1-rostedt@goodmis.org>
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

To keep from having bad warning() or die() formats with repect to their
args, add the gcc printf format specifier that will have gcc check the
formatting of the strings used.

Steven Rostedt (VMware) (2):
  trace-cmd: Add printf format attribute to die() and warning()
  trace-cmd: Fix up the die() formats

 tracecmd/include/trace-local.h |  5 +++++
 tracecmd/trace-dump.c          | 14 +++++++-------
 tracecmd/trace-record.c        |  2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.29.2

