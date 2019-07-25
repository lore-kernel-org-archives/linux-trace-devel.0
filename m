Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A22C76190
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08390229F3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfGYTrk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 15:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfGYTrk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 15:47:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEAA9229F3;
        Thu, 25 Jul 2019 19:47:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hqjiE-0002I9-TZ; Thu, 25 Jul 2019 15:47:38 -0400
Message-Id: <20190725194537.884800321@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 25 Jul 2019 15:45:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 0/2] kernel-shark: Let polkit decide the environment and path of kshark-record
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As the policy defined in the polkit actions for KernelShark Record define
both the environment ($DISPLAY and $XAUTHORITY) as well as the path
to the executible, no need to add hacks to the kshark-su-record that
is used. Just revert the code that did so.

Steven Rostedt (VMware) (2):
      kernel-shark: Revert adding environment variables to kshark-su-record
      kernel-shark: Revert adding relative path to policy installation

----
 kernel-shark/bin/kshark-su-record | 3 +--
 kernel-shark/src/CMakeLists.txt   | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)
