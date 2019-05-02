Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1BEC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 15:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66B642081C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 15:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfEBPgt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 11:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfEBPgs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 11:36:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24E882081C;
        Thu,  2 May 2019 15:36:48 +0000 (UTC)
Date:   Thu, 2 May 2019 11:36:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 27/30] tools/lib/traceevent: Man pages for tep
 plugins APIs
Message-ID: <20190502113646.39ce4596@gandalf.local.home>
In-Reply-To: <CACqStocBTaULG=DHX3_uJTAzki3fnPN+mdKoiYgQ9bCD-iUPyQ@mail.gmail.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-28-tstoyanov@vmware.com>
        <20190430213816.61705657@oasis.local.home>
        <CACqStocBTaULG=DHX3_uJTAzki3fnPN+mdKoiYgQ9bCD-iUPyQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 2 May 2019 15:23:28 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> >
> > We should change this to be:
> >
> >  ~/.config/traceevent/plugins/plugins_*.so
> >  
> Current directory is ~/.traceevent/plugins. I suggest to release the
> man page in this way, and later
> when we change the library, to update the man page with the new path.
> Do you prefer to change
> the path in the code before releasing the man pages ?

Hmm, I was about to say I'm fine with it, but I think this is something
we need to change before we say the library is good to go. Let's hold
off on this man page until we make the code update.

Thanks!

-- Steve
