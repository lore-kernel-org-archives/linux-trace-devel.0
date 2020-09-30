Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF885C4727C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 17:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A4D520754
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 17:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgI3R13 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 13:27:29 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:47992 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgI3R13 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 13:27:29 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2020 13:27:28 EDT
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id BDD4672CCDC;
        Wed, 30 Sep 2020 20:21:12 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id AD17A4A4AE9;
        Wed, 30 Sep 2020 20:21:12 +0300 (MSK)
Date:   Wed, 30 Sep 2020 20:21:12 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Zamir SUN <sztsian@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tstoyanov@vmware.com,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com
Subject: Re: Co-existing of traceevent of trace-cmd and perf
Message-ID: <20200930172112.qxb6shj5jkmlfpmt@altlinux.org>
References: <1baba359-fd07-1a61-0158-e65c6b06425f@gmail.com>
 <3dc91d46-e359-472b-4faf-d9b324cc4c8d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <3dc91d46-e359-472b-4faf-d9b324cc4c8d@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Zamir, Steven,

On Tue, Sep 29, 2020 at 10:16:33PM +0800, Zamir SUN wrote:
> On 9/29/20 9:44 PM, Zamir SUN wrote:
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
> > getting the plugins in this directory for trace-cmd and perf
> > respectively.
> > 
> 
> Sorry, I just saw an email from Steven mentioning there will be a stand
> alone libtraceevent. However I did not find it in git.kernel.org. So I
> probably should ask if the stand alone version of libtraceevent is ready
> now?

In anticipation of this change I temporary packaged (for ALT) traceevent
into %_libdir while keeping traceevent form perf in %_libexecdir (for a
backward compatibility).

Thanks,

> 
> Thanks.
> 
> > Thanks in advance.
> > 
> 
> -- 
> Zamir SUN
> Fedora user
> GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
