Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD780C4361A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 19:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E843221E8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 19:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgLCTIX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:08:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCTIW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 14:08:22 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72C2E221E8
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Dec 2020 19:07:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kktx6-002rzt-VH
        for linux-trace-devel@vger.kernel.org; Thu, 03 Dec 2020 14:07:40 -0500
Message-ID: <20201203190652.568672226@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 03 Dec 2020 14:06:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] libtracefs: Library building fixes
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Steven Rostedt (VMware) (2):
      libtracefs: Remove useless LIBS = -ldl in Makefile
      libtracefs: Add $(LIBS) to building of shared object library

----
 Makefile         | 2 --
 scripts/utils.mk | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)
