Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D221C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63359613C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 20:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhENUvv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 16:51:51 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:43937 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhENUvv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 16:51:51 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 14 May 2021 13:50:34 -0700
Received: from vypre.com (unknown [10.21.244.184])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 4A02D204A3;
        Fri, 14 May 2021 13:50:38 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtraceevent: Add __tep_vprint() for overrides
Date:   Fri, 14 May 2021 16:50:33 -0400
Message-ID: <20210514205036.1383167-1-rostedt@goodmis.org>
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

I found that I wanted to override tep_vprint() but still call the
default function from my override, and found that I could not do so.
That is the purpose of the "__" versions that were used before.

Also, do some clean ups that were discovered while creating this.

Steven Rostedt (VMware) (3):
  libtraceevent: Add include of event-parse.h into event-utils.h
  libtraceevent: Have the header protection be more name space safe
  libtraceevent: Add __tep_vprint() for overrides to use

 src/event-parse.h |  4 ++--
 src/event-utils.h | 12 ++++++++++--
 src/parse-utils.c | 23 +++++++++++++++++++++++
 3 files changed, 35 insertions(+), 4 deletions(-)

-- 
2.29.2

