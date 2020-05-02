Return-Path: <SRS0=xxv2=6Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC535C47256
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 May 2020 01:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD02921775
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 May 2020 01:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgEBBDo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 May 2020 21:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgEBBDo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 May 2020 21:03:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4AC7208DB;
        Sat,  2 May 2020 01:03:43 +0000 (UTC)
Date:   Fri, 1 May 2020 21:03:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark: Change the mechanism of the
 multi-threaded search
Message-ID: <20200501210342.029e8358@oasis.local.home>
In-Reply-To: <20200430225637.1b05d3ed@gandalf.local.home>
References: <20200330161723.29816-1-y.karadz@gmail.com>
        <20200330161723.29816-3-y.karadz@gmail.com>
        <20200424161246.4d9f22b8@gandalf.local.home>
        <69e2a749-8582-35dc-0a6d-5d08988d4a5c@gmail.com>
        <20200427151802.7a3a9be3@gandalf.local.home>
        <20200430225637.1b05d3ed@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 30 Apr 2020 22:56:37 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 27 Apr 2020 15:18:02 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > I would say we can apply both. What do you think?    
> > 
> > I'll try it out and let you know.  
> 
> Want to resend this patch with this change?
> 

BTW, I had to test this on my laptop (which doesn't have 24 logical
CPUs), but was able to reproduce it with the following patch. Perhaps
we should try various numbers to make sure it works for other strange
combinations.

-- Steve

diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 12371ad7..6e2b5fc6 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -676,7 +676,7 @@ void KsTraceViewer::_setSearchIterator(int row)
 
 void KsTraceViewer::_searchItemsMT()
 {
-	int nThreads = std::thread::hardware_concurrency();
+	int nThreads = 24; //std::thread::hardware_concurrency();
 	int startFrom, nRows(_proxyModel.rowCount({}));
 	std::vector<QPair<int, int>> ranges(nThreads);
 	std::vector<std::future<QList<int>>> maps;
