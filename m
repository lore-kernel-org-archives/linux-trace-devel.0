Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A5FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 18:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0420561442
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 18:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhENSan (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 14:30:43 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7154 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229701AbhENSan (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 14:30:43 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 14 May 2021 11:29:27 -0700
Received: from vypre.com (unknown [10.21.244.184])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 60887204A4;
        Fri, 14 May 2021 11:29:31 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v4 0/2] trace-cmd: Use vsock tracing to find cids and threads
Date:   Fri, 14 May 2021 14:29:26 -0400
Message-ID: <20210514182928.1378121-1-rostedt@goodmis.org>
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

Use tracing the wake-up and kvm-exit events to find the task that is
owned by the given CID. Also, do the same to find the mappings of
threads and the guest vCPUs.

Changes since v3:

 -  Remove unnecessary check of *cid < 0.

Steven Rostedt (VMware) (2):
  trace-cmd: Find PID of host-guest task from tracing vsock connection
  trace-cmd: Trace timesync to find pids that map vCPUs

 tracecmd/include/trace-local.h |   2 +
 tracecmd/trace-record.c        | 199 ++++++++++++++++++++++++++++-
 tracecmd/trace-vm.c            | 227 ++++++++++++++++++++++++++++++++-
 3 files changed, 426 insertions(+), 2 deletions(-)

-- 
2.29.2

