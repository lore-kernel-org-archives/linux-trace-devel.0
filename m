Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84FCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 14:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5126115A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 14:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhKKOPc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 09:15:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhKKOPb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 09:15:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54E1561152;
        Thu, 11 Nov 2021 14:12:42 +0000 (UTC)
Date:   Thu, 11 Nov 2021 09:12:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Add Requires: libtracefs to libtracecmd.pc
 file
Message-ID: <20211111091239.1a286043@gandalf.local.home>
In-Reply-To: <47ed3cdf-5f2e-1823-b933-e23b604e208b@gmail.com>
References: <20211109111426.7639b2a6@gandalf.local.home>
        <db8be415-bb25-a2fe-1d30-8e4a446154f7@gmail.com>
        <20211110111729.41a7eb6b@gandalf.local.home>
        <47ed3cdf-5f2e-1823-b933-e23b604e208b@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 10:12:46 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> . Looking into
> 
> /usr/local/lib/x86_64-linux-gnu/pkgconfig
> 
> I see that most of the configuration files do not have 'lib', however there is also a number of files starting with 
> 'lib'. I wonder if there is some rule about using this 'lib' prefix.

Mostly just preference by those creating it. I used it to differentiate the
terms. "tracefs" is the file system that "libtracefs" manipulates.

And libtraceevents is because it's always been that. I'm not even sure if
I'm the one that called it.

It also should match the name of the repos. As we call the repos libtracefs
and libtraceevent, we should have the pkgconfig files match it as well. And
the name of the packages (.deb or .rpm) should match.

-- Steve
