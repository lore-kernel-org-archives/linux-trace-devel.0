Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F94AC43460
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2010A611EE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhDGUgw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 16:36:52 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:46601 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234141AbhDGUgw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 16:36:52 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 16:36:52 EDT
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 7 Apr 2021 13:21:32 -0700
Received: from vypre.com (unknown [10.21.255.158])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id B30DE211AA;
        Wed,  7 Apr 2021 13:21:34 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs: Update filtering functions
Date:   Wed, 7 Apr 2021 16:21:23 -0400
Message-ID: <20210407202126.1870994-1-rostedt@goodmis.org>
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

Add tracefs_function_notrace() to set the functions not to trace.
Create a per instance pthread mutex lock.

[ This is actually the first time I'm sending patches via
  git send-email! Hopefully I dont' screw it up ;-) ]

Steven Rostedt (VMware) (3):
  libtracefs: Move most functionality into helper function for
    tracefs_function_filter()
  libtracefs: Add tracefs_function_notrace() API
  libtracefs: Add a pthread_mutex per instance

 Documentation/libtracefs-function-filter.txt |  19 ++-
 include/tracefs-local.h                      |  12 +-
 include/tracefs.h                            |   3 +
 src/tracefs-instance.c                       |   6 +
 src/tracefs-tools.c                          | 152 ++++++++++++-------
 5 files changed, 131 insertions(+), 61 deletions(-)

-- 
2.29.2

