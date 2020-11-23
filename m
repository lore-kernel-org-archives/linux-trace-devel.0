Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D07CC63777
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 18:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D33320702
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 18:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgKWStl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbgKWStl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 13:49:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000CB20657
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 18:49:40 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1khGuB-0017Wz-Rk
        for linux-trace-devel@vger.kernel.org; Mon, 23 Nov 2020 13:49:39 -0500
Message-ID: <20201123184841.548901150@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 23 Nov 2020 13:48:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] libtraceevent: Some Makefile updates
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed the links in installing the library, as well as removing the
temporary file of libtraceveent.pc that is created by root doing an
install.


Steven Rostedt (VMware) (2):
      libtraceevent: Add libtraceevent.so.$(EP_VERSION) to targets and fix links
      libtracevent: Remove tempfile libtraceevent.pc

----
 Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)
