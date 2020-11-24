Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D507EC56201
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8167720888
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbgKXNvY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 08:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387627AbgKXNvI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 08:51:08 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F6F20872;
        Tue, 24 Nov 2020 13:51:07 +0000 (UTC)
Date:   Tue, 24 Nov 2020 08:51:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/2] libtracevent: Remove tempfile libtraceevent.pc
Message-ID: <20201124085105.1e87c220@gandalf.local.home>
In-Reply-To: <CAPpZLN4MosDu7weSfpR+4FW72dRGxCVsFHGa6dV_hv1ROBGffA@mail.gmail.com>
References: <20201123184841.548901150@goodmis.org>
        <20201123184940.031517790@goodmis.org>
        <CAPpZLN4MosDu7weSfpR+4FW72dRGxCVsFHGa6dV_hv1ROBGffA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 24 Nov 2020 07:26:25 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Mon, Nov 23, 2020 at 8:50 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> >
> > "make install" copies libtraceevent.pc.template to libtraceevent.pc and then
> > modifies it for the installation. This command is usually executed as root,
> > and when finished, it leaves behind the libtraceevent.pc file owned by root.
> >
> > Have the "make install" clean up and remove the temporary libtraceevent.pc
> > file, so that root owned files do not get left behind.  
> 
> Isn't it useful to have this file after the "make install" command, for debug
> purposes - to see how exactly it was modified ? The file is removed by
> "make clean".

Then it needs to be created via normal make. "make install" should leave no
"artifacts" lying around. It's usually done as root, and anything left may
be stuck there for the normal user (not be able to delete it).

The files removed by "make clean" are only those created by normal makes.

I can change the patch to have the creation of the package config created
by "make" and not by "make install", and then have it removed by "make
clean".

-- Steve
