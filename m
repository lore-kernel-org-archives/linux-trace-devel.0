Return-Path: <SRS0=NWyF=WX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5358C3A5A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 22:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60712064A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 22:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfH0WW4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 18:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfH0WWz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 18:22:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7A80217F5;
        Tue, 27 Aug 2019 22:22:54 +0000 (UTC)
Date:   Tue, 27 Aug 2019 18:22:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com
Subject: Re: [PATCH v2 1/5] kernel-shark: Show warning message when running
 as Root
Message-ID: <20190827182253.2d230e63@gandalf.local.home>
In-Reply-To: <20190826155811.32021-2-y.karadz@gmail.com>
References: <20190826155811.32021-1-y.karadz@gmail.com>
        <20190826155811.32021-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Aug 2019 18:58:07 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +	warn.setText("KernelShark will have Root privileges.");
> +	warn.setInformativeText("Continue on your own risk.");

This wasn't updated.

 From: https://lore.kernel.org/linux-trace-devel/20190809091914.75f553b2@gandalf.local.home/

> > +	QMessageBox warn;
> > +	warn.setText("KernelShark will have Root privileges.");
> > +	warn.setInformativeText("Continue on your one risk.");  
> 
> Probably better to say:
> 
>   "KernelShark is running with Root privileges."
>   "Continue at your own risk."

I could update the patch if you like, instead of sending out another
series. Let me finish the rest of the series.

-- Steve
