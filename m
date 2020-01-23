Return-Path: <SRS0=jdea=3M=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3062AC35240
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 23:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF8A72087E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 23:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgAWXrP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 18:47:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgAWXrP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 18:47:15 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6462087E;
        Thu, 23 Jan 2020 23:47:14 +0000 (UTC)
Date:   Thu, 23 Jan 2020 18:47:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] trace-cmd: Unit test for libtracefs
Message-ID: <20200123184713.18a6f314@rorschach.local.home>
In-Reply-To: <20200117135544.598235-6-tz.stoyanov@gmail.com>
References: <20200117135544.598235-1-tz.stoyanov@gmail.com>
        <20200117135544.598235-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 17 Jan 2020 15:55:44 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The CUnit test infrastructure is integrated in trace-cmd.
>  http://cunit.sourceforge.net/
> The library and its headers must be installed on the machine, in order
> to build the trace-cmd unit tests. For Fedora, these packages must be installed:
>    CUnit, CUnit-devel
> 
> A new directory is added:
>  lib/utest

After running these patches through my test suite, if nothing goes
wrong I plan on applying them all but this one. My only issue with this
patch is the location of utest. Why pick lib? It probably should be a
top level directory itself. It's not going to be a library, is it?

-- Steve


> containing unit tests implementation.
> 
> Added new target to trace-cmd top Makefile:
>   make test
> which builds the unit test binary:
>  lib/utest/trace-utest
> 
> The goal of this patch is not to provide full unit test coverage of
> libtracefs, but to be a POC for adding test infrastructure to trace-cmd.
> 
> The first API, covered be the test is:
>   tracefs_iterate_raw_events()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
