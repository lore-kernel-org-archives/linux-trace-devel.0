Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AE2C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 16:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48A8F64E6B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 16:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhBJQYE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 11:24:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232248AbhBJQXz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 11:23:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE0CB64E6B;
        Wed, 10 Feb 2021 16:23:13 +0000 (UTC)
Date:   Wed, 10 Feb 2021 11:23:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: Kernelshark v2 all-black plots area
Message-ID: <20210210112312.40d06a67@gandalf.local.home>
In-Reply-To: <60fd40d8-23ab-6518-4e8b-6d66bbd53f5a@gmail.com>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
        <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
        <e07be2e367576882d0cf84c33834ecafaba38136.camel@suse.com>
        <38b5ea14-cea2-1268-13ef-539fe421e442@gmail.com>
        <c047a5892fccdd5cd9550cba81fd16c71950fd8e.camel@suse.com>
        <60fd40d8-23ab-6518-4e8b-6d66bbd53f5a@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Feb 2021 17:47:16 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Dario,
> 
> On 10.02.21 г. 16:51 ч., Dario Faggioli wrote:
> > And this is how the GUI looks:
> > 
> > http://xenbits.xen.org/people/dariof/ks2-debug/kernelshark-v2-host.png
> > 
> > Then, I append the trace-(null).dat file (the guest trace). I do see
> > this on the terminal:  
> 
> I see what you mean. In this case the host and the guest are not 
> synchronized at all. I guess something went wrong during the recording. 
> Also the fact that the name of the guest VM is "(null)" looks very 
> suspicious. I guess this is not the real name of the VM you are using?
> 
> Steven, do you have any idea what can cause such problem?

There's currently a lot of bugs that I'm trying to wring out.

Yes, I see the same thing, but haven't had the time to investigate it
further. I have to push the few fixes I have in queue out after some tests,
and then I'll look into this. My main concern was that the "listen"
functionality broke, which is a regression!

-- Steve
