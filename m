Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085FDC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 20:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEFEF613E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 20:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhEMUob (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 16:44:31 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:52827 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230305AbhEMUoa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 16:44:30 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 13 May 2021 13:43:15 -0700
Received: from vypre.com (unknown [10.21.244.58])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 7334720403;
        Thu, 13 May 2021 13:43:18 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/2] trace-cmd: Use vsock tracing to find cids and threads
Date:   Thu, 13 May 2021 16:43:13 -0400
Message-ID: <20210513204315.1206204-1-rostedt@goodmis.org>
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

Changes since v2:

 - Added the two patches together into a single series:
   https://lore.kernel.org/linux-trace-devel/20210506171400.7c00b731@gandalf.local.home/
   https://lore.kernel.org/linux-trace-devel/20210507135615.033a6121@gandalf.local.home/

 - Rewrote the change log for the first patch to explain the problem
   better.

 - Used some of the new APIs of libtracefs 1.2 to simplify the code

 - Still call read_qemu_gusts() but only if the CID is not supplied on
   the command line.

Steven Rostedt (VMware) (2):
  trace-cmd: Find PID of host-guest task from tracing vsock connection
  trace-cmd: Trace timesync to find pids that map vCPUs

 tracecmd/include/trace-local.h |   2 +
 tracecmd/trace-record.c        | 202 ++++++++++++++++++++++++++++-
 tracecmd/trace-vm.c            | 227 ++++++++++++++++++++++++++++++++-
 3 files changed, 429 insertions(+), 2 deletions(-)

-- 
2.29.2

