Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983BAC46499
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 16:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BEB72184C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 16:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfGEQeO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 12:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfGEQeO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 12:34:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B0BF2184C;
        Fri,  5 Jul 2019 16:34:13 +0000 (UTC)
Date:   Fri, 5 Jul 2019 12:34:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [ANNOUNCE] trace-cmd v2.8.1
Message-ID: <20190705123411.4285e625@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Just after releasing 2.8, some bugs were found (isn't that always the
case?). Now we have 2.8.1 stable release:

  http://trace-cmd.org

-- Steve

Short log here:

Greg Thelen (2):
      trace-cmd: Always initialize write_record() len
      trace-cmd: Avoid using uninitialized handle

Steven Rostedt (VMware) (1):
      trace-cmd: Version 2.8.1

Tzvetomir Stoyanov (VMware) (1):
      trace-cmd: Do not free pages from the lookup table in struct cpu_data in case trace file is loaded.
