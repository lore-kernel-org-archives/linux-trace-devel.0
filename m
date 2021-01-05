Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A1D9C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 21:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 408AC22D71
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 21:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbhAEVaO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 16:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbhAEVaN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 16:30:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B71222D6E;
        Tue,  5 Jan 2021 21:29:33 +0000 (UTC)
Date:   Tue, 5 Jan 2021 16:29:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/5] kernel-shark: Split the installation in two
 components
Message-ID: <20210105162931.06db93c1@gandalf.local.home>
In-Reply-To: <20210105155453.41228-5-y.karadz@gmail.com>
References: <20210105155453.41228-1-y.karadz@gmail.com>
        <20210105155453.41228-5-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  5 Jan 2021 17:54:52 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The user can choose to install only the KernelShark GUI via
> "install_gui.sh". It is also possible to install the library headers
> and this can be done via "install_libkshark-devel.sh".
> 
> The changes implemented in this patch are inspired by the talk
> "Deep CMake For Library Authors" presented at CppCon 2019 by Craig Scott.
> https://crascit.com/2019/10/16/cppcon-2019-deep-cmake-for-library-authors/
> 

I applied the series. But is there a way to install in a specific directory
and not in the system directories? (I didn't watch the talk).

For example, I can do:

 $ mkdir /tmp/install
 $ make DESTDIR=/tmp/install/ install

for libtraceveent, libtracefs and trace-cmd / libtracecmd and it will
install into /tmp/install/... just like it would have installed in /. The
big difference is, I don't need to be root to run that command.

Then what I can do is:

 $ cd /tmp/install
 $ tar -cvjf ../package.tar.bz2 .
 $ scp ../package.tar.bz2 root@somebox:/tmp
 $ ssh root@somebox
 # cd /
 # tar -xvjf /tmp/package.tar.bz2

And that would have installed the package on to the machine "somebox".

-- Steve
