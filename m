Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC610C76186
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 22:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8CC321926
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 22:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392367AbfGWWwk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 18:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392323AbfGWWwk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 18:52:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9332C21926;
        Tue, 23 Jul 2019 22:52:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hq3eA-0007z5-Ka; Tue, 23 Jul 2019 18:52:38 -0400
Message-Id: <20190723225044.576298160@goodmis.org>
User-Agent: quilt/0.65
Date:   Tue, 23 Jul 2019 18:50:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 0/2] kernel-shark: Be more careful with kshark-su-record
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two issues with kshark-su-record.

1) It just calls kshark-record with no path, which can be an issue
   if pkexec removes PATH variable, or sets it to something
   that kshark-record is not in.

2) Need to set DISPLAY variable, because on some of my machines,
   the kshark-record failed to execute due to pkexec removing the
   DISPLAY variable.


Steven Rostedt (VMware) (2):
      kernel-shark: Execute kshark-record from same dir as kshark-su-record
      kernel-shark: Set the DISPLAY environment for pkexec kshark-record

----
 kernel-shark/bin/kshark-su-record | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
