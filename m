Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561DFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DCC323609
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgLJCjE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:39:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgLJCjE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:39:04 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E42A423B51;
        Thu, 10 Dec 2020 02:38:23 +0000 (UTC)
Date:   Wed, 9 Dec 2020 21:38:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 00/27] Start KernelShark v2 transformation
Message-ID: <20201209213822.74c90f15@oasis.local.home>
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Dec 2020 15:41:36 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> In this patch-set we are starting the introduction of the changes
> in the C API of libkshark. The goal of this transformation is to
> turn KernelShark into a general purpose toolkit for analysis of
> tracing data that is no longer strongly coupled to the Ftrace/trace-cmd
> data format. At the end of the transformation KernelShark will be able
> to merge and simultaneously visualize data from different tracers,
> recorded in different data formats. It will also significantly extend
> the possibilities for user customization.
> 
> This  patch-set transforms the way KernelShark processes the raw tracing
> data. Later, in a consecutive patch-sets we will introduce the changes
> in the visualization instruments and in the KernelShark GUI itself.
> 
> Steven,
> I believe all patches in this set are ready to move upstream.
>

Thanks Yordan,

I just realized that the current repo doesn't build against the latest
libtracefs, because the library's location has moved.  I noticed that
the CMake files have it hard coded with:

 find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
 find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)

Is there a way to make cmake use pkg-config?

	pkg-config --cflags --libs libtracefs

Will give us the correct includes and libraries for building against
libtracefs if installed.

We'll want the same for libtraceevent and libtracecmd as well.

-- Steve
