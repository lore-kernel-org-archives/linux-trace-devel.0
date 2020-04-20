Return-Path: <SRS0=uy/X=6E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3ADC54FCF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 19:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E967C2084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 19:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgDTTxX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTTxW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 15:53:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D9C2084D;
        Mon, 20 Apr 2020 19:53:21 +0000 (UTC)
Date:   Mon, 20 Apr 2020 15:53:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
Message-ID: <20200420155320.55d3c3f2@gandalf.local.home>
In-Reply-To: <20200420154325.6072d96b@gandalf.local.home>
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
        <20200420154325.6072d96b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Apr 2020 15:43:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 17 Apr 2020 21:39:14 +0100
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> 
> > The build fails while building with gcc-10 with the error:
> > multiple definition of `common_type_field'  
> 
> I'd say this is a bug in gcc.
> 
> Both variables are static to the files. Why is it complaining?
> 
> If its a new "feature" of gcc, I would look to see if there's a way to
> quiet the warning, and adding that to the Makefile instead.
> 

And when doing a search of "gcc 10" "multiple definitions" the first hit
was this:

  https://patchwork.kernel.org/patch/11372767/


Which is Tzvetomir's patch (which I accepted, but didn't think too much
about it).

I was thinking of just adding -fcommon, but then took a look at the
definition of this:

"-fcommon

    In C code, this option controls the placement of global variables defined without an initializer, known as tentative definitions in the C standard. Tentative definitions are distinct from declarations of a variable with the extern keyword, which do not allocate storage.

    The default is -fno-common, which specifies that the compiler places uninitialized global variables in the BSS section of the object file. This inhibits the merging of tentative definitions by the linker so you get a multiple-definition error if the same variable is accidentally defined in more than one compilation unit.

    The -fcommon places uninitialized global variables in a common block. This allows the linker to resolve all tentative definitions of the same variable in different compilation units to the same object, or to a non-tentative definition. This behavior is inconsistent with C++, and on many targets implies a speed and code size penalty on global variable references. It is mainly useful to enable legacy code to link without errors.
"

OK, so this has a warning due to linking optimizations, and when there's
common names, it causes linking to do some more tricks, and can cause
issues when linking with C++ programs (like KernelShark).

OK, I'll take this patch, and may even enable a -fno-common to find other
cases of this without having to wait till my distro adds gcc 10 by default.

-- Steve
