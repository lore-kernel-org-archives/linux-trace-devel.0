Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D9BC4167B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2C122225
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgLHVzq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730400AbgLHVzp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 16:55:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DEA420C56
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:55:05 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmkwq-003sr1-8i
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 16:55:04 -0500
Message-ID: <20201208215404.135186972@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 16:54:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] libtracefs: Clean up of the source directory
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven Rostedt (VMware) (6):
      libtracefs: Move features.mk into scripts directory
      libtracefs: Remove LIBTRACEFS_DIR as it is the same as bdir
      libtracefs: Use LIBTRACEFS_STATIC/SHARED instead of open coding them
      libtracefs: Move source files to new src/ directory
      libtracefs: Use pkg-config to find libtraceevent
      libtracefs: Have make clean remove the .so.X file

----
 Makefile                                     | 54 +++++++++++-----------------
 features.mk => scripts/features.mk           |  0
 tracefs-events.c => src/tracefs-events.c     |  0
 tracefs-instance.c => src/tracefs-instance.c |  0
 tracefs-utils.c => src/tracefs-utils.c       |  0
 utest/Makefile                               |  2 +-
 6 files changed, 22 insertions(+), 34 deletions(-)
 rename features.mk => scripts/features.mk (100%)
 rename tracefs-events.c => src/tracefs-events.c (100%)
 rename tracefs-instance.c => src/tracefs-instance.c (100%)
 rename tracefs-utils.c => src/tracefs-utils.c (100%)
