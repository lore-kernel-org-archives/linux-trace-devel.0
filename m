Return-Path: <SRS0=bBQs=3A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31CCC33C9E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 11 Jan 2020 10:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87B86205F4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 11 Jan 2020 10:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578738140;
	bh=CeEjd43JKGClgJcCmji5Y3DbpMh4kKHdTrFqyJWjyRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=S5k3rddv4bW7qn9BIWxSzI4VWrKn9BbH0XMPKr/qHO1wW4xLiqMpXbrZqq3Bff63F
	 CTphxS814rutJmeDzI9EkEq25dT4kquVgRA/JoF9sHvzRBb6hm4GW3wCNsqYkFhYkE
	 UvCmkGa+9Pyd2PU8PE84Kad3e6IhGCkYrz5KMMls=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgAKKWR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 11 Jan 2020 05:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbgAKKWO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 11 Jan 2020 05:22:14 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDAFB20882;
        Sat, 11 Jan 2020 10:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738133;
        bh=CeEjd43JKGClgJcCmji5Y3DbpMh4kKHdTrFqyJWjyRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLhsUdFk2InQqDh+tu7cA80zeK3kNxFlsBrNteGrOeCocPzual8AHgtgWs7JyG9sm
         1Kpl7+g2bnYuDygHxEjIPgs3viLzzoL+8bORCkocWA+p/gbnhQnN0jEXBgD0joKMVP
         KttAfV0emGslbX+RBemLqhtNZoQ9HAe7to85FDB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudipm Mukherjee <sudipm.mukherjee@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/165] libtraceevent: Fix lib installation with O=
Date:   Sat, 11 Jan 2020 10:48:54 +0100
Message-Id: <20200111094922.308968341@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

[ Upstream commit 587db8ebdac2c5eb3a8851e16b26f2e2711ab797 ]

When we use 'O=' with make to build libtraceevent in a separate folder
it fails to install libtraceevent.a and libtraceevent.so.1.1.0 with the
error:

  INSTALL  /home/sudip/linux/obj-trace/libtraceevent.a
  INSTALL  /home/sudip/linux/obj-trace/libtraceevent.so.1.1.0

  cp: cannot stat 'libtraceevent.a': No such file or directory
  Makefile:225: recipe for target 'install_lib' failed
  make: *** [install_lib] Error 1

I used the command:

  make O=../../../obj-trace DESTDIR=~/test prefix==/usr  install

It turns out libtraceevent Makefile, even though it builds in a separate
folder, searches for libtraceevent.a and libtraceevent.so.1.1.0 in its
source folder.

So, add the 'OUTPUT' prefix to the source path so that 'make' looks for
the files in the correct place.

Signed-off-by: Sudipm Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191115113610.21493-1-sudipm.mukherjee@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 5315f3787f8d..d008e64042ce 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -97,6 +97,7 @@ EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
 LIB_TARGET  = libtraceevent.a libtraceevent.so.$(EVENT_PARSE_VERSION)
 LIB_INSTALL = libtraceevent.a libtraceevent.so*
+LIB_INSTALL := $(addprefix $(OUTPUT),$(LIB_INSTALL))
 
 INCLUDES = -I. -I $(srctree)/tools/include $(CONFIG_INCLUDES)
 
-- 
2.20.1



