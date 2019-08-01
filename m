Return-Path: <SRS0=bY76=V5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D789C433FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 13:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D44820665
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 13:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbfHANZ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 09:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbfHANZ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 09:25:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F286C20665;
        Thu,  1 Aug 2019 13:25:55 +0000 (UTC)
Date:   Thu, 1 Aug 2019 09:25:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Separate trace-cmd and kernelshark
 documentations.
Message-ID: <20190801092554.3b32dc91@gandalf.local.home>
In-Reply-To: <20190801121955.20393-1-tz.stoyanov@gmail.com>
References: <20190801121955.20393-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  1 Aug 2019 15:19:55 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> KernelShark is going to be a stand alone package, separate from trace-cmd.
> The code is already in its own directory, but HTML and man page documents
> are still not separated.
> All KernelShark related documentation (HTML and the man page) is moved
> from Documentation/ to kernel-shark/doc/ directory.
> New targets are added to trace-cmd Makefile:
>  doc_gui - build KernelShrak documentation
>  doc_gui_clean - clean KernelShrak documentation
>  install_doc_gui - install KernelShrak documentation
> The existing Makefile targets:
>  doc, doc_clean, install_doc
> are modified to work only with trace-cmd documentation.
> The new Makefile targets must be used to build and install KernelShark docs.
> 
> This change was requested by Bas van Dijk <v.dijk.bas@gmail.com>, to
> simplify packaging trace-cmd and kernelshark for nixpkgs, as two
> different packages.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---


>  rename {Documentation => kernel-shark/doc}/HTML/images/kernelshark-logo.svg (100%)

When I first saw this, I questioned moving this out of Documentation.
But thinking about it more, it does make sense.

But can I ask you to keep the "Documentation" name?

It just seems more professional, and also stays in line with the
trace-cmd and Linux kernel "Documentation" directory name.

Thanks!

-- Steve

