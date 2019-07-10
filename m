Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD25FC74A25
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A128C214AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfGJNr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 09:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfGJNr0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 09:47:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59EC120861;
        Wed, 10 Jul 2019 13:47:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hlCwP-0002o5-3H; Wed, 10 Jul 2019 09:47:25 -0400
Message-Id: <20190710134636.116362181@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 10 Jul 2019 09:46:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 0/4] kernel-shark: The road to 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Some fixes for getting to 1.0.

Steven Rostedt (VMware) (3):
      revert: "kernel-shark: Remove a duplicate error message"
      kernel-shark: Show the standard error of kshark-record
      kernel-shark: Use '<br>' for dialog and '\n' for console error messages

Yordan Karadzhov (VMware) (1):
      kernel-shark: Remove the "make install" suggestion for capture errors

----
 kernel-shark/src/KsMainWindow.cpp | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)
