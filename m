Return-Path: <SRS0=uy/X=6E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6FDC3815B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 19:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24DE920782
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 19:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgDTTn3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgDTTn2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 15:43:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6071420782;
        Mon, 20 Apr 2020 19:43:27 +0000 (UTC)
Date:   Mon, 20 Apr 2020 15:43:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
Message-ID: <20200420154325.6072d96b@gandalf.local.home>
In-Reply-To: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 17 Apr 2020 21:39:14 +0100
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> The build fails while building with gcc-10 with the error:
> multiple definition of `common_type_field'

I'd say this is a bug in gcc.

Both variables are static to the files. Why is it complaining?

If its a new "feature" of gcc, I would look to see if there's a way to
quiet the warning, and adding that to the Makefile instead.

-- Steve

> 
> Rename the field in trace-hist.c and trace-mem.c to satisfy gcc-10.
> 
