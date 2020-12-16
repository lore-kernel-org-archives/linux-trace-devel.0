Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F0AC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EA6523772
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 21:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgLPV6n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 16:58:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgLPV6m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 16:58:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917A9233A0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 21:58:05 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpeo8-000wdu-Bp
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 16:58:04 -0500
Message-ID: <20201216215737.396368358@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 16:57:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] libtracefs: Remove gui references and do not fail make clean
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Steven Rostedt (VMware) (2):
      libtracefs: Remove Makfefile targets that reference "gui"
      libtracefs: Do not fail make on clean target

----
 Makefile | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)
