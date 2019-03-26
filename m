Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F9AC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 12:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79C3020856
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 12:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfCZM6Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbfCZM6X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 08:58:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D361E20823;
        Tue, 26 Mar 2019 12:58:22 +0000 (UTC)
Date:   Tue, 26 Mar 2019 08:58:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Patrick McLean <chutzpah@gentoo.org>
Subject: Re: [PATCH v2 1/3] kernel-shark: Reorder the priority when
 searching for trace-cmd libs
Message-ID: <20190326085821.394b6de0@gandalf.local.home>
In-Reply-To: <20190313152220.22026-2-ykaradzhov@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-2-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 17:22:18 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The CMAKE build system of KernelShark performs automated search for the
> trace-cmd libraries, headers and executable before building the GUI.
> The new order of the list of directories to search in is the following:
> 
> 1. ${TRACE_CMD}/  ($TRACE_CMD is an environment variable)
> 
> 2. CMAKE_SOURCE_DIR/../
> 
> 3. Platform / system specific locations

I'm still confused. We shouldn't be looking for any paths at build time.
This should be done at run time.

Now, we can check the local directory that kernelshark lives in. That
is, if we are running from a fresh build, at start up, we can look at

 `pwd`/../lib | `pwd`/../../plugins

and see if those directories exist at run time. And if they do, we can
use them (as we would assume that the exec is running from a local
source tree).

I really don't want any build artifacts in the executable. This will
mean that you need to do special arrangements to build kernelshark and
then move it to another machine.

-- Steve

> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>
