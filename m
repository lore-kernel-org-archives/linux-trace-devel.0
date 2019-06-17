Return-Path: <SRS0=wRMB=UQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387FCC31E5B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17A820652
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfFQWcX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFQWcX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 18:32:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACC132080A;
        Mon, 17 Jun 2019 22:32:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hd0An-000332-O1; Mon, 17 Jun 2019 18:32:21 -0400
Message-Id: <20190617223129.706595135@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 17 Jun 2019 18:31:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Troy Engel <troyengel@gmail.com>
Subject: [PATCH 0/2] kernel-shark: Make some top level "make" changes
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is built on top of the three patches from Yordan that can be
found here:

  https://patchwork.kernel.org/project/linux-trace-devel/list/?series=132531

It makes "make clean" remove cmake generated files (my build failed
and I couldn't figure out why. "make clean" should allow builds to
build again when CMake files change).

I also adde a "make BUILD_TYPE=foo" to pass to the cmake command to
change the CMAKE_BUILD_TYPE to allow an easy build by the package
maintainers to change how KernelShark is built.

Steven Rostedt (VMware) (2):
      kernel-shark: Have "make clean" run cmake-clean.sh
      kernel-shark: Add 'make BUILD_TYPE=X gui' to change how the gui is made

----
 Makefile                    |  6 +++++-
 kernel-shark/CMakeLists.txt |  2 +-
 kernel-shark/README         | 23 +++++++++++++++++------
 3 files changed, 23 insertions(+), 8 deletions(-)
