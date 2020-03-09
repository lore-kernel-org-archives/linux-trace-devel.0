Return-Path: <SRS0=4xj7=42=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A04BC10F27
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D99A215A4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgCITF2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 15:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbgCITF2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 15:05:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6EE215A4
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Mar 2020 19:05:27 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jBNiQ-0033B5-N3
        for linux-trace-devel@vger.kernel.org; Mon, 09 Mar 2020 15:05:26 -0400
Message-Id: <20200309190449.207021960@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 09 Mar 2020 15:04:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: A couple of clean up patches
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

While playing with the sync code, I saw some clean ups that are
worth doing.

Steven Rostedt (VMware) (2):
      trace-cmd: It's DEFAULT_INPUT_FILE not DEFAUT_INPUT_FILE
      trace-cmd: Have instances include a copy of its output file

----
 tracecmd/include/trace-local.h |  3 ++-
 tracecmd/trace-dump.c          |  2 +-
 tracecmd/trace-hist.c          |  2 +-
 tracecmd/trace-mem.c           |  2 +-
 tracecmd/trace-read.c          |  2 +-
 tracecmd/trace-record.c        | 31 ++++++++++++++++---------------
 tracecmd/trace-restore.c       |  2 +-
 tracecmd/trace-split.c         |  2 +-
 tracecmd/trace-tsync.c         |  6 ++----
 9 files changed, 26 insertions(+), 26 deletions(-)
