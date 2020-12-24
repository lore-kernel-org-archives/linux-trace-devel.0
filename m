Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA23C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Dec 2020 17:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F94F224B1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Dec 2020 17:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgLXRX7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Dec 2020 12:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgLXRX7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Dec 2020 12:23:59 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B5922288;
        Thu, 24 Dec 2020 17:23:18 +0000 (UTC)
Date:   Thu, 24 Dec 2020 12:23:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: libtracefs documentation install problem
Message-ID: <20201224122316.357b4538@oasis.local.home>
In-Reply-To: <CADVatmNE_Bm6Gv9ArNsTQhJME9y7gbnExFf+iy_=68CSKKZ+Xw@mail.gmail.com>
References: <CADVatmNE_Bm6Gv9ArNsTQhJME9y7gbnExFf+iy_=68CSKKZ+Xw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 24 Dec 2020 16:36:56 +0000
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> Hi Steve,
> 
> I was trying to build and install the documentation. "make doc"
> succeeds and builds the man pages and the html files, but when I do
> "make install_doc" it fails with:
> make -C /home/sudip/libtracefs/Documentation install
> Makefile:148: *** "You need to install asciidoc xmlto for man pages".  Stop.
> make: *** [Makefile:263: install_doc] Error 2

Ug, I thought I tested this :-/

> 
> The packages asciidoc and xmlto are already installed and I guess
> thats why it could build. Looking at the Documantion makefile I can
> see that install-man is checking for the tools by calling
> 'get-executable' but I did not see 'get-executable' defined anywhere.
> Did I miss something or did you miss copying it from
> "tools/scripts/utilities.mak" of the kernel ?

Probably.

Could you file a bugzilla report so I can get to it on Jan 6 when I go
back to work.

  https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---

> 
> I hope I am not disturbing your holidays. :)
> 

Nah, but I wont be fixing it until next year. Happy Holidays!

-- Steve
