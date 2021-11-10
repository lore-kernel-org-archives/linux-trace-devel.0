Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAD6C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 23:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E966112E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 23:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhKJX21 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 18:28:27 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:34883 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233964AbhKJX21 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 18:28:27 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2021 18:28:26 EST
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 10 Nov 2021 15:10:29 -0800
Received: from vypre.local.home (unknown [10.21.244.28])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 6D06820564;
        Wed, 10 Nov 2021 15:10:34 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] tracefs: Make minor updates to histograms
Date:   Wed, 10 Nov 2021 18:10:23 -0500
Message-ID: <20211110231025.1131051-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Make some minor changes to the tracefs histogram logic that Yordan
made.

Based on:

  https://patchwork.kernel.org/project/linux-trace-devel/list/?series=552199

Steven Rostedt (VMware) (2):
  tracefs Documentation: Fix tracefs_hist_add_sort_key() example
  tracefs: Rename tracefs_hist_reset_sort_key() tracefs_hist_set_sort_key()

 Documentation/libtracefs-hist.txt | 11 ++++++-----
 include/tracefs.h                 |  4 ++--
 src/tracefs-hist.c                |  6 +++---
 3 files changed, 11 insertions(+), 10 deletions(-)

-- 
2.31.1

