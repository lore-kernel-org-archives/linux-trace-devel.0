Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C4FC4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 15:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59FC6207F7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 15:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgI2PSZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 11:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgI2PSY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 11:18:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B519D20773;
        Tue, 29 Sep 2020 15:18:23 +0000 (UTC)
Date:   Tue, 29 Sep 2020 11:18:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zamir SUN <sztsian@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tstoyanov@vmware.com,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com
Subject: Re: Co-existing of traceevent of trace-cmd and perf
Message-ID: <20200929111821.7e1199ea@gandalf.local.home>
In-Reply-To: <3dc91d46-e359-472b-4faf-d9b324cc4c8d@gmail.com>
References: <1baba359-fd07-1a61-0158-e65c6b06425f@gmail.com>
        <3dc91d46-e359-472b-4faf-d9b324cc4c8d@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Sep 2020 22:16:33 +0800
Zamir SUN <sztsian@gmail.com> wrote:

> On 9/29/20 9:44 PM, Zamir SUN wrote:
> > Hi,
> > 
> > I'm packaging trace-cmd 2.9 into Fedora.
> > 
> > Back in trace-cmd 2.8, all the plugins are under 
> > $(libdir)/trace-cmd/plugins. While as of trace-cmd 2.9, I find the 
> > traceevent plugins are installed in $(libdir) by default. This brings up 
> > an interesting situation - the perf tool also contains a copy of the 
> > traceevent in the same directory. So this means trace-cmd and perf have 
> > file conflicts. In terms of packaging, this means users can only install 
> > one of them, not in parallel (at least for Fedora). So I'd like to see 
> > if there are existing proposals or suggestions for which one is expected 
> > to be used by other utilities? Or is there any official plan to move one 
> > of them to the other directory?
> > 
> > I'm copying Tzvetomir and Jiri as I think you're the first people for 
> > getting the plugins in this directory for trace-cmd and perf respectively.
> >   
> 
> Sorry, I just saw an email from Steven mentioning there will be a stand 
> alone libtraceevent. However I did not find it in git.kernel.org. So I 
> probably should ask if the stand alone version of libtraceevent is ready 
> now?

No but this gives me incentive to make it so very soon!

-- Steve

