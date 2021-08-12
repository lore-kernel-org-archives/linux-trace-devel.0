Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBEFC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6A36105A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 00:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhHLA4O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhHLA4N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 20:56:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 510F060FD9;
        Thu, 12 Aug 2021 00:55:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDz0e-003oyT-1X; Wed, 11 Aug 2021 20:55:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Make hist variable names unique
Date:   Wed, 11 Aug 2021 20:55:44 -0400
Message-Id: <20210812005546.910833-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to be able to have API that can do onmax() and onchange() as well
as include the .save() and .snapshot() actions, we need to make sure that
the variable names are unique even between different events.

The first adds a "randomness" to the name, and the second patch fixes an
issue where the "end" event fields are saved in the same name as they are
called, then the ".save" action can not be used on them.

Steven Rostedt (VMware) (2):
  libtracefs: Add random number to keep synthetic variables unique
  libtracefs: Have end event variables not be the end event field name

 src/tracefs-hist.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

-- 
2.30.2

